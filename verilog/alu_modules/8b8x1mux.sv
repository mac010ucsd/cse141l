// combinational -- no clock
// sample -- change as desired
module widemux(
    input[7:0] in0, in1, in2, in3, in4, in5, in6, in7,	 // 8-bit wide data path
    // input      sc_i,       // shift_carry in
    input[2:0] sel,
    output logic[7:0] out
);

// logic add_cin;

always_comb begin 
  case(sel)
    3'b000:
      out = in0;
    3'b001:
      out = in1;
    3'b010:
      out = in2;
    3'b011:
      out = in3;
    3'b100:
      out = in4;
    3'b101:
      out = in5;
    3'b110:
      out = in6;
    3'b111:
      out = in7;
  endcase
end
endmodule