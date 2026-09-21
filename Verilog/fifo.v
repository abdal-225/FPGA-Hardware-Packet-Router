module fifo (
    input        clk, reset,
    input        write_en, read_en,
    input        read_mode,
    input  [9:0] data_in,

    output [9:0] data_out,
    output [3:0] count,
    output       full, empty
);

    wire [2:0] write_addr;
    wire [2:0] read_addr;
    wire [2:0] ram_addr;

    wire do_write;
    wire do_read;

    /*
        Write allowed when FIFO is not full
    */
    assign do_write = write_en & ~full;

    /*
        Read allowed when FIFO is not empty
    */
    assign do_read = read_en & ~empty;

    /*
        RAM address selection

        read_mode = 0 -> Write Address
        read_mode = 1 -> Read Address
    */
    assign ram_addr = read_mode ? read_addr : write_addr;


    /*
        Write Pointer
    */
    write_pointer WP (
        clk,
        reset,
        do_write,
        write_addr
    );


    /*
        Read Pointer
    */
    read_pointer RP (
        clk,
        reset,
        do_read,
        read_addr
    );


    /*
        FIFO Counter
    */
    fifo_counter FC (
        clk,
        reset,
        write_en,
        read_en,
        count,
        full,
        empty
    );


    /*
        FIFO RAM
    */
    fifo_ram RAM (
        clk,
        reset,
        do_write,
        do_read,
        ram_addr,
        data_in,
        data_out
    );

endmodule