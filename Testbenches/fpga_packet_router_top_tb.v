`timescale 1ns / 1ps

module fpga_packet_router_top_tb;

    // =========================================================
    // PARAMETERS
    // =========================================================

    localparam integer CLK_PERIOD   = 10;
    localparam integer CLKS_PER_BIT = 868;
    localparam integer BIT_TIME     = CLKS_PER_BIT * CLK_PERIOD;


    // =========================================================
    // DUT SIGNALS
    // =========================================================

    reg CLK;
    reg RESET;

    reg UART_RX;
    wire UART_TX;


    // =========================================================
    // RECEIVED BYTES
    // =========================================================

    reg [7:0] RX_DESTINATION;
    reg [7:0] RX_DATA_BYTE;


    // =========================================================
    // TEST STATUS
    // =========================================================

    reg RECEIVER_DONE;


    // =========================================================
    // DUT
    // =========================================================

    fpga_packet_router_top DUT (

        .CLK     (CLK),
        .RESET   (RESET),
        .UART_RX (UART_RX),
        .UART_TX (UART_TX)

    );


    // =========================================================
    // CLOCK
    // =========================================================

    initial begin

        CLK = 1'b0;

        forever #(CLK_PERIOD / 2)
            CLK = ~CLK;

    end


    // =========================================================
    // UART TRANSMITTER
    //
    // PC -> FPGA
    // =========================================================

    task uart_send_byte;

        input [7:0] DATA;

        integer i;

        begin

            // Start bit
            UART_RX = 1'b0;
            #(BIT_TIME);


            // Data bits
            for (i = 0; i < 8; i = i + 1) begin

                UART_RX = DATA[i];

                #(BIT_TIME);

            end


            // Stop bit
            UART_RX = 1'b1;
            #(BIT_TIME);


            // Idle gap
            #(BIT_TIME);

        end

    endtask


    // =========================================================
    // UART RECEIVER
    //
    // FPGA -> PC
    //
    // This receiver starts immediately and captures both
    // UART bytes from the TX line.
    // =========================================================

    initial begin : UART_MONITOR

        integer i;

        // ---------------------------------------------
        // Initial values
        // ---------------------------------------------

        RX_DESTINATION = 8'h00;
        RX_DATA_BYTE   = 8'h00;
        RECEIVER_DONE  = 1'b0;


        // ---------------------------------------------
        // Wait until reset is released
        // ---------------------------------------------

        wait (RESET == 1'b0);


        // =================================================
        // BYTE 0
        // =================================================

        @(negedge UART_TX);

        // Center of first data bit
        #(BIT_TIME + BIT_TIME/2);

        for (i = 0; i < 8; i = i + 1) begin

            RX_DESTINATION[i] = UART_TX;

            #(BIT_TIME);

        end

        // Stop bit
        #(BIT_TIME);


        $display(
            "Received destination byte = %02h",
            RX_DESTINATION
        );


        // =================================================
        // BYTE 1
        // =================================================

        @(negedge UART_TX);

        // Center of first data bit
        #(BIT_TIME + BIT_TIME/2);

        for (i = 0; i < 8; i = i + 1) begin

            RX_DATA_BYTE[i] = UART_TX;

            #(BIT_TIME);

        end

        // Stop bit
        #(BIT_TIME);


        $display(
            "Received data byte = %02h",
            RX_DATA_BYTE
        );


        RECEIVER_DONE = 1'b1;

    end


    // =========================================================
    // MAIN TEST
    // =========================================================

    initial begin

        // ---------------------------------------------
        // Initial conditions
        // ---------------------------------------------

        RESET   = 1'b1;
        UART_RX = 1'b1;


        // ---------------------------------------------
        // Hold reset
        // ---------------------------------------------

        #(10 * CLK_PERIOD);


        // ---------------------------------------------
        // Release reset
        // ---------------------------------------------

        RESET = 1'b0;


        // ---------------------------------------------
        // Wait for system
        // ---------------------------------------------

        #(10 * CLK_PERIOD);


        // =================================================
        // TEST HEADER
        // =================================================

        $display("");
        $display("==============================================");
        $display(" FPGA PACKET ROUTER TOP-LEVEL TEST");
        $display("==============================================");

        $display("");
        $display("Sending packet:");
        $display("Destination = 2");
        $display("Data        = F0");
        $display("Expected packet = 10'b10_11110000");
        $display("");


        // =================================================
        // SEND DESTINATION
        // =================================================

        uart_send_byte(8'h02);

        $display(
            "Destination byte 02 sent."
        );


        // =================================================
        // SEND DATA
        // =================================================

        uart_send_byte(8'hF0);

        $display(
            "Data byte F0 sent."
        );

        $display("");


        // =================================================
        // WAIT FOR UART RECEIVER
        //
        // Maximum expected time is much less than this.
        // =================================================

        wait (RECEIVER_DONE == 1'b1);


        // =================================================
        // CHECK DESTINATION
        // =================================================

        if (RX_DESTINATION == 8'h02) begin

            $display(
                "PASS: Output destination byte = %02h",
                RX_DESTINATION
            );

        end
        else begin

            $display(
                "FAIL: Expected destination byte = 02, got = %02h",
                RX_DESTINATION
            );

        end


        // =================================================
        // CHECK DATA
        // =================================================

        if (RX_DATA_BYTE == 8'hF0) begin

            $display(
                "PASS: Output data byte = %02h",
                RX_DATA_BYTE
            );

        end
        else begin

            $display(
                "FAIL: Expected data byte = F0, got = %02h",
                RX_DATA_BYTE
            );

        end


        // =================================================
        // FINAL RESULT
        // =================================================

        if ((RX_DESTINATION == 8'h02) &&
            (RX_DATA_BYTE == 8'hF0)) begin

            $display("");
            $display("==============================================");
            $display(" TEST PASSED");
            $display("==============================================");

        end
        else begin

            $display("");
            $display("==============================================");
            $display(" TEST FAILED");
            $display("==============================================");

        end


        #(10 * BIT_TIME);

        $finish;

    end

endmodule