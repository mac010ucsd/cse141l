module LUT (
    input       [3:0]		LutPointer,
    output logic[9:0]       absaddress
);

always_comb case(LutPointer)
	// Program 1
    0: absaddress = 14;
    1: absaddress = 23;
    2: absaddress = 100;
    3: absaddress = 106;
    4: absaddress = 108;
    5: absaddress = 110;
	
	// Program 2
    6: absaddress = 1;
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

	

	default: absaddress = 'b0;
endcase

endmodule
