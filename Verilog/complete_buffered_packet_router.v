module complete_buffered_packet_router (
    input  wire        CLK,
    input  wire        RESET,

    input  wire [9:0]  PACKET_IN,
    input  wire        VALID_IN,

    input  wire [3:0]  READY_OUT,

    output wire        READY_IN,
    output wire [3:0]  VALID_OUT,

    output wire [9:0] PACKET_OUT0,
    output wire [9:0] PACKET_OUT1,
    output wire [9:0] PACKET_OUT2,
    output wire [9:0] PACKET_OUT3
);

    //========================================================
    // Packet Input
    //========================================================

    wire [1:0] DESTINATION;
    wire [7:0] DATA;

    packet_input PI (
        .packet      (PACKET_IN),
        .destination (DESTINATION),
        .data        (DATA)
    );


    //========================================================
    // FIFO Status
    //========================================================

    wire FULL0;
    wire FULL1;
    wire FULL2;
    wire FULL3;

    wire EMPTY0;
    wire EMPTY1;
    wire EMPTY2;
    wire EMPTY3;

    wire [3:0] FULL;
    wire [3:0] EMPTY;

    assign FULL = {FULL3, FULL2, FULL1, FULL0};
    assign EMPTY = {EMPTY3, EMPTY2, EMPTY1, EMPTY0};


    //========================================================
    // Flow Control
    //========================================================

    wire [3:0] WRITE_EN;
    wire [3:0] READ_EN;

    flow_control FC (
        .VALID_IN   (VALID_IN),
        .DESTINATION(DESTINATION),
        .FULL       (FULL),

        .EMPTY      (EMPTY),
        .READY_OUT  (READY_OUT),

        .WRITE_EN   (WRITE_EN),
        .READY_IN   (READY_IN),

        .VALID_OUT  (VALID_OUT),
        .READ_EN    (READ_EN)
    );


    //========================================================
    // Convert 4-bit WRITE_EN to single WRITE_EN
    // required by four_output_fifos
    //========================================================

    wire FIFO_WRITE_EN;

    assign FIFO_WRITE_EN =
           WRITE_EN[0] |
           WRITE_EN[1] |
           WRITE_EN[2] |
           WRITE_EN[3];


    //========================================================
    // Four Output FIFOs
    //========================================================

    four_output_fifos FO_FIFO (
        .CLK        (CLK),
        .RESET      (RESET),

        .PACKET_IN  (PACKET_IN),
        .WRITE_EN   (FIFO_WRITE_EN),

        .READ_EN0   (READ_EN[0]),
        .READ_EN1   (READ_EN[1]),
        .READ_EN2   (READ_EN[2]),
        .READ_EN3   (READ_EN[3]),

        .READ_MODE0 (1'b1),
        .READ_MODE1 (1'b1),
        .READ_MODE2 (1'b1),
        .READ_MODE3 (1'b1),

        .PACKET_OUT0(PACKET_OUT0),
        .PACKET_OUT1(PACKET_OUT1),
        .PACKET_OUT2(PACKET_OUT2),
        .PACKET_OUT3(PACKET_OUT3),

        .FULL0      (FULL0),
        .FULL1      (FULL1),
        .FULL2      (FULL2),
        .FULL3      (FULL3),

        .EMPTY0     (EMPTY0),
        .EMPTY1     (EMPTY1),
        .EMPTY2     (EMPTY2),
        .EMPTY3     (EMPTY3)
    );

endmodule