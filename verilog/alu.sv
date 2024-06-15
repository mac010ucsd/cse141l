// combinational -- no clock
// sample -- change as desired
module alu(
    input [3:0] alu_op,
    input cin,
    input[7:0] input_A, input_B,	 // 8-bit wide data path
    output logic[7:0] out,
    output logic[2:0] flags
    //     pari,     // reduction XOR (output)
    //    zero      // NOR (output)
);

logic cflag;
logic nflag;
logic zflag;
// logic shift_dir;
// logic shift_mode;

logic cout;

always_comb begin
  cflag = 'b0;
  out = 'b0;

  case(alu_op)
    'b0001: // add
      {cflag, out} = input_A + input_B; 
    'b0010: // sub
      {cflag, out} = input_A - input_B; // this is signed
    'b0011: // lsl
      out = input_A << input_B;
    'b0100: // lsr
      out = input_A >> input_B;
    'b0101: // rol
      out = input_A << input_B | input_A >> (7-input_B);
    'b0110: // ror
      out = input_A >> input_B | input_A << (input_B);
    'b0111: // and
      out = input_A & input_B;
    'b1000: // or
      out = input_A | input_B;
    'b1001: // xor
      out = input_A ^ input_B;
    'b1010: // not
      out = ~input_A;
    'b1011: // clear
      out = 'b0;
    'b1100: // overflow of left shift bits
      out = input_A >> (8 - input_B);
    default: begin
      cflag = 'b0;
      out = 'b0;
    end
  endcase
end

assign   nflag = out[7];
assign   zflag = !(|out);
assign   flags = {cflag, nflag, zflag};

endmodule