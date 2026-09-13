module destination_decoder (
    input  D1,
    input  D0,
    output OUT0,
    output OUT1,
    output OUT2,
    output OUT3
);

assign OUT0 = (~D1) & (~D0);
assign OUT1 = (~D1) & D0;
assign OUT2 = D1 & (~D0);
assign OUT3 = D1 & D0;

endmodule