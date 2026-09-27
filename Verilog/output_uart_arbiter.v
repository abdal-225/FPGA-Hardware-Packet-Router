module output_uart_arbiter (
    input wire        CLK,
    input wire        RESET,

    // Router outputs
    input wire [9:0]  PACKET_OUT0,
    input wire [9:0]  PACKET_OUT1,
    input wire [9:0]  PACKET_OUT2,
    input wire [9:0]  PACKET_OUT3,

    input wire [3:0]  VALID_OUT,

    // Handshake with Packet-to-Byte Serializer
    input wire        PACKET_READY,

    // Handshake with Router
    output reg [3:0]  READY_OUT,

    // Selected packet for serializer
    output reg [9:0]  PACKET_DATA,
    output reg        PACKET_VALID
);

    reg [1:0] PRIORITY;
    reg       BUSY;

    reg [1:0] SELECTED_OUTPUT;


    // ==================================================
    // Select one output using round-robin priority
    // ==================================================

    always @(*) begin

        READY_OUT = 4'b0000;

        if (!BUSY && PACKET_READY) begin

            case (PRIORITY)

                2'd0: begin
                    if      (VALID_OUT[0]) READY_OUT = 4'b0001;
                    else if (VALID_OUT[1]) READY_OUT = 4'b0010;
                    else if (VALID_OUT[2]) READY_OUT = 4'b0100;
                    else if (VALID_OUT[3]) READY_OUT = 4'b1000;
                end

                2'd1: begin
                    if      (VALID_OUT[1]) READY_OUT = 4'b0010;
                    else if (VALID_OUT[2]) READY_OUT = 4'b0100;
                    else if (VALID_OUT[3]) READY_OUT = 4'b1000;
                    else if (VALID_OUT[0]) READY_OUT = 4'b0001;
                end

                2'd2: begin
                    if      (VALID_OUT[2]) READY_OUT = 4'b0100;
                    else if (VALID_OUT[3]) READY_OUT = 4'b1000;
                    else if (VALID_OUT[0]) READY_OUT = 4'b0001;
                    else if (VALID_OUT[1]) READY_OUT = 4'b0010;
                end

                2'd3: begin
                    if      (VALID_OUT[3]) READY_OUT = 4'b1000;
                    else if (VALID_OUT[0]) READY_OUT = 4'b0001;
                    else if (VALID_OUT[1]) READY_OUT = 4'b0010;
                    else if (VALID_OUT[2]) READY_OUT = 4'b0100;
                end

                default:
                    READY_OUT = 4'b0000;

            endcase
        end
    end


    // ==================================================
    // Packet capture and handshake
    // ==================================================

    always @(posedge CLK) begin

        if (RESET) begin

            PRIORITY       <= 2'd0;
            BUSY           <= 1'b0;
            SELECTED_OUTPUT <= 2'd0;

            PACKET_DATA    <= 10'b0;
            PACKET_VALID   <= 1'b0;

        end else begin

            // ------------------------------------------
            // IDLE: select a packet
            // ------------------------------------------

            if (!BUSY) begin

                PACKET_VALID <= 1'b0;

                if (READY_OUT != 4'b0000) begin

                    BUSY <= 1'b1;

                    case (READY_OUT)

                        4'b0001: begin
                            PACKET_DATA <= PACKET_OUT0;
                            SELECTED_OUTPUT <= 2'd0;
                        end

                        4'b0010: begin
                            PACKET_DATA <= PACKET_OUT1;
                            SELECTED_OUTPUT <= 2'd1;
                        end

                        4'b0100: begin
                            PACKET_DATA <= PACKET_OUT2;
                            SELECTED_OUTPUT <= 2'd2;
                        end

                        4'b1000: begin
                            PACKET_DATA <= PACKET_OUT3;
                            SELECTED_OUTPUT <= 2'd3;
                        end

                        default: begin
                            PACKET_DATA <= 10'b0;
                            SELECTED_OUTPUT <= 2'd0;
                        end

                    endcase

                    PACKET_VALID <= 1'b1;
                end

            end

            // ------------------------------------------
            // BUSY: wait for serializer to accept packet
            // ------------------------------------------

            else begin

                if (PACKET_READY) begin

                    PACKET_VALID <= 1'b0;
                    BUSY <= 1'b0;

                    // Move round-robin priority
                    case (SELECTED_OUTPUT)

                        2'd0: PRIORITY <= 2'd1;
                        2'd1: PRIORITY <= 2'd2;
                        2'd2: PRIORITY <= 2'd3;
                        2'd3: PRIORITY <= 2'd0;

                        default:
                            PRIORITY <= 2'd0;

                    endcase
                end
            end
        end
    end

endmodule