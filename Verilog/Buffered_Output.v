module Buffered_Output (
    input        CLK, RESET,
    input  [9:0] PACKET_IN,
    input        WRITE_EN, READ_EN,
    input        READ_MODE,

    output [9:0] PACKET_OUT,
    output       FULL, EMPTY,
    output [3:0] COUNT
);

    fifo FIFO_INST (
        .clk       (CLK),
        .reset     (RESET),
        .write_en  (WRITE_EN),
        .read_en   (READ_EN),
        .read_mode (READ_MODE),
        .data_in   (PACKET_IN),

        .data_out  (PACKET_OUT),
        .count     (COUNT),
        .full      (FULL),
        .empty     (EMPTY)
    );

endmodule