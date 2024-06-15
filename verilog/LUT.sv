module LUT (
    input       [3:0]		LutPointer,
    output logic[9:0]       absaddress
);

always_comb case(LutPointer)
	// Program 1
    0: absaddress = 13;
    1: absaddress = 22;
    2: absaddress = 43;
    3: absaddress = 62;
    4: absaddress = 74;
    5: absaddress = 93;
    6: absaddress = 99;
    7: absaddress = 105;
	8: absaddress = 107;
    9: absaddress = 109;
	// Program 2
    10: absaddress = 1;
    11: absaddress = 1;
    12: absaddress = 1;
    13: absaddress = 1;
    14: absaddress = 1;
    
    // Program 3
    15: absaddress = 1;

	default: absaddress = 'b0;
endcase

endmodule
