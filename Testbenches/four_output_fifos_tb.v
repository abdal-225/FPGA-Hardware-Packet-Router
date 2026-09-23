`timescale 1ns / 1ps

module four_output_fifos_tb;

    // Inputs
    reg CLK;
    reg RESET;

    reg [9:0] PACKET_IN;
    reg WRITE_EN;

    reg READ_EN0;
    reg READ_EN1;
    reg READ_EN2;
    reg READ_EN3;

    reg READ_MODE0;
    reg READ_MODE1;
    reg READ_MODE2;
    reg READ_MODE3;

    // Outputs
    wire [9:0] PACKET_OUT0;
    wire [9:0] PACKET_OUT1;
    wire [9:0] PACKET_OUT2;
    wire [9:0] PACKET_OUT3;

    wire FULL0;
    wire FULL1;
    wire FULL2;
    wire FULL3;

    wire EMPTY0;
    wire EMPTY1;
    wire EMPTY2;
    wire EMPTY3;


    // Device Under Test
    four_output_fifos DUT (
        .CLK(CLK),
        .RESET(RESET),

        .PACKET_IN(PACKET_IN),
        .WRITE_EN(WRITE_EN),

        .READ_EN0(READ_EN0),
        .READ_EN1(READ_EN1),
        .READ_EN2(READ_EN2),
        .READ_EN3(READ_EN3),

        .READ_MODE0(READ_MODE0),
        .READ_MODE1(READ_MODE1),
        .READ_MODE2(READ_MODE2),
        .READ_MODE3(READ_MODE3),

        .PACKET_OUT0(PACKET_OUT0),
        .PACKET_OUT1(PACKET_OUT1),
        .PACKET_OUT2(PACKET_OUT2),
        .PACKET_OUT3(PACKET_OUT3),

        .FULL0(FULL0),
        .FULL1(FULL1),
        .FULL2(FULL2),
        .FULL3(FULL3),

        .EMPTY0(EMPTY0),
        .EMPTY1(EMPTY1),
        .EMPTY2(EMPTY2),
        .EMPTY3(EMPTY3)
    );


    // Clock
    always #5 CLK = ~CLK;


    // Test sequence
    initial begin

        // Initial values
        CLK = 0;
        RESET = 1;

        PACKET_IN = 10'b0000000000;
        WRITE_EN = 0;

        READ_EN0 = 0;
        READ_EN1 = 0;
        READ_EN2 = 0;
        READ_EN3 = 0;

        READ_MODE0 = 0;
        READ_MODE1 = 0;
        READ_MODE2 = 0;
        READ_MODE3 = 0;


        // Reset
        #10;
        RESET = 0;

        #10;


        // ==========================================
        // WRITE PACKET TO FIFO 0
        // Destination = 00
        // ==========================================

        PACKET_IN = 10'b00_10101010;
        WRITE_EN = 1;

        #10;

        WRITE_EN = 0;

        #10;


        // ==========================================
        // WRITE PACKET TO FIFO 1
        // Destination = 01
        // ==========================================

        PACKET_IN = 10'b01_11001100;
        WRITE_EN = 1;

        #10;

        WRITE_EN = 0;

        #10;


        // ==========================================
        // WRITE PACKET TO FIFO 2
        // Destination = 10
        // ==========================================

        PACKET_IN = 10'b10_00110011;
        WRITE_EN = 1;

        #10;

        WRITE_EN = 0;

        #10;


        // ==========================================
        // WRITE PACKET TO FIFO 3
        // Destination = 11
        // ==========================================

        PACKET_IN = 10'b11_01010101;
        WRITE_EN = 1;

        #10;

        WRITE_EN = 0;

        #10;


        // ==========================================
        // READ FIFO 0
        // ==========================================

        READ_MODE0 = 1;
        READ_EN0 = 1;

        #10;

        READ_EN0 = 0;

        #10;


        // ==========================================
        // READ FIFO 1
        // ==========================================

        READ_MODE1 = 1;
        READ_EN1 = 1;

        #10;

        READ_EN1 = 0;

        #10;


        // ==========================================
        // READ FIFO 2
        // ==========================================

        READ_MODE2 = 1;
        READ_EN2 = 1;

        #10;

        READ_EN2 = 0;

        #10;


        // ==========================================
        // READ FIFO 3
        // ==========================================

        READ_MODE3 = 1;
        READ_EN3 = 1;

        #10;

        READ_EN3 = 0;

        #10;


        // End simulation
        #20;

        $finish;

    end


    // Monitor
    initial begin

        $monitor(
            "Time=%0t | RESET=%b | WRITE_EN=%b | PACKET_IN=%b | OUT0=%b EMPTY0=%b | OUT1=%b EMPTY1=%b | OUT2=%b EMPTY2=%b | OUT3=%b EMPTY3=%b",
            $time,
            RESET,
            WRITE_EN,
            PACKET_IN,
            PACKET_OUT0,
            EMPTY0,
            PACKET_OUT1,
            EMPTY1,
            PACKET_OUT2,
            EMPTY2,
            PACKET_OUT3,
            EMPTY3
        );

    end

endmodule