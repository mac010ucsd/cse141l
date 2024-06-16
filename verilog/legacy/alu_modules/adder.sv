// combinational -- no clock
// sample -- change as desired
module adder(
    input cin,
    input[7:0] input_A, input_B,	 // 8-bit wide data path
    // input      sc_i,       // shift_carry in
    output logic[7:0] out,
    output logic cout
    
);

// logic add_cin;

always_comb begin 
  
  {cout, out} = input_A + input_B + cin; 

end
   
endmodule