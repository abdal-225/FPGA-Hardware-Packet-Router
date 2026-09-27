`timescale 1ns / 1ps

module packet_to_byte_serializer_tb;

    reg CLK;
    reg RESET;

    reg [9:0] PACKET_IN;
    reg PACKET_VALID;

    reg UART_BUSY;

    wire [7:0] UART_DATA;
    wire UART_DATA_VALID;

    wire PACKET_READY;


    // ==========================================
    // DUT
    // ==========================================

    packet_to_byte_serializer DUT (

        .CLK(CLK),
        .RESET(RESET),

        .PACKET_IN(PACKET_IN),
        .PACKET_VALID(PACKET_VALID),

        .UART_BUSY(UART_BUSY),

        .UART_DATA(UART_DATA),
        .UART_DATA_VALID(UART_DATA_VALID),

        .PACKET_READY(PACKET_READY)

    );


    // ==========================================
    // Clock
    // ==========================================

    initial begin

        CLK = 1'b0;

        forever #5 CLK = ~CLK;

    end


    // ==========================================
    // Test sequence
    // ==========================================

    initial begin

        RESET = 1'b1;

        PACKET_IN = 10'b0;

        PACKET_VALID = 1'b0;

        UART_BUSY = 1'b0;


        // Reset
        #100;

        RESET = 1'b0;

        #50;


        // ======================================
        // TEST 1
        // Destination = 0
        // Data = AA
        // Packet = 0_AA
        // ======================================

        PACKET_IN = 10'b00_10101010;

        PACKET_VALID = 1'b1;

        #10;

        PACKET_VALID = 1'b0;


        // UART starts transmission
        UART_BUSY = 1'b1;

        #100;


        // Destination transmission finished
        UART_BUSY = 1'b0;

        #50;


        // UART starts data transmission
        UART_BUSY = 1'b1;

        #100;


        // Data transmission finished
        UART_BUSY = 1'b0;

        #50;


        // ======================================
        // TEST 2
        // Destination = 1
        // Data = 55
        // ======================================

        PACKET_IN = 10'b01_01010101;

        PACKET_VALID = 1'b1;

        #10;

        PACKET_VALID = 1'b0;


        UART_BUSY = 1'b1;

        #100;

        UART_BUSY = 1'b0;

        #50;

        UART_BUSY = 1'b1;

        #100;

        UART_BUSY = 1'b0;

        #50;


        // ======================================
        // TEST 3
        // Destination = 2
        // Data = F0
        // ======================================

        PACKET_IN = 10'b10_11110000;

        PACKET_VALID = 1'b1;

        #10;

        PACKET_VALID = 1'b0;


        UART_BUSY = 1'b1;

        #100;

        UART_BUSY = 1'b0;

        #50;

        UART_BUSY = 1'b1;

        #100;

        UART_BUSY = 1'b0;

        #50;


        // ======================================
        // TEST 4
        // Destination = 3
        // Data = 3C
        // ======================================

        PACKET_IN = 10'b11_00111100;

        PACKET_VALID = 1'b1;

        #10;

        PACKET_VALID = 1'b0;


        UART_BUSY = 1'b1;

        #100;

        UART_BUSY = 1'b0;

        #50;

        UART_BUSY = 1'b1;

        #100;

        UART_BUSY = 1'b0;

        #100;


        // ======================================
        // END
        // ======================================

        $display("==========================================");
        $display("PACKET-TO-BYTE SERIALIZER TEST COMPLETE");
        $display("==========================================");

        $finish;

    end


    // ==========================================
    // Monitor
    // ==========================================

    initial begin

        $monitor(
            "Time=%0t | PACKET_IN=%b | PACKET_VALID=%b | PACKET_READY=%b | UART_BUSY=%b | UART_DATA=%h | UART_DATA_VALID=%b",
            $time,
            PACKET_IN,
            PACKET_VALID,
            PACKET_READY,
            UART_BUSY,
            UART_DATA,
            UART_DATA_VALID
        );

    end

endmodule