`timescale 1ns / 1ps

module uart_rx_tb;

    reg CLK;
    reg RESET;
    reg RX;

    wire [7:0] DATA_OUT;
    wire DATA_VALID;

    uart_rx DUT (
        .CLK(CLK),
        .RESET(RESET),
        .RX(RX),
        .DATA_OUT(DATA_OUT),
        .DATA_VALID(DATA_VALID)
    );

    // 100 MHz clock
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // Test
    initial begin

        RESET = 1; RX = 1; #100;
        RESET = 0;

        // Send 8'hA5
        // Start bit
        RX = 0;#8680;
        // Bit 0
        RX = 1;#8680;
        // Bit 1
        RX = 0;#8680;
        // Bit 2
        RX = 1;#8680;
        // Bit 3
        RX = 0;#8680;
        // Bit 4
        RX = 0;#8680;
        // Bit 5
        RX = 1;#8680;
        // Bit 6
        RX = 0;#8680;
        // Bit 7
        RX = 1;#8680;

        // Stop bit
        RX = 1;#8680;

        // Give receiver time to finish
        #100;

        $display("--------------------------------");
        $display("DATA_OUT   = %h", DATA_OUT);
        $display("DATA_VALID = %b", DATA_VALID);
        $display("--------------------------------");

        $finish;

    end

endmodule