`timescale 1ns / 1ps

module complete_buffered_packet_router_tb;

    //========================================================
    // Inputs
    //========================================================

    reg CLK;
    reg RESET;

    reg [9:0] PACKET_IN;
    reg VALID_IN;

    reg [3:0] READY_OUT;


    //========================================================
    // Outputs
    //========================================================

    wire READY_IN;
    wire [3:0] VALID_OUT;

    wire [9:0] PACKET_OUT0;
    wire [9:0] PACKET_OUT1;
    wire [9:0] PACKET_OUT2;
    wire [9:0] PACKET_OUT3;


    //========================================================
    // DUT
    //========================================================

    complete_buffered_packet_router DUT (

        .CLK        (CLK),
        .RESET      (RESET),

        .PACKET_IN  (PACKET_IN),
        .VALID_IN   (VALID_IN),

        .READY_OUT  (READY_OUT),

        .READY_IN   (READY_IN),
        .VALID_OUT  (VALID_OUT),

        .PACKET_OUT0(PACKET_OUT0),
        .PACKET_OUT1(PACKET_OUT1),
        .PACKET_OUT2(PACKET_OUT2),
        .PACKET_OUT3(PACKET_OUT3)
    );


    //========================================================
    // Clock
    //========================================================

    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end


    //========================================================
    // Test Sequence
    //========================================================

    initial begin

        // Initial values
        RESET     = 1'b1;
        PACKET_IN = 10'b0000000000;
        VALID_IN  = 1'b0;
        READY_OUT = 4'b1111;


        //====================================================
        // TEST 1: RESET
        //====================================================

        #20;

        RESET = 1'b0;

        $display("==============================================");
        $display("RESET RELEASED");
        $display("==============================================");


        //====================================================
        // TEST 2: Destination 0
        // Packet = 00 10101010
        //====================================================

        PACKET_IN = 10'b0010101010;
        VALID_IN  = 1'b1;

        #10;

        VALID_IN = 1'b0;

        $display("TEST 2: Destination 0");
        $display("Packet = %b", PACKET_IN);


        //====================================================
        // TEST 3: Destination 1
        // Packet = 01 11001100
        //====================================================

        #10;

        PACKET_IN = 10'b0111001100;
        VALID_IN  = 1'b1;

        #10;

        VALID_IN = 1'b0;

        $display("TEST 3: Destination 1");
        $display("Packet = %b", PACKET_IN);


        //====================================================
        // TEST 4: Destination 2
        // Packet = 10 11110000
        //====================================================

        #10;

        PACKET_IN = 10'b1011110000;
        VALID_IN  = 1'b1;

        #10;

        VALID_IN = 1'b0;

        $display("TEST 4: Destination 2");
        $display("Packet = %b", PACKET_IN);


        //====================================================
        // TEST 5: Destination 3
        // Packet = 11 00001111
        //====================================================

        #10;

        PACKET_IN = 10'b1100001111;
        VALID_IN  = 1'b1;

        #10;

        VALID_IN = 1'b0;

        $display("TEST 5: Destination 3");
        $display("Packet = %b", PACKET_IN);


        //====================================================
        // TEST 6: Multiple packets to FIFO 0
        //====================================================

        #10;

        PACKET_IN = 10'b0000000001;
        VALID_IN  = 1'b1;
        #10;

        PACKET_IN = 10'b0000000010;
        #10;

        PACKET_IN = 10'b0000000011;
        #10;

        PACKET_IN = 10'b0000000100;
        #10;

        VALID_IN = 1'b0;

        $display("TEST 6: Multiple packets to FIFO 0");


        //====================================================
        // TEST 7: Output backpressure
        //====================================================

        #10;

        READY_OUT = 4'b0000;

        $display("TEST 7: Output backpressure");
        $display("READY_OUT = %b", READY_OUT);

        #20;

        READY_OUT = 4'b1111;

        $display("Output ready again");


        //====================================================
        // TEST 8: Invalid input
        //====================================================

        #10;

        PACKET_IN = 10'b0011111111;
        VALID_IN  = 1'b0;

        #10;

        $display("TEST 8: VALID_IN = 0");


        //====================================================
        // Finish
        //====================================================

        #20;

        $display("==============================================");
        $display("BLOCK 9 SIMULATION COMPLETE");
        $display("==============================================");

        $finish;

    end


    //========================================================
    // Monitor
    //========================================================

    initial begin

        $monitor(
            "Time=%0t | RESET=%b | VALID_IN=%b | PACKET_IN=%b | READY_IN=%b | READY_OUT=%b | VALID_OUT=%b | OUT0=%b | OUT1=%b | OUT2=%b | OUT3=%b",
            $time,
            RESET,
            VALID_IN,
            PACKET_IN,
            READY_IN,
            READY_OUT,
            VALID_OUT,
            PACKET_OUT0,
            PACKET_OUT1,
            PACKET_OUT2,
            PACKET_OUT3
        );

    end

endmodule