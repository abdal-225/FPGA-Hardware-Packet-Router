//============================================================
// Block 8: Flow Control
// FPGA-Based Buffered Multi-Output Packet Router
//============================================================

module flow_control (
    input  wire       VALID_IN,
    input  wire [1:0] DESTINATION,
    input  wire [3:0] FULL,

    input  wire [3:0] EMPTY,
    input  wire [3:0] READY_OUT,

    output wire [3:0] WRITE_EN,
    output wire       READY_IN,

    output wire [3:0] VALID_OUT,
    output wire [3:0] READ_EN
);

    //========================================================
    // Destination decoding
    //========================================================

    wire DEST0;
    wire DEST1;
    wire DEST2;
    wire DEST3;

    assign DEST0 = ~DESTINATION[1] & ~DESTINATION[0];
    assign DEST1 = ~DESTINATION[1] &  DESTINATION[0];
    assign DEST2 =  DESTINATION[1] & ~DESTINATION[0];
    assign DEST3 =  DESTINATION[1] &  DESTINATION[0];


    //========================================================
    // Write-side Flow Control
    //========================================================

    assign WRITE_EN[0] = VALID_IN & DEST0 & ~FULL[0];
    assign WRITE_EN[1] = VALID_IN & DEST1 & ~FULL[1];
    assign WRITE_EN[2] = VALID_IN & DEST2 & ~FULL[2];
    assign WRITE_EN[3] = VALID_IN & DEST3 & ~FULL[3];


    // READY_IN indicates that the selected FIFO
    // is not full.

    assign READY_IN =
           (DEST0 & ~FULL[0]) |
           (DEST1 & ~FULL[1]) |
           (DEST2 & ~FULL[2]) |
           (DEST3 & ~FULL[3]);


    //========================================================
    // Read-side Flow Control
    //========================================================

    // VALID_OUT = 1 when the corresponding FIFO
    // contains at least one packet.

    assign VALID_OUT[0] = ~EMPTY[0];
    assign VALID_OUT[1] = ~EMPTY[1];
    assign VALID_OUT[2] = ~EMPTY[2];
    assign VALID_OUT[3] = ~EMPTY[3];


    // READ_EN occurs only when:
    // 1. FIFO contains data
    // 2. Downstream output is ready

    assign READ_EN[0] = VALID_OUT[0] & READY_OUT[0];
    assign READ_EN[1] = VALID_OUT[1] & READY_OUT[1];
    assign READ_EN[2] = VALID_OUT[2] & READY_OUT[2];
    assign READ_EN[3] = VALID_OUT[3] & READY_OUT[3];

endmodule