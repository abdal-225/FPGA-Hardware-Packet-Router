module write_pointer (
    input        clk, reset, write_en,
    output [2:0] write_addr
);

    reg [2:0] write_addr_reg;

    assign write_addr = write_addr_reg;

    always @(posedge clk) begin

        if (reset)
            write_addr_reg <= 3'b000;

        else if (write_en)
            write_addr_reg <= write_addr_reg + 3'b001;

    end

endmodule