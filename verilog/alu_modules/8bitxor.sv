// combinational -- no clock
// sample -- change as desired
module alu_xor(
    input[7:0] input_A, input_B,	 // 8-bit wide data path
    // input      sc_i,       // shift_carry in
    output logic[7:0] out
);

// logic add_cin;

always_comb begin 
  out = input_A ^ input_B;
end
endmodule