module fifo_ram (
    input        clk,clr,str,ld,
    input  [2:0] addr,
    input  [9:0] data_in,
    output [9:0] data_out
);

    reg [9:0] mem [0:7];
    reg [9:0] data_out_reg;

    integer i;

    assign data_out = data_out_reg;

    always @(posedge clk) begin

        if (clr) begin

            for (i = 0; i < 8; i = i + 1)
                mem[i] <= 10'b0000000000;

            data_out_reg <= 10'b0000000000;

        end

        else begin

            if (str)
                mem[addr] <= data_in;

            if (ld)
                data_out_reg <= mem[addr];

        end

    end

endmodule