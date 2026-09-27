`timescale 1ns / 1ps

module packet_input_interface_tb;

    reg CLK;
    reg RESET;

    reg [7:0] RX_DATA;
    reg       RX_VALID;

    reg       READY_IN;

    wire [9:0] PACKET_OUT;
    wire       VALID_OUT;


    // ----------------------------------------
    // DUT
    // ----------------------------------------

    packet_input_interface DUT (

        .CLK        (CLK),
        .RESET      (RESET),

        .RX_DATA    (RX_DATA),
        .RX_VALID   (RX_VALID),

        .PACKET_OUT (PACKET_OUT),
        .VALID_OUT  (VALID_OUT),

        .READY_IN   (READY_IN)

    );


    // ----------------------------------------
    // 100 MHz clock
    // ----------------------------------------

    initial begin

        CLK = 1'b0;

        forever #5 CLK = ~CLK;

    end


    // ----------------------------------------
    // Test
    // ----------------------------------------

    initial begin

        RESET    = 1'b1;
        RX_DATA  = 8'h00;
        RX_VALID = 1'b0;
        READY_IN = 1'b0;

        // Reset
        #100;

        RESET = 1'b0;


        // =====================================
        // TEST 1
        // Destination = 0
        // Data = AA
        // =====================================

        RX_DATA  = 8'h00;
        RX_VALID = 1'b1;

        #10;

        RX_VALID = 1'b0;

        #10;


        RX_DATA  = 8'hAA;
        RX_VALID = 1'b1;

        #10;

        RX_VALID = 1'b0;

        #10;


        // Router is now ready
        READY_IN = 1'b1;

        #10;

        READY_IN = 1'b0;

        #20;


        // =====================================
        // TEST 2
        // Destination = 2
        // Data = 55
        // =====================================

        RX_DATA  = 8'h02;
        RX_VALID = 1'b1;

        #10;

        RX_VALID = 1'b0;

        #10;


        RX_DATA  = 8'h55;
        RX_VALID = 1'b1;

        #10;

        RX_VALID = 1'b0;

        #20;

        READY_IN = 1'b1;

        #10;

        READY_IN = 1'b0;

        #20;


        // =====================================
        // TEST 3
        // Destination = 3
        // Data = F0
        // =====================================

        RX_DATA  = 8'h03;
        RX_VALID = 1'b1;

        #10;

        RX_VALID = 1'b0;

        #10;


        RX_DATA  = 8'hF0;
        RX_VALID = 1'b1;

        #10;

        RX_VALID = 1'b0;

        #20;

        READY_IN = 1'b1;

        #10;

        READY_IN = 1'b0;

        #20;


        // =====================================
        // TEST COMPLETE
        // =====================================

        $display("======================================");
        $display("PACKET INPUT INTERFACE TEST COMPLETE");
        $display("======================================");

        $finish;

    end


    // ----------------------------------------
    // Monitor
    // ----------------------------------------

    initial begin

        $monitor(
            "Time=%0t | RX_DATA=%h | RX_VALID=%b | READY_IN=%b | PACKET_OUT=%b | VALID_OUT=%b",
            $time,
            RX_DATA,
            RX_VALID,
            READY_IN,
            PACKET_OUT,
            VALID_OUT
        );

    end

endmodule