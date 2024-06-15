module LUT (
    input       [3:0]		LutPointer,
    output logic[9:0]       absaddress
);

always_comb case(LutPointer)
	// Program 1
    0: absaddress = 1;
    1: absaddress = 1;
    2: absaddress = 1;
    3: absaddress = 1;
    4: absaddress = 1;
    5: absaddress = 1;
    6: absaddress = 1;
	
	// Program 2
    7: absaddress = 1;
    8: absaddress = 1;
    9: absaddress = 1;
    10: absaddress = 1;
    11: absaddress = 1;
    12: absaddress = 1;
    13: absaddress = 1;
    14: absaddress = 1;

    // Program 3
    15: absaddress = 1;
    16: absaddress = 1;
    17: absaddress = 1;
    18: absaddress = 1;
    19: absaddress = 1;
    20: absaddress = 1;
    21: absaddress = 1;
    22: absaddress = 1;
	

	default: absaddress = 'b0;
endcase

endmodule
