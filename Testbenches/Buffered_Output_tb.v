`timescale 1ns / 1ps

module Buffered_Output_tb;

    // Inputs
    reg        CLK;
    reg        RESET;
    reg [9:0]  PACKET_IN;
    reg        WRITE_EN;
    reg        READ_EN;
    reg        READ_MODE;

    // Outputs
    wire [9:0] PACKET_OUT;
    wire       FULL;
    wire       EMPTY;
    wire [3:0] COUNT;

    // DUT
    Buffered_Output DUT (
        .CLK        (CLK),
        .RESET      (RESET),
        .PACKET_IN  (PACKET_IN),
        .WRITE_EN   (WRITE_EN),
        .READ_EN    (READ_EN),
        .READ_MODE  (READ_MODE),
        .PACKET_OUT (PACKET_OUT),
        .FULL       (FULL),
        .EMPTY      (EMPTY),
        .COUNT      (COUNT)
    );

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // Test sequence
    initial begin

        // Initial values
        RESET     = 1;
        PACKET_IN = 10'b0000000000;
        WRITE_EN  = 0;
        READ_EN   = 0;
        READ_MODE = 0;

        // ============================================
        // RESET
        // ============================================
        #10;
        RESET = 0;

        // ============================================
        // WRITE MODE
        // READ_MODE = 0
        // RAM uses WRITE_ADDR
        // ============================================
        READ_MODE = 0;

        // --------------------------------------------
        // Write Packet A
        // Destination = 00
        // Data        = 10101010
        // Packet      = 0010101010
        // --------------------------------------------
        #10;
        PACKET_IN = 10'b00_10101010;
        WRITE_EN  = 1;

        #10;
        WRITE_EN = 0;

        // --------------------------------------------
        // Write Packet B
        // Destination = 01
        // Data        = 11001100
        // Packet      = 0111001100
        // --------------------------------------------
        #10;
        PACKET_IN = 10'b01_11001100;
        WRITE_EN  = 1;

        #10;
        WRITE_EN = 0;

        // ============================================
        // READ MODE
        // READ_MODE = 1
        // RAM uses READ_ADDR
        // ============================================
        #10;
        READ_MODE = 1;

        // --------------------------------------------
        // Read Packet A
        // --------------------------------------------
        #10;
        READ_EN = 1;

        #10;
        READ_EN = 0;

        // --------------------------------------------
        // Read Packet B
        // --------------------------------------------
        #10;
        READ_EN = 1;

        #10;
        READ_EN = 0;

        // ============================================
        // Finish
        // ============================================
        #20;

        $finish;

    end

    // Monitor
    initial begin

        $monitor(
            "Time=%0t | RESET=%b | READ_MODE=%b | WRITE_EN=%b | READ_EN=%b | PACKET_IN=%b | PACKET_OUT=%b | COUNT=%d | FULL=%b | EMPTY=%b",
            $time,
            RESET,
            READ_MODE,
            WRITE_EN,
            READ_EN,
            PACKET_IN,
            PACKET_OUT,
            COUNT,
            FULL,
            EMPTY
        );

    end

endmodule