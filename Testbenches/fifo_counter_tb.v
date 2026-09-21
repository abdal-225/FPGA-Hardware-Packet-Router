module fifo_counter_tb;

    reg clk;
    reg reset;
    reg write_en;
    reg read_en;

    wire [3:0] count;
    wire full;
    wire empty;

    fifo_counter DUT (
        clk,
        reset,
        write_en,
        read_en,
        count,
        full,
        empty
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        reset = 1'b0;
        write_en = 1'b0;
        read_en = 1'b0;


        // Reset
        reset = 1'b1;
        #10;

        reset = 1'b0;
        #10;


        // Write
        write_en = 1'b1;
        read_en = 1'b0;
        #10;

        write_en = 1'b0;
        #10;


        // Write again
        write_en = 1'b1;
        #10;

        write_en = 1'b0;
        #10;


        // Read
        read_en = 1'b1;
        #10;

        read_en = 1'b0;
        #10;


        // Simultaneous read and write
        write_en = 1'b1;
        read_en = 1'b1;
        #10;

        write_en = 1'b0;
        read_en = 1'b0;
        #10;


        // Fill counter
        write_en = 1'b1;
        #70;

        write_en = 1'b0;
        #10;


        // Try write when full
        write_en = 1'b1;
        #10;

        write_en = 1'b0;
        #10;


        // Empty counter
        read_en = 1'b1;
        #80;

        read_en = 1'b0;
        #10;


        $finish;

    end

endmodule