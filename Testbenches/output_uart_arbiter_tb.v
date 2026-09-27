`timescale 1ns / 1ps

module output_uart_arbiter_tb;

    reg CLK;
    reg RESET;

    reg [9:0] PACKET_OUT0;
    reg [9:0] PACKET_OUT1;
    reg [9:0] PACKET_OUT2;
    reg [9:0] PACKET_OUT3;

    reg [3:0] VALID_OUT;

    reg TX_READY;

    wire [3:0] READY_OUT;
    wire [9:0] TX_DATA;
    wire TX_VALID;


    // ----------------------------------------
    // DUT
    // ----------------------------------------

    output_uart_arbiter DUT (

        .CLK(CLK),
        .RESET(RESET),

        .PACKET_OUT0(PACKET_OUT0),
        .PACKET_OUT1(PACKET_OUT1),
        .PACKET_OUT2(PACKET_OUT2),
        .PACKET_OUT3(PACKET_OUT3),

        .VALID_OUT(VALID_OUT),

        .TX_READY(TX_READY),

        .READY_OUT(READY_OUT),

        .TX_DATA(TX_DATA),
        .TX_VALID(TX_VALID)
    );


    // ----------------------------------------
    // Clock
    // ----------------------------------------

    initial begin

        CLK = 1'b0;

        forever #5 CLK = ~CLK;

    end


    // ----------------------------------------
    // Tests
    // ----------------------------------------

    initial begin

        // Initial values

        RESET = 1'b1;

        PACKET_OUT0 = 10'b0000000000;
        PACKET_OUT1 = 10'b0000000000;
        PACKET_OUT2 = 10'b0000000000;
        PACKET_OUT3 = 10'b0000000000;

        VALID_OUT = 4'b0000;

        TX_READY = 1'b0;


        // ------------------------------------
        // Reset
        // ------------------------------------

        #20;

        RESET = 1'b0;


        // ====================================
        // TEST 1
        // Only FIFO 0 has packet
        // ====================================

        PACKET_OUT0 = 10'b0010101010;

        VALID_OUT = 4'b0001;

        TX_READY = 1'b1;

        #10;

        $display("--------------------------------");
        $display("TEST 1");
        $display("VALID_OUT = %b", VALID_OUT);
        $display("READY_OUT = %b", READY_OUT);
        $display("TX_DATA   = %b", TX_DATA);
        $display("TX_VALID  = %b", TX_VALID);
        $display("--------------------------------");


        #20;

        VALID_OUT = 4'b0000;

        TX_READY = 1'b0;


        // ====================================
        // TEST 2
        // Only FIFO 2 has packet
        // ====================================

        #20;

        PACKET_OUT2 = 10'b1011110000;

        VALID_OUT = 4'b0100;

        TX_READY = 1'b1;

        #10;

        $display("--------------------------------");
        $display("TEST 2");
        $display("VALID_OUT = %b", VALID_OUT);
        $display("READY_OUT = %b", READY_OUT);
        $display("TX_DATA   = %b", TX_DATA);
        $display("TX_VALID  = %b", TX_VALID);
        $display("--------------------------------");


        #20;

        VALID_OUT = 4'b0000;

        TX_READY = 1'b0;


        // ====================================
        // TEST 3
        // All four FIFOs have packets
        // ====================================

        #20;

        PACKET_OUT0 = 10'b0000000001;
        PACKET_OUT1 = 10'b0100000010;
        PACKET_OUT2 = 10'b1000000011;
        PACKET_OUT3 = 10'b1100000100;

        VALID_OUT = 4'b1111;

        TX_READY = 1'b1;

        #10;

        $display("--------------------------------");
        $display("TEST 3");
        $display("All four outputs valid");
        $display("READY_OUT = %b", READY_OUT);
        $display("TX_DATA   = %b", TX_DATA);
        $display("TX_VALID  = %b", TX_VALID);
        $display("--------------------------------");


        #20;

        // Keep outputs valid
        // to test round-robin behavior

        $display("Round-robin test continues...");

        #20;

        $display("READY_OUT = %b", READY_OUT);
        $display("TX_DATA   = %b", TX_DATA);


        #20;

        $display("READY_OUT = %b", READY_OUT);
        $display("TX_DATA   = %b", TX_DATA);


        #20;

        $display("READY_OUT = %b", READY_OUT);
        $display("TX_DATA   = %b", TX_DATA);


        // ------------------------------------
        // End
        // ------------------------------------

        #20;

        VALID_OUT = 4'b0000;

        TX_READY = 1'b0;

        $display("======================================");
        $display("OUTPUT UART ARBITER TEST COMPLETE");
        $display("======================================");

        $finish;

    end


    // ----------------------------------------
    // Monitor
    // ----------------------------------------

    initial begin

        $monitor(
            "Time=%0t | VALID_OUT=%b | READY_OUT=%b | TX_READY=%b | TX_VALID=%b | TX_DATA=%b",
            $time,
            VALID_OUT,
            READY_OUT,
            TX_READY,
            TX_VALID,
            TX_DATA
        );

    end

endmodule