module control (
  input [8:0] instr,    // subset of machine code (any width you need)
  input [2:0] alu_flags,
  output logic sel_a_mux,
              sel_b_mux,
              sel_gd_b_mux,
              sel_bit_mux,
              sel_shift_mux,
              shift_dir,
              shift_mode,
              reg_wr_en,
              dat_wr_en,
              pc_jmp_abs,
              reg_in_sel,
              dat_in_sel,
              reg_alu_dat_sel,
              pc_jmp_en,
  output logic [2:0] alu_sel_out,
  output logic [3:0] LutPointer
);
/*
output sel_a_mux,
sel_b_mux,
sel_gd_b_mux,
sel_bit_mux,
sel_shift_mux,
shift_dir,
shift_mode,
output [3:0] sel_out_mux
*/

/*
widemux alu_mux (.in0(zero), .in1(and_out), .in2(or_out), .in3(xor_out), 
  .in4(add_out), .in5(shift_out), .in6(inv_input_A), .in7(one), .sel(sel_out_mux), .out(out));
*/

always_comb begin
  // defaults
  sel_a_mux = 'b0;        // 1 = invert
  sel_b_mux = 'b0;        // 1 = invert
  sel_gd_b_mux = 'b0;     // 1 = b is gd
  sel_bit_mux = 'b0;      // 0 or 1 bit
  sel_shift_mux = 'b0;    // shift with bit (0) or b_mux (1)
  shift_dir = 'b0;        // 0 = L, 1 = R
  shift_mode = 'b0;       // 0 = sh, 1 = rot
  reg_wr_en = 'b0;        
  dat_wr_en = 'b0;
  pc_jmp_abs = 'b0;
  alu_sel_out = 'b0;      // to do i guess.
  reg_in_sel = 'b0;
  reg_alu_dat_sel = 'b0;
  dat_in_sel = 'b0;
  pc_jmp_en = 'b0;
  LutPointer = 'b0;
  
  casez(instr[8:3])   // take 6 msb as opcode.
    'b000???: begin // cmp, same as subtract. (A - B)
      sel_a_mux = 1'b0;
      sel_b_mux = 1'b1;
      sel_bit_mux = 1'b1; // carry in = 1
      alu_sel_out = 3'b100;
    end
    'b001???: begin // mov
      reg_wr_en = 1'b1;
      reg_in_sel = 1'b1;
      // no alu sel out
    end
    'b01000?: begin // add
      sel_a_mux = 1'b0;
      sel_b_mux = 1'b0;
      sel_bit_mux = 1'b0;
      alu_sel_out = 3'b100;
      reg_wr_en = 1'b1;
    end
    'b01001?: begin // sub
      sel_a_mux = 1'b0;
      sel_b_mux = 1'b1; // invert for sub
      sel_bit_mux = 1'b1;
      alu_sel_out = 3'b100;
      reg_wr_en = 1'b1;
    end
    'b01010?: begin // lsl 2r 2r
      sel_a_mux = 1'b0;
      sel_shift_mux = 1'b0; // shift with b
      shift_dir = 'b0;
      shift_mode = 'b0;
      alu_sel_out = 3'b101;
      reg_wr_en = 1'b1;
    end
    'b01011?: begin // rol 2r 2r
      sel_a_mux = 1'b0;
      sel_shift_mux = 1'b0; // shift with b
      shift_dir = 'b0;
      shift_mode = 'b1;
      alu_sel_out = 3'b101;
      reg_wr_en = 1'b1;
    end
    'b01100?: begin // and
      sel_a_mux = 1'b0;
      sel_b_mux = 1'b0;
      alu_sel_out = 3'b001;
      reg_wr_en = 1'b1;
    end
    'b01101?: begin // or
      sel_a_mux = 1'b0;
      sel_b_mux = 1'b0;
      alu_sel_out = 3'b010;
      reg_wr_en = 1'b1;
    end
    'b01110?: begin // xor
      sel_a_mux = 1'b0;
      sel_b_mux = 1'b0;
      alu_sel_out = 3'b011;
      reg_wr_en = 1'b1;
    end
    'b10000?: begin // jge TODO
      // flags = {cflag, nflag, zflag};
      // JAE = JG -> CF
      // basic understanding:
      // if A is greater than or equal to B,
      // when A - B (both positive but A >= B):
      // result is > 0
      // then carry flag not invoked
      // so look for carry flag == 0
      // jmp_flag_reqs = 

      pc_jmp_abs = 1'b0;
      // pc_jmp_en = 1'b1;
      pc_jmp_en = !alu_flags[2];
      LutPointer = instr[3:0];
    end
    'b10001?: begin // jg TODO
      // JA = JG -> CF, ZF
      // basic understanding:
      // if A is greater than or equal to B,
      // when A - B (both positive but A >= B):
      // result is > 0
      // then carry flag not invoked
      // so look for carry flag == 0
      // if zero flag == 0 then it is equal. we don't want that
      // then look for zero flag == 1
      // look for CF = 0, ZF = 1
      pc_jmp_abs = 1'b0;
      // pc_jmp_en = 1'b1;
      // flags = {cflag, nflag, zflag};
      pc_jmp_en = !alu_flags[2] & alu_flags[0];
      LutPointer = instr[3:0];
    end
    'b10010?: begin // jmp TODO
      pc_jmp_abs = 1'b0;
      pc_jmp_en = 1'b1;
      LutPointer = instr[3:0];
    end
    'b101000: begin // inc
      sel_bit_mux = 1'b1; // select 1 bit carry in
      sel_gd_b_mux = 1'b1; // select gd as B
      alu_sel_out = 3'b100; // add out select
      reg_wr_en = 1'b1;
    end
    'b101001: begin // lsl 
      sel_a_mux = 1'b0;
      sel_shift_mux = 1'b1;
      sel_shift_mux = 1'b1; // shift with bit
      shift_dir = 'b0;
      shift_mode = 'b0;
      alu_sel_out = 3'b101;
      reg_wr_en = 1'b1;
    end
    'b101010: begin // rol 
      sel_a_mux = 1'b0;
      sel_shift_mux = 1'b1;
      sel_shift_mux = 1'b1; // shift with bit
      shift_dir = 'b0;
      shift_mode = 'b1;
      alu_sel_out = 3'b101;
      reg_wr_en = 1'b1;
    end
    'b101011: begin // clr 
      sel_a_mux = 1'b0;
      sel_gd_b_mux = 1'b1; // gnd as B
      alu_sel_out = 3'b001; // A & 0
      reg_wr_en = 1'b1;
    end
    'b101100: begin // not 
      sel_a_mux = 1'b1; // ~A
      alu_sel_out = 3'b110; // ~A
      reg_wr_en = 1'b1;
    end
    'b101101: begin // ldr 
      reg_wr_en = 1'b1;
      reg_alu_dat_sel = 1'b1; // data from dat mem into reg dat in. 
    end
    'b101110: begin // str 
      dat_wr_en = 1'b1;
      dat_in_sel = 1'b1;  // select data from re g file to go into dat_in
    end
    'b110000: begin // ldr 
      reg_wr_en = 1'b1;
      reg_alu_dat_sel = 1'b1; // data from dat mem into reg dat in. 
    end
    'b110001: begin // str 
      dat_wr_en = 1'b1;
      dat_in_sel = 1'b1;  // select data from re g file to go into dat_in
    end
  endcase

end
	
endmodule