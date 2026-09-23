module four_output_fifos (
    input        CLK, RESET,

    input  [9:0] PACKET_IN,
    input        WRITE_EN,

    input        READ_EN0, READ_EN1, READ_EN2, READ_EN3,

    input        READ_MODE0, READ_MODE1, READ_MODE2, READ_MODE3,

    output [9:0] PACKET_OUT0, PACKET_OUT1, PACKET_OUT2, PACKET_OUT3,

    output       FULL0, FULL1, FULL2, FULL3,

    output       EMPTY0, EMPTY1, EMPTY2, EMPTY3
);

    // =================================================
    // Packet Input
    // =================================================

    wire [1:0] destination;
    wire [7:0] data;

    packet_input PI (
        .packet      (PACKET_IN),
        .destination (destination),
        .data        (data)
    );


    // =================================================
    // Destination Decoder
    // =================================================

    wire E0;
    wire E1;
    wire E2;
    wire E3;

    destination_decoder DD (
        .D1   (destination[1]),
        .D0   (destination[0]),
        .OUT0 (E0),
        .OUT1 (E1),
        .OUT2 (E2),
        .OUT3 (E3)
    );


    // =================================================
    // FIFO Write Enables
    // =================================================

    wire WRITE_EN0;
    wire WRITE_EN1;
    wire WRITE_EN2;
    wire WRITE_EN3;

    assign WRITE_EN0 = WRITE_EN & E0;
    assign WRITE_EN1 = WRITE_EN & E1;
    assign WRITE_EN2 = WRITE_EN & E2;
    assign WRITE_EN3 = WRITE_EN & E3;


    // =================================================
    // Buffered Output 0
    // =================================================

    Buffered_Output FIFO0 (
        .CLK        (CLK),
        .RESET      (RESET),
        .PACKET_IN  (PACKET_IN),
        .WRITE_EN   (WRITE_EN0),
        .READ_EN    (READ_EN0),
        .READ_MODE  (READ_MODE0),

        .PACKET_OUT (PACKET_OUT0),
        .FULL       (FULL0),
        .EMPTY      (EMPTY0),
        .COUNT      ()
    );


    // =================================================
    // Buffered Output 1
    // =================================================

    Buffered_Output FIFO1 (
        .CLK        (CLK),
        .RESET      (RESET),
        .PACKET_IN  (PACKET_IN),
        .WRITE_EN   (WRITE_EN1),
        .READ_EN    (READ_EN1),
        .READ_MODE  (READ_MODE1),

        .PACKET_OUT (PACKET_OUT1),
        .FULL       (FULL1),
        .EMPTY      (EMPTY1),
        .COUNT      ()
    );


    // =================================================
    // Buffered Output 2
    // =================================================

    Buffered_Output FIFO2 (
        .CLK        (CLK),
        .RESET      (RESET),
        .PACKET_IN  (PACKET_IN),
        .WRITE_EN   (WRITE_EN2),
        .READ_EN    (READ_EN2),
        .READ_MODE  (READ_MODE2),

        .PACKET_OUT (PACKET_OUT2),
        .FULL       (FULL2),
        .EMPTY      (EMPTY2),
        .COUNT      ()
    );


    // =================================================
    // Buffered Output 3
    // =================================================

    Buffered_Output FIFO3 (
        .CLK        (CLK),
        .RESET      (RESET),
        .PACKET_IN  (PACKET_IN),
        .WRITE_EN   (WRITE_EN3),
        .READ_EN    (READ_EN3),
        .READ_MODE  (READ_MODE3),

        .PACKET_OUT (PACKET_OUT3),
        .FULL       (FULL3),
        .EMPTY      (EMPTY3),
        .COUNT      ()
    );

endmodule