module write_pointer_tb;

    reg clk;
    reg reset;
    reg write_en;

    wire [2:0] write_addr;

    write_pointer DUT (
        clk,
        reset,
        write_en,
        write_addr
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        reset = 1'b0;
        write_en = 1'b0;


        // Reset
        reset = 1'b1;
        #10;

        reset = 1'b0;
        #10;


        // Write enable
        write_en = 1'b1;
        #10;

        write_en = 1'b0;
        #10;


        // Second write
        write_en = 1'b1;
        #10;

        write_en = 1'b0;
        #10;


        // Multiple writes
        write_en = 1'b1;
        #80;

        write_en = 1'b0;
        #10;


        $finish;

    end

endmodule