module uart_tx (
    input  wire       CLK,
    input  wire       RESET,

    input  wire [7:0] DATA_IN,
    input  wire       DATA_VALID,

    output reg        TX,
    output reg        BUSY
);

    // 100 MHz clock / 115200 baud
    localparam integer CLKS_PER_BIT = 868;

    // UART states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] STATE;

    // Counts FPGA clock cycles for each UART bit
    reg [15:0] CLK_COUNT;

    // Counts transmitted data bits
    reg [2:0] BIT_COUNT;

    // Stores the byte being transmitted
    reg [7:0] DATA_REG;


    always @(posedge CLK) begin

        if (RESET) begin

            STATE     <= IDLE;
            CLK_COUNT <= 16'd0;
            BIT_COUNT <= 3'd0;
            DATA_REG  <= 8'd0;

            TX        <= 1'b1;
            BUSY      <= 1'b0;
        end

        else begin

            case (STATE)

                // --------------------------------
                // IDLE
                // --------------------------------

                IDLE: begin

                    TX        <= 1'b1;
                    BUSY      <= 1'b0;

                    CLK_COUNT <= 16'd0;
                    BIT_COUNT <= 3'd0;

                    if (DATA_VALID) begin

                        DATA_REG <= DATA_IN;

                        BUSY  <= 1'b1;
                        STATE <= START;

                    end
                end


                // --------------------------------
                // START BIT
                // --------------------------------

                START: begin

                    TX   <= 1'b0;
                    BUSY <= 1'b1;

                    if (CLK_COUNT < CLKS_PER_BIT - 1) begin

                        CLK_COUNT <= CLK_COUNT + 1'b1;

                    end

                    else begin

                        CLK_COUNT <= 16'd0;
                        BIT_COUNT <= 3'd0;

                        STATE <= DATA;

                    end
                end


                // --------------------------------
                // DATA BITS
                // --------------------------------

                DATA: begin

                    TX   <= DATA_REG[BIT_COUNT];
                    BUSY <= 1'b1;

                    if (CLK_COUNT < CLKS_PER_BIT - 1) begin

                        CLK_COUNT <= CLK_COUNT + 1'b1;

                    end

                    else begin

                        CLK_COUNT <= 16'd0;

                        if (BIT_COUNT == 3'd7) begin

                            BIT_COUNT <= 3'd0;
                            STATE <= STOP;

                        end

                        else begin

                            BIT_COUNT <= BIT_COUNT + 1'b1;

                        end
                    end
                end


                // --------------------------------
                // STOP BIT
                // --------------------------------

                STOP: begin

                    TX   <= 1'b1;
                    BUSY <= 1'b1;

                    if (CLK_COUNT < CLKS_PER_BIT - 1) begin

                        CLK_COUNT <= CLK_COUNT + 1'b1;

                    end

                    else begin

                        CLK_COUNT <= 16'd0;

                        BUSY  <= 1'b0;
                        STATE <= IDLE;

                    end
                end


                // --------------------------------
                // DEFAULT
                // --------------------------------

                default: begin

                    STATE     <= IDLE;
                    CLK_COUNT <= 16'd0;
                    BIT_COUNT <= 3'd0;

                    TX   <= 1'b1;
                    BUSY <= 1'b0;

                end

            endcase
        end
    end

endmodule