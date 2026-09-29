module fpga_packet_router_top (

    input  wire       CLK,
    input  wire       RESET,

    // UART interface
    input  wire       UART_RX,
    output wire       UART_TX

);

    // =========================================================
    // UART RX
    // =========================================================

    wire [7:0] RX_DATA;
    wire       RX_VALID;


    uart_rx UART_RECEIVER (

        .CLK       (CLK),
        .RESET     (RESET),
        .RX        (UART_RX),

        .DATA_OUT  (RX_DATA),
        .DATA_VALID(RX_VALID)

    );


    // =========================================================
    // Packet Input Interface
    // UART bytes -> 10-bit packet
    // =========================================================

    wire [9:0] PACKET_IN;
    wire       VALID_IN;
    wire       READY_IN;


    packet_input_interface PACKET_INPUT (

        .CLK       (CLK),
        .RESET     (RESET),

        .RX_DATA   (RX_DATA),
        .RX_VALID  (RX_VALID),

        .PACKET_OUT(PACKET_IN),
        .VALID_OUT (VALID_IN),
        .READY_IN  (READY_IN)

    );


    // =========================================================
    // Router Output Signals
    // =========================================================

    wire [3:0] VALID_OUT;
    wire [3:0] READY_OUT;

    wire [9:0] PACKET_OUT0;
    wire [9:0] PACKET_OUT1;
    wire [9:0] PACKET_OUT2;
    wire [9:0] PACKET_OUT3;


    // =========================================================
    // Complete Buffered Packet Router
    // =========================================================

    complete_buffered_packet_router ROUTER (

        .CLK        (CLK),
        .RESET      (RESET),

        .PACKET_IN  (PACKET_IN),
        .VALID_IN   (VALID_IN),

        .READY_OUT  (READY_OUT),

        .READY_IN   (READY_IN),
        .VALID_OUT  (VALID_OUT),

        .PACKET_OUT0(PACKET_OUT0),
        .PACKET_OUT1(PACKET_OUT1),
        .PACKET_OUT2(PACKET_OUT2),
        .PACKET_OUT3(PACKET_OUT3)

    );


    // =========================================================
    // Output UART Arbiter
    // =========================================================

    wire [9:0] PACKET_DATA;
    wire       PACKET_VALID;
    wire       PACKET_READY;


    output_uart_arbiter OUTPUT_ARBITER (

        .CLK        (CLK),
        .RESET      (RESET),

        .PACKET_OUT0(PACKET_OUT0),
        .PACKET_OUT1(PACKET_OUT1),
        .PACKET_OUT2(PACKET_OUT2),
        .PACKET_OUT3(PACKET_OUT3),

        .VALID_OUT  (VALID_OUT),

        .PACKET_READY(PACKET_READY),

        .READY_OUT  (READY_OUT),

        .PACKET_DATA(PACKET_DATA),
        .PACKET_VALID(PACKET_VALID)

    );


    // =========================================================
    // Packet -> UART Bytes
    // =========================================================

    wire [7:0] UART_DATA;
    wire       UART_DATA_VALID;
    wire       UART_BUSY;


    packet_to_byte_serializer SERIALIZER (

        .CLK            (CLK),
        .RESET          (RESET),

        .PACKET_IN      (PACKET_DATA),
        .PACKET_VALID   (PACKET_VALID),

        .UART_BUSY      (UART_BUSY),

        .UART_DATA      (UART_DATA),
        .UART_DATA_VALID(UART_DATA_VALID),

        .PACKET_READY   (PACKET_READY)

    );


    // =========================================================
    // UART TX
    // =========================================================

    uart_tx UART_TRANSMITTER (

        .CLK       (CLK),
        .RESET     (RESET),

        .DATA_IN   (UART_DATA),
        .DATA_VALID(UART_DATA_VALID),

        .TX        (UART_TX),
        .BUSY      (UART_BUSY)

    );

endmodule