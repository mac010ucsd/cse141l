module LUT (
    input       [3:0]		LutPointer,
    output logic[9:0]       absaddress
);

always_comb case(LutPointer)
	// Program 1
    0: absaddress = 14;
    1: absaddress = 23;
    2: absaddress = 44;
    3: absaddress = 63;
    4: absaddress = 75;
    5: absaddress = 94;
    6: absaddress = 100;
    7: absaddress = 106;
	8: absaddress = 108;
    9: absaddress = 110;
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
