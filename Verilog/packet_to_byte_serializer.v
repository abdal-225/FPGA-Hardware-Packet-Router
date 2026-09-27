module packet_to_byte_serializer (

    input  wire        CLK,
    input  wire        RESET,

    // ==================================================
    // Packet from Output UART Arbiter
    // ==================================================

    input  wire [9:0]  PACKET_IN,
    input  wire        PACKET_VALID,

    // ==================================================
    // Interface to UART TX
    // ==================================================

    input  wire        UART_BUSY,

    output reg  [7:0]  UART_DATA,
    output reg         UART_DATA_VALID,

    // ==================================================
    // Handshake with Output UART Arbiter
    // ==================================================

    output reg         PACKET_READY
);


    // ==================================================
    // FSM STATES
    // ==================================================

    localparam IDLE            = 4'b0000;

    localparam SEND_DEST       = 4'b0001;
    localparam WAIT_DEST_START = 4'b0010;
    localparam WAIT_DEST_DONE  = 4'b0011;

    localparam SEND_DATA       = 4'b0100;
    localparam WAIT_DATA_START = 4'b0101;
    localparam WAIT_DATA_DONE  = 4'b0110;


    reg [3:0] STATE;


    // ==================================================
    // STORED PACKET
    // ==================================================

    reg [9:0] PACKET_REG;


    // ==================================================
    // MAIN FSM
    // ==================================================

    always @(posedge CLK) begin

        if (RESET) begin

            STATE           <= IDLE;

            PACKET_REG      <= 10'b0;

            UART_DATA       <= 8'b0;
            UART_DATA_VALID <= 1'b0;

            PACKET_READY    <= 1'b1;

        end

        else begin

            // ------------------------------------------
            // DATA_VALID is a one-clock pulse
            // ------------------------------------------

            UART_DATA_VALID <= 1'b0;


            case (STATE)


                // ==================================================
                // IDLE
                // Wait for a packet from arbiter
                // ==================================================

                IDLE: begin

                    PACKET_READY <= 1'b1;


                    if (PACKET_VALID && PACKET_READY) begin

                        // Store complete packet
                        PACKET_REG <= PACKET_IN;

                        // No longer ready for another packet
                        PACKET_READY <= 1'b0;

                        STATE <= SEND_DEST;

                    end

                end


                // ==================================================
                // SEND DESTINATION BYTE
                // ==================================================

                SEND_DEST: begin

                    // Destination is converted to one byte
                    //
                    // Example:
                    //
                    // destination 0 -> 00
                    // destination 1 -> 01
                    // destination 2 -> 02
                    // destination 3 -> 03

                    UART_DATA <= {
                        6'b000000,
                        PACKET_REG[9:8]
                    };


                    UART_DATA_VALID <= 1'b1;


                    // IMPORTANT:
                    // Do not immediately check UART_BUSY.
                    // UART TX sees DATA_VALID on the next clock.

                    STATE <= WAIT_DEST_START;

                end


                // ==================================================
                // WAIT UNTIL UART TX ACTUALLY BECOMES BUSY
                // ==================================================

                WAIT_DEST_START: begin

                    UART_DATA_VALID <= 1'b0;


                    if (UART_BUSY) begin

                        STATE <= WAIT_DEST_DONE;

                    end

                end


                // ==================================================
                // WAIT UNTIL DESTINATION BYTE FINISHES
                // ==================================================

                WAIT_DEST_DONE: begin

                    UART_DATA_VALID <= 1'b0;


                    if (!UART_BUSY) begin

                        STATE <= SEND_DATA;

                    end

                end


                // ==================================================
                // SEND DATA BYTE
                // ==================================================

                SEND_DATA: begin

                    UART_DATA <= PACKET_REG[7:0];

                    UART_DATA_VALID <= 1'b1;


                    STATE <= WAIT_DATA_START;

                end


                // ==================================================
                // WAIT UNTIL UART TX BECOMES BUSY
                // ==================================================

                WAIT_DATA_START: begin

                    UART_DATA_VALID <= 1'b0;


                    if (UART_BUSY) begin

                        STATE <= WAIT_DATA_DONE;

                    end

                end


                // ==================================================
                // WAIT UNTIL DATA BYTE FINISHES
                // ==================================================

                WAIT_DATA_DONE: begin

                    UART_DATA_VALID <= 1'b0;


                    if (!UART_BUSY) begin

                        // Packet transmission complete
                        PACKET_READY <= 1'b1;

                        STATE <= IDLE;

                    end

                end


                // ==================================================
                // DEFAULT
                // ==================================================

                default: begin

                    STATE           <= IDLE;

                    PACKET_READY    <= 1'b1;

                    UART_DATA_VALID <= 1'b0;

                    UART_DATA       <= 8'b0;

                    PACKET_REG      <= 10'b0;

                end

            endcase

        end

    end

endmodule