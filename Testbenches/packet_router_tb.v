`timescale 1ns / 1ps

module packet_router_tb;

    reg [9:0] PACKET;

    wire [7:0] ROUTER_OUT0;
    wire [7:0] ROUTER_OUT1;
    wire [7:0] ROUTER_OUT2;
    wire [7:0] ROUTER_OUT3;

    packet_router uut (
        .PACKET(PACKET),
        .ROUTER_OUT0(ROUTER_OUT0),
        .ROUTER_OUT1(ROUTER_OUT1),
        .ROUTER_OUT2(ROUTER_OUT2),
        .ROUTER_OUT3(ROUTER_OUT3)
    );

    initial begin

        PACKET = 10'b0010101010;#10;
        PACKET = 10'b0111001100;#10;
        PACKET = 10'b1011110000;#10;
        PACKET = 10'b1100001111;#10;

        $finish;

    end

endmodule