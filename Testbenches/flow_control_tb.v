`timescale 1ns/1ps

module flow_control_tb;

    //========================================================
    // Inputs
    //========================================================

    reg        VALID_IN;
    reg [1:0]  DESTINATION;
    reg [3:0]  FULL;

    reg [3:0]  EMPTY;
    reg [3:0]  READY_OUT;


    //========================================================
    // Outputs
    //========================================================

    wire [3:0] WRITE_EN;
    wire       READY_IN;

    wire [3:0] VALID_OUT;
    wire [3:0] READ_EN;


    //========================================================
    // DUT
    //========================================================

    flow_control DUT (
        .VALID_IN(VALID_IN),
        .DESTINATION(DESTINATION),
        .FULL(FULL),

        .EMPTY(EMPTY),
        .READY_OUT(READY_OUT),

        .WRITE_EN(WRITE_EN),
        .READY_IN(READY_IN),

        .VALID_OUT(VALID_OUT),
        .READ_EN(READ_EN)
    );


    //========================================================
    // Test Cases
    //========================================================

    initial begin

        // Initial values
        VALID_IN   = 1'b0;
        DESTINATION = 2'b00;
        FULL       = 4'b0000;

        EMPTY      = 4'b1111;
        READY_OUT  = 4'b0000;

        #10;


        //====================================================
        // WRITE-SIDE TESTS
        //====================================================

        // Test 1: VALID = 0
        VALID_IN    = 1'b0;
        DESTINATION = 2'b00;
        FULL        = 4'b0000;

        #10;


        // Test 2: Destination 0 available
        VALID_IN    = 1'b1;
        DESTINATION = 2'b00;
        FULL        = 4'b0000;

        #10;


        // Test 3: Destination 1 available
        VALID_IN    = 1'b1;
        DESTINATION = 2'b01;
        FULL        = 4'b0000;

        #10;


        // Test 4: Destination 2 available
        VALID_IN    = 1'b1;
        DESTINATION = 2'b10;
        FULL        = 4'b0000;

        #10;


        // Test 5: Destination 3 available
        VALID_IN    = 1'b1;
        DESTINATION = 2'b11;
        FULL        = 4'b0000;

        #10;


        // Test 6: FIFO 0 is FULL
        VALID_IN    = 1'b1;
        DESTINATION = 2'b00;
        FULL        = 4'b0001;

        #10;


        // Test 7: FIFO 1 is FULL
        VALID_IN    = 1'b1;
        DESTINATION = 2'b01;
        FULL        = 4'b0010;

        #10;


        // Test 8: FIFO 2 is FULL
        VALID_IN    = 1'b1;
        DESTINATION = 2'b10;
        FULL        = 4'b0100;

        #10;


        // Test 9: FIFO 3 is FULL
        VALID_IN    = 1'b1;
        DESTINATION = 2'b11;
        FULL        = 4'b1000;

        #10;


        // Test 10: Other FIFO is FULL
        // Destination 0 is selected, FIFO 3 is full
        VALID_IN    = 1'b1;
        DESTINATION = 2'b00;
        FULL        = 4'b1000;

        #10;


        // Test 11: FIFO 0 and FIFO 1 are FULL
        // Destination 3 is selected
        VALID_IN    = 1'b1;
        DESTINATION = 2'b11;
        FULL        = 4'b0011;

        #10;


        // Test 12: All FIFOs FULL
        VALID_IN    = 1'b1;
        DESTINATION = 2'b00;
        FULL        = 4'b1111;

        #10;


        //====================================================
        // READ-SIDE TESTS
        //====================================================

        // Test 13: All FIFOs contain data, no output ready
        EMPTY     = 4'b0000;
        READY_OUT = 4'b0000;

        #10;


        // Test 14: FIFO 0 contains data and is ready
        EMPTY     = 4'b0000;
        READY_OUT = 4'b0001;

        #10;


        // Test 15: FIFO 1 contains data and is ready
        EMPTY     = 4'b0000;
        READY_OUT = 4'b0010;

        #10;


        // Test 16: FIFO 2 contains data and is ready
        EMPTY     = 4'b0000;
        READY_OUT = 4'b0100;

        #10;


        // Test 17: FIFO 3 contains data and is ready
        EMPTY     = 4'b0000;
        READY_OUT = 4'b1000;

        #10;


        // Test 18: FIFO 0 is empty
        EMPTY     = 4'b0001;
        READY_OUT = 4'b0001;

        #10;


        // Test 19: FIFO 2 is empty but ready
        EMPTY     = 4'b0100;
        READY_OUT = 4'b0100;

        #10;


        // Test 20: FIFO 3 contains data but output is NOT ready
        EMPTY     = 4'b0000;
        READY_OUT = 4'b0000;

        #10;


        // Test 21: All FIFOs empty
        EMPTY     = 4'b1111;
        READY_OUT = 4'b1111;

        #10;


        //====================================================
        // END
        //====================================================

        $finish;

    end

endmodule