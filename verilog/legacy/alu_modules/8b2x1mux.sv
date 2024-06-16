// combinational -- no clock
// sample -- change as desired
module mux(
    input[7:0] in0, in1, // 8-bit wide data path
    // input      sc_i,       // shift_carry in
    input sel,
    output logic[7:0] out
);

// logic add_cin;

always_comb begin 
  case(sel)
    1'b0:
      out = in0;
    1'b1:
      out = in1;
  endcase
end
endmodule