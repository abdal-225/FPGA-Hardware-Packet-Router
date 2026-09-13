module packet_input (
    input  [9:0] packet,
    output [1:0] destination,
    output [7:0] data
);

    assign destination = packet[9:8];
    assign data        = packet[7:0];

endmodule