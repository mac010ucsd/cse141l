// combinational -- no clock
// sample -- change as desired
module alu(
    input sel_a_mux,
          sel_b_mux,
          sel_gd_b_mux,
          sel_bit_mux,
          sel_shift_mux,
          shift_dir,
          shift_mode,
    input[2:0] sel_out_mux,
    input[7:0] input_A, input_B,	 // 8-bit wide data path
    output logic[7:0] out,
    output logic[2:0] flags
    //     pari,     // reduction XOR (output)
    //    zero      // NOR (output)
);

logic [7:0]inv_input_A;
logic [7:0]inv_input_B;
logic [7:0]out_a_mux;
logic [7:0]out_b_mux;
logic [7:0]out_b_mux_pre;
// logic [7:0]out_b_mux;
logic out_bit_mux;
logic[7:0] add_out;
logic cflag;
logic nflag;
logic zflag;
// logic shift_dir;
// logic shift_mode;

logic [7:0]shift_by;

logic [7:0]or_out;
logic [7:0]and_out;
logic [7:0]xor_out;
logic [7:0]shift_out;
logic [7:0]zero;
logic [7:0]one;

// logic add_cin;
adder alu_adder (.cin(out_bit_mux), .input_A(out_a_mux), 
  .input_B(out_b_mux), .cout(cflag), .out(add_out));

widemux alu_mux (.in0(zero), .in1(and_out), .in2(or_out), .in3(xor_out), 
  .in4(add_out), .in5(shift_out), .in6(inv_input_A), .in7(one), .sel(sel_out_mux), .out(out));

alu_and alu_and (.input_A(out_a_mux), .input_B(out_b_mux), .out(and_out));
alu_or alu_or (.input_A(out_a_mux), .input_B(out_b_mux), .out(or_out));
alu_xor alu_xor (.input_A(out_a_mux), .input_B(out_b_mux), .out(xor_out));
shifter shifter (.input_A(out_a_mux), .input_B(shift_by), .dir(shift_dir), 
  .mode(shift_mode),.out(shift_out));

always_comb begin 
  // out = 8'b0;            
  // add_cin = 0;
  zero = 8'b0;
  one = 8'b1;


  inv_input_A = ~input_A;
  // inv_input_B = ~input_B;

  case(sel_a_mux)
    1'b0:
      out_a_mux = input_A;
    1'b1:
      out_a_mux = inv_input_A;
  endcase

  case(sel_gd_b_mux)
    1'b0:
      out_b_mux_pre = input_B;
    1'b1:
      out_b_mux_pre = 8'b0;
  endcase

  case(sel_b_mux)
    1'b0:
      out_b_mux = out_b_mux_pre;
    1'b1:
      out_b_mux = ~out_b_mux_pre;
  endcase

  case(sel_bit_mux)
    1'b0:
      out_bit_mux = 0;
    1'b1:
      out_bit_mux = 1;
  endcase

  case(sel_shift_mux)
    1'b0:
      shift_by = {7'b0, out_bit_mux};
    1'b1:
      shift_by = out_b_mux;
  endcase
  // and_out = out_a_mux & out_b_mux;
  // or_out = out_a_mux | out_b_mux;
  // xor_out = out_a_mux ^ out_b_mux;
  // shift_out = {out_a_mux[6:0], 1'b0};

/*
  case(sel_out_mux)
    3'b000: // invert
      out = out_a_mux;
    3'b001: // and
      out = out_a_mux & out_b_mux;
    3'b010: // or
      out = out_a_mux | out_b_mux;
    3'b011: // xor
      out = out_a_mux ^ out_b_mux;
    3'b100: // add
      out = add_out;
    3'b101:  // shift
      out = {out_a_mux, 1'b0};
    default:
      out = 8'b0;
  endcase
*/

  // adder code
  nflag = add_out[7];
  zflag = !(|add_out);
  flags = {cflag, nflag, zflag};
  /*
  case(alu_cmd)
    3'b000: // add 2 8-bit unsigned; automatically makes carry-out
      {sc_o,rslt} = inA + inB + sc_i;
    3'b001: // left_shift
      {sc_o,rslt} = {inA, sc_i};
        begin
      rslt[7:1] = ina[6:0];
      rslt[0]   = sc_i;
      sc_o      = ina[7];
        end
      3'b010: // right shift (alternative syntax -- works like left shift
      {rslt,sc_o} = {sc_i,inA};
      3'b011: // bitwise XOR
      rslt = inA ^ inB;
    3'b100: // bitwise AND (mask)
      rslt = inA & inB;
    3'b101: // left rotate
      rslt = {inA[6:0],inA[7]};
    3'b110: // subtract
      {sc_o,rslt} = inA - inB + sc_i;
    3'b111: // pass A
      rslt = inA;
    endcase
    */
end
   
endmodule