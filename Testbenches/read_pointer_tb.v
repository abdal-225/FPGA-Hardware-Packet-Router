module read_pointer_tb;

    reg clk;
    reg reset;
    reg read_en;

    wire [2:0] read_addr;

    read_pointer DUT (
        clk,
        reset,
        read_en,
        read_addr
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        reset = 1'b0;
        read_en = 1'b0;


        // Reset
        reset = 1'b1;
        #10;

        reset = 1'b0;
        #10;


        // Read enable
        read_en = 1'b1;
        #10;

        read_en = 1'b0;
        #10;


        // Second read
        read_en = 1'b1;
        #10;

        read_en = 1'b0;
        #10;


        // Multiple reads
        read_en = 1'b1;
        #80;

        read_en = 1'b0;
        #10;


        $finish;

    end

endmodule