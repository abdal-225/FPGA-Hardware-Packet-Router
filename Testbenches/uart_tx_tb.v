`timescale 1ns / 1ps

module uart_tx_tb;

    reg CLK;
    reg RESET;

    reg [7:0] DATA_IN;
    reg DATA_VALID;

    wire TX;
    wire BUSY;


    // ----------------------------------------
    // DUT
    // ----------------------------------------

    uart_tx DUT (

        .CLK(CLK),
        .RESET(RESET),

        .DATA_IN(DATA_IN),
        .DATA_VALID(DATA_VALID),

        .TX(TX),
        .BUSY(BUSY)
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

        RESET     = 1'b1;
        DATA_IN   = 8'h00;
        DATA_VALID = 1'b0;


        // ------------------------------------
        // Reset
        // ------------------------------------

        #100;

        RESET = 1'b0;


        // ====================================
        // TEST 1
        // Send A5
        // ====================================

        #100;

        DATA_IN    = 8'hA5;
        DATA_VALID = 1'b1;

        #10;

        DATA_VALID = 1'b0;


        // Wait for complete transmission
        // 10 UART bits × 8680 ns

        #86800;


        $display("--------------------------------");
        $display("TEST 1 COMPLETE");
        $display("DATA_IN = %h", DATA_IN);
        $display("TX      = %b", TX);
        $display("BUSY    = %b", BUSY);
        $display("--------------------------------");


        // ====================================
        // TEST 2
        // Send 55
        // ====================================

        #100;

        DATA_IN    = 8'h55;
        DATA_VALID = 1'b1;

        #10;

        DATA_VALID = 1'b0;


        #86800;


        $display("--------------------------------");
        $display("TEST 2 COMPLETE");
        $display("DATA_IN = %h", DATA_IN);
        $display("TX      = %b", TX);
        $display("BUSY    = %b", BUSY);
        $display("--------------------------------");


        // ====================================
        // TEST 3
        // Send FF
        // ====================================

        #100;

        DATA_IN    = 8'hFF;
        DATA_VALID = 1'b1;

        #10;

        DATA_VALID = 1'b0;


        #86800;


        $display("--------------------------------");
        $display("TEST 3 COMPLETE");
        $display("DATA_IN = %h", DATA_IN);
        $display("TX      = %b", TX);
        $display("BUSY    = %b", BUSY);
        $display("--------------------------------");


        // ====================================
        // TEST COMPLETE
        // ====================================

        #100;

        $display("======================================");
        $display("UART TX SIMULATION COMPLETE");
        $display("======================================");

        $finish;

    end


    // ----------------------------------------
    // Monitor
    // ----------------------------------------

    initial begin

        $monitor(
            "Time=%0t | DATA_IN=%h | DATA_VALID=%b | TX=%b | BUSY=%b",
            $time,
            DATA_IN,
            DATA_VALID,
            TX,
            BUSY
        );

    end

endmodule