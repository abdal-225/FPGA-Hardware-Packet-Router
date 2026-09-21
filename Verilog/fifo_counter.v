module fifo_counter (
    input        clk, reset, write_en, read_en,
    output [3:0] count,
    output       full,empty
);

    reg [3:0] count_reg;

    assign count = count_reg;

    assign full  = (count_reg == 4'b1000);
    assign empty = (count_reg == 4'b0000);

    always @(posedge clk) begin

        if (reset) begin

            count_reg <= 4'b0000;

        end

        else begin

            case ({write_en, read_en})

                2'b10: begin
                    if (!full)
                        count_reg <= count_reg + 4'b0001;
                end

                2'b01: begin
                    if (!empty)
                        count_reg <= count_reg - 4'b0001;
                end

                2'b11: begin
                    count_reg <= count_reg;
                end

                2'b00: begin
                    count_reg <= count_reg;
                end

            endcase

        end

    end

endmodule