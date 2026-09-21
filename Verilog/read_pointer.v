module read_pointer (
    input clk, reset, read_en,
    output [2:0] read_addr
);

    reg [2:0] read_addr_reg;

    assign read_addr = read_addr_reg;

    always @(posedge clk) begin

        if (reset)
            read_addr_reg <= 3'b000;

        else if (read_en)
            read_addr_reg <= read_addr_reg + 3'b001;

    end

endmodule