module uart_rx(
    input wire CLK,RESET,RX,
    output reg [7:0] DATA_OUT,
    output reg DATA_VALID
);

    // UART timing
    // FPGA clock = 100 MHz
    // Baud rate   = 115200
    localparam integer CLKS_PER_BIT = 868;
    localparam integer HALF_BIT     = 434;

    // Receiver states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] STATE;

    // Counts FPGA clock cycles
    reg [15:0] CLK_COUNT;

    // Counts received UART data bits
    reg [2:0] BIT_COUNT;

    // Temporarily stores received byte
    reg [7:0] DATA_REG;

    always @(posedge CLK) begin

        if (RESET) begin

            STATE      <= IDLE;
            CLK_COUNT  <= 16'd0;
            BIT_COUNT  <= 3'd0;
            DATA_REG   <= 8'd0;
            DATA_OUT   <= 8'd0;
            DATA_VALID <= 1'b0;

        end

        else begin

            case (STATE)

                IDLE: begin

                    CLK_COUNT <= 16'd0;
                    BIT_COUNT <= 3'd0;

                    if (RX == 1'b0) begin
                        STATE <= START;
                    end

                end

                START: begin

                    if (CLK_COUNT < HALF_BIT - 1) begin
                        CLK_COUNT <= CLK_COUNT + 1'b1;
                    end

                    else begin

                        CLK_COUNT <= 16'd0;

                        if (RX == 1'b0) begin
                            STATE <= DATA;
                        end

                        else begin
                            STATE <= IDLE;
                        end

                    end

                end

                DATA: begin

                    if (CLK_COUNT < CLKS_PER_BIT - 1) begin
                        CLK_COUNT <= CLK_COUNT + 1'b1;
                    end

                    else begin

                        CLK_COUNT <= 16'd0;

                        DATA_REG[BIT_COUNT] <= RX;

                        if (BIT_COUNT == 3'd7) begin
                            STATE <= STOP;
                        end

                        else begin
                            BIT_COUNT <= BIT_COUNT + 1'b1;
                        end

                    end

                end

                STOP: begin

                    if (CLK_COUNT < CLKS_PER_BIT - 1) begin
                        CLK_COUNT <= CLK_COUNT + 1'b1;
                    end

                    else begin

                        CLK_COUNT <= 16'd0;

                        if (RX == 1'b1) begin

                            DATA_OUT   <= DATA_REG;
                            DATA_VALID <= 1'b1;

                        end

                        STATE <= IDLE;

                    end

                end

            endcase

        end

    end
endmodule