`timescale 1ns / 1ps

module data_router_tb;

    reg  [7:0] DATA;
    reg        E0;
    reg        E1;
    reg        E2;
    reg        E3;

    wire [7:0] DATA_OUT0;
    wire [7:0] DATA_OUT1;
    wire [7:0] DATA_OUT2;
    wire [7:0] DATA_OUT3;

    data_router uut (
        .DATA(DATA),
        .E0(E0),
        .E1(E1),
        .E2(E2),
        .E3(E3),
        .DATA_OUT0(DATA_OUT0),
        .DATA_OUT1(DATA_OUT1),
        .DATA_OUT2(DATA_OUT2),
        .DATA_OUT3(DATA_OUT3)
    );

    initial begin

        DATA = 8'b10101010;E0 = 1;E1 = 0;E2 = 0;E3 = 0;#10;
        DATA = 8'b11001100;E0 = 0;E1 = 1;E2 = 0;E3 = 0;#10;
        DATA = 8'b11110000;E0 = 0;E1 = 0;E2 = 1;E3 = 0;#10;
        DATA = 8'b00001111;E0 = 0;E1 = 0;E2 = 0;E3 = 1;#10;
        DATA = 8'b10110101;E0 = 0;E1 = 0;E2 = 0;E3 = 0;#10;

        $finish;

    end

endmodule