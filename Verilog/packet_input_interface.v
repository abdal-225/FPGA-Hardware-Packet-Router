module packet_input_interface (

    input  wire       CLK,
    input  wire       RESET,

    // From UART Receiver
    input  wire [7:0] RX_DATA,
    input  wire       RX_VALID,

    // To Packet Router
    output reg [9:0]  PACKET_OUT,
    output reg        VALID_OUT,
    input  wire       READY_IN

);

    // ----------------------------------------
    // State definitions
    // ----------------------------------------

    localparam WAIT_DEST = 2'b00;
    localparam WAIT_DATA = 2'b01;
    localparam SEND      = 2'b10;

    reg [1:0] STATE;

    // Stores the destination received from UART
    reg [1:0] DESTINATION;

    // Stores the data byte received from UART
    reg [7:0] DATA_BYTE;


    // ----------------------------------------
    // Main sequential logic
    // ----------------------------------------

    always @(posedge CLK) begin

        if (RESET) begin

            STATE       <= WAIT_DEST;

            DESTINATION <= 2'b00;
            DATA_BYTE   <= 8'b0;

            PACKET_OUT  <= 10'b0;
            VALID_OUT   <= 1'b0;

        end

        else begin

            case (STATE)


                // ====================================
                // WAIT FOR DESTINATION BYTE
                // ====================================

                WAIT_DEST: begin

                    VALID_OUT <= 1'b0;

                    if (RX_VALID) begin

                        // Destination is only 2 bits
                        DESTINATION <= RX_DATA[1:0];

                        STATE <= WAIT_DATA;

                    end

                end


                // ====================================
                // WAIT FOR DATA BYTE
                // ====================================

                WAIT_DATA: begin

                    if (RX_VALID) begin

                        DATA_BYTE <= RX_DATA;

                        // Construct 10-bit packet
                        PACKET_OUT <= {
                            DESTINATION,
                            RX_DATA
                        };

                        VALID_OUT <= 1'b1;

                        STATE <= SEND;

                    end

                end


                // ====================================
                // SEND PACKET TO ROUTER
                // ====================================

                SEND: begin

                    // Keep packet valid until router accepts it

                    if (READY_IN) begin

                        VALID_OUT <= 1'b0;

                        STATE <= WAIT_DEST;

                    end

                end


                // ====================================
                // DEFAULT
                // ====================================

                default: begin

                    STATE      <= WAIT_DEST;
                    VALID_OUT  <= 1'b0;

                end

            endcase

        end

    end

endmodule