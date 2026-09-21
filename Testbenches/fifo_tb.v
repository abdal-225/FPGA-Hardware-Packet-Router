module fifo_tb;

    reg clk;
    reg reset;

    reg write_en;
    reg read_en;

    reg read_mode;

    reg [9:0] data_in;

    wire [9:0] data_out;
    wire [3:0] count;

    wire full;
    wire empty;


    fifo DUT (
        clk,
        reset,
        write_en,
        read_en,
        read_mode,
        data_in,
        data_out,
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

        read_mode = 1'b0;

        data_in = 10'b0000000000;


        // =================================
        // TEST 1 : RESET
        // =================================

        reset = 1'b1;
        #10;

        reset = 1'b0;
        #10;


        // =================================
        // TEST 2 : WRITE PACKET 1
        // =================================

        write_en = 1'b1;
        read_mode = 1'b0;

        data_in = 10'b1011110000;

        #10;

        write_en = 1'b0;
        #10;


        // =================================
        // TEST 3 : WRITE PACKET 2
        // =================================

        write_en = 1'b1;

        data_in = 10'b0101010101;

        #10;

        write_en = 1'b0;
        #10;


        // =================================
        // TEST 4 : WRITE PACKET 3
        // =================================

        write_en = 1'b1;

        data_in = 10'b1100110011;

        #10;

        write_en = 1'b0;
        #10;


        // =================================
        // TEST 5 : WRITE PACKET 4
        // =================================

        write_en = 1'b1;

        data_in = 10'b0011001100;

        #10;

        write_en = 1'b0;
        #10;


        // =================================
        // TEST 6 : READ PACKET 1
        // =================================

        read_mode = 1'b1;
        read_en = 1'b1;

        #10;

        read_en = 1'b0;
        #10;


        // =================================
        // TEST 7 : READ PACKET 2
        // =================================

        read_en = 1'b1;

        #10;

        read_en = 1'b0;
        #10;


        // =================================
        // TEST 8 : READ PACKET 3
        // =================================

        read_en = 1'b1;

        #10;

        read_en = 1'b0;
        #10;


        // =================================
        // TEST 9 : READ PACKET 4
        // =================================

        read_en = 1'b1;

        #10;

        read_en = 1'b0;
        #10;


        // =================================
        // TEST 10 : SIMULTANEOUS READ + WRITE
        // =================================

        // First put one packet into FIFO

        read_mode = 1'b0;

        write_en = 1'b1;
        read_en = 1'b0;

        data_in = 10'b1111000011;

        #10;

        write_en = 1'b0;
        #10;


        // Simultaneous read and write

        read_mode = 1'b1;

        write_en = 1'b1;
        read_en = 1'b1;

        data_in = 10'b0000111100;

        #10;

        write_en = 1'b0;
        read_en = 1'b0;

        #10;


        // =================================
        // END
        // =================================

        $finish;

    end

endmodule