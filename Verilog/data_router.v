module data_router (
    input  [7:0] DATA,
    input        E0,
    input        E1,
    input        E2,
    input        E3,

    output [7:0] DATA_OUT0,
    output [7:0] DATA_OUT1,
    output [7:0] DATA_OUT2,
    output [7:0] DATA_OUT3
);

assign DATA_OUT0 = DATA & {8{E0}};
assign DATA_OUT1 = DATA & {8{E1}};
assign DATA_OUT2 = DATA & {8{E2}};
assign DATA_OUT3 = DATA & {8{E3}};

endmodule