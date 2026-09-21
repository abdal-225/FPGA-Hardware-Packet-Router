module fifo_ram_tb;

    reg clk, clr, str, ld;

    reg [2:0] addr;
    reg [9:0] data_in;

    wire [9:0] data_out;

    fifo_ram DUT (clk,clr,str,ld,addr,data_in,data_out);

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        clr = 1'b0;
        str = 1'b0;
        ld = 1'b0;

        addr = 3'b000;
        data_in = 10'b0000000000;


        // Reset RAM
        clr = 1'b1; #10;
        clr = 1'b0; #10;


        // Write packet to address 000
        addr = 3'b000; data_in = 10'b1011110000; 
        str = 1'b1; #10;
        str = 1'b0; #10;


        // Read packet from address 000
        addr = 3'b000; 
        ld = 1'b1; #10;
        ld = 1'b0; #10;


        // Write packet to address 001
        addr = 3'b001; data_in = 10'b0101010101; 
        str = 1'b1; #10;
        str = 1'b0; #10;


        // Read packet from address 001
        addr = 3'b001;
        ld = 1'b1; #10;
        ld = 1'b0; #10;

        $finish;

    end

endmodule