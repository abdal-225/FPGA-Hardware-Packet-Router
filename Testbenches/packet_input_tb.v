`timescale 1ns/1ps

module packet_input_tb;

    reg  [9:0] packet;
    wire [1:0] destination;
    wire [7:0] data;

    packet_input uut (
        .packet(packet),
        .destination(destination),
        .data(data)
    );

    initial begin

        packet = 10'b00_11110000;
        #10;

        packet = 10'b01_10101010;
        #10;

        packet = 10'b10_00001111;
        #10;

        packet = 10'b11_01010101;
        #10;

        $finish;
    end

endmodule