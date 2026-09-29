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

    // Arbiter states
    localparam IDLE      = 2'b00;
    localparam WAIT_READ = 2'b01;
    localparam SEND      = 2'b10;

    reg [1:0] STATE;


    // ==================================================
    // Select one output using round-robin priority
    // ==================================================

    always @(*) begin

        READY_OUT = 4'b0000;

        // Generate a read request only in IDLE.
        // The FIFO will update PACKET_OUT on the
        // following clock cycle.
        if (STATE == IDLE && PACKET_READY) begin

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

            PRIORITY        <= 2'd0;
            BUSY            <= 1'b0;
            SELECTED_OUTPUT <= 2'd0;

            PACKET_DATA     <= 10'b0;
            PACKET_VALID    <= 1'b0;

            STATE           <= IDLE;

        end else begin

            case (STATE)

                // ======================================
                // IDLE
                // ======================================

                IDLE: begin

                    PACKET_VALID <= 1'b0;
                    BUSY <= 1'b0;

                    // A valid output has been selected.
                    // READY_OUT requests the FIFO read.
                    if (READY_OUT != 4'b0000) begin

                        BUSY <= 1'b1;

                        case (READY_OUT)

                            4'b0001:
                                SELECTED_OUTPUT <= 2'd0;

                            4'b0010:
                                SELECTED_OUTPUT <= 2'd1;

                            4'b0100:
                                SELECTED_OUTPUT <= 2'd2;

                            4'b1000:
                                SELECTED_OUTPUT <= 2'd3;

                            default:
                                SELECTED_OUTPUT <= 2'd0;

                        endcase

                        // Wait one clock for the synchronous
                        // FIFO output to update.
                        STATE <= WAIT_READ;
                    end
                end


                // ======================================
                // WAIT_READ
                // ======================================

                WAIT_READ: begin

                    // FIFO output is now updated.
                    // Capture the selected packet.
                    case (SELECTED_OUTPUT)

                        2'd0:
                            PACKET_DATA <= PACKET_OUT0;

                        2'd1:
                            PACKET_DATA <= PACKET_OUT1;

                        2'd2:
                            PACKET_DATA <= PACKET_OUT2;

                        2'd3:
                            PACKET_DATA <= PACKET_OUT3;

                        default:
                            PACKET_DATA <= 10'b0;

                    endcase

                    // Tell serializer that packet is ready.
                    PACKET_VALID <= 1'b1;

                    STATE <= SEND;

                end


                // ======================================
                // SEND
                // ======================================

                SEND: begin

                    // Wait until serializer accepts packet.
                    if (PACKET_READY) begin

                        PACKET_VALID <= 1'b0;
                        BUSY <= 1'b0;

                        // Move round-robin priority.
                        case (SELECTED_OUTPUT)

                            2'd0:
                                PRIORITY <= 2'd1;

                            2'd1:
                                PRIORITY <= 2'd2;

                            2'd2:
                                PRIORITY <= 2'd3;

                            2'd3:
                                PRIORITY <= 2'd0;

                            default:
                                PRIORITY <= 2'd0;

                        endcase

                        STATE <= IDLE;
                    end
                end


                // ======================================
                // DEFAULT
                // ======================================

                default: begin

                    STATE <= IDLE;
                    BUSY <= 1'b0;
                    PACKET_VALID <= 1'b0;
                    PACKET_DATA <= 10'b0;

                end

            endcase
        end
    end

endmodule