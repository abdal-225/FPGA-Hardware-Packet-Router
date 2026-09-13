`timescale 1ns / 1ps

module destination_decoder_tb;

    reg D1;
    reg D0;

    wire OUT0;
    wire OUT1;
    wire OUT2;
    wire OUT3;

    destination_decoder uut (
        .D1(D1),
        .D0(D0),
        .OUT0(OUT0),
        .OUT1(OUT1),
        .OUT2(OUT2),
        .OUT3(OUT3)
    );

    initial begin

        D1 = 0;D0 = 0;#10;
        D1 = 0;D0 = 1;#10;
        D1 = 1;D0 = 0;#10;
        D1 = 1;D0 = 1;#10;

        $finish;

    end

endmodule