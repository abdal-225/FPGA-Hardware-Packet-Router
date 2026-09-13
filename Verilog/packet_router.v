module packet_router (
    input  [9:0] PACKET,

    output [7:0] ROUTER_OUT0,
    output [7:0] ROUTER_OUT1,
    output [7:0] ROUTER_OUT2,
    output [7:0] ROUTER_OUT3
);

    wire [1:0] DESTINATION;
    wire [7:0] DATA;

    wire E0;
    wire E1;
    wire E2;
    wire E3;

    // Block 1: Packet Input
    packet_input U1 (
        .PACKET(PACKET),
        .DESTINATION(DESTINATION),
        .DATA(DATA)
    );

    // Block 2: Destination Decoder
    destination_decoder U2 (
        .D1(DESTINATION[1]),
        .D0(DESTINATION[0]),
        .OUT0(E0),
        .OUT1(E1),
        .OUT2(E2),
        .OUT3(E3)
    );

    // Block 3: Data Router
    data_router U3 (
        .DATA(DATA),
        .E0(E0),
        .E1(E1),
        .E2(E2),
        .E3(E3),
        .DATA_OUT0(ROUTER_OUT0),
        .DATA_OUT1(ROUTER_OUT1),
        .DATA_OUT2(ROUTER_OUT2),
        .DATA_OUT3(ROUTER_OUT3)
    );

endmodule