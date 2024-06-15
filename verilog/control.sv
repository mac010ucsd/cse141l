module control (
  input [8:0] instr,    // subset of machine code (any width you need)
  input [2:0] alu_flags,
  output logic inv_b_mux,
                b_or_0_mux,
                b_or_1_mux,
                cin,
                pc_jmp_en,
                reg_wr_en,
                reg_loopback,
                dat_wr_en,
                dat_in_sel,
                alu_or_reg_to_dat_sel,
  output logic [3:0] alu_op,
  output logic [3:0] LutPointer
);

always_comb begin
  // defaults
  inv_b_mux = 'b0;
  b_or_1_mux = 'b0;
  b_or_0_mux = 'b0;
  cin = 'b0;
  alu_op = 4'b0000;
  LutPointer = 4'b0000;
  pc_jmp_en = 'b0;
  reg_wr_en = 'b0;
  reg_loopback = 'b0;
  dat_wr_en = 'b0;
  dat_in_sel = 'b0;
  alu_or_reg_to_dat_sel = 'b0;

  casez(instr[8:3])   // take 6 msb as opcode.
    'b000???: begin // cmp, same as subtract. (A - B)
      cin = 1'b1;
      inv_b_mux = 1'b1;
      alu_op = 4'b0010;
    end
    'b001???: begin // mov
      reg_wr_en = 1'b1;
      reg_loopback = 1'b1;
      // no alu sel out
    end
    'b01000?: begin // add
      alu_op = 4'b0001;
      reg_wr_en = 1'b1;
    end
    'b01001?: begin // sub
      cin = 1'b1;
      inv_b_mux = 1'b1;
      alu_op = 4'b0010;
      reg_wr_en = 1'b1;
    end
    'b01010?: begin // lsl 2r 2r
      alu_op = 4'b0011;
      reg_wr_en = 1'b1;
    end
    'b01011?: begin // rol 2r 2r
      alu_op = 4'b0101;
      reg_wr_en = 1'b1;
    end
    'b01100?: begin // and
      alu_op = 4'b0111;
      reg_wr_en = 1'b1;
    end
    'b01101?: begin // or
      alu_op = 'b1000;
      reg_wr_en = 1'b1;
    end
    'b01110?: begin // xor
      alu_op = 'b1001;
      reg_wr_en = 1'b1;
    end // 'b011111
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

      // pc_jmp_en = 1'b1;
      pc_jmp_en = !alu_flags[2];
      LutPointer = instr[3:0];
    end
    'b10001?: begin // jg
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
      // pc_jmp_en = 1'b1;
      // flags = {cflag, nflag, zflag};
      pc_jmp_en = !alu_flags[2] & alu_flags[0];
      LutPointer = instr[3:0];
    end
    'b10010?: begin // jmp
      pc_jmp_en = 1'b1;
      LutPointer = instr[3:0];
    end

    'b101000: begin // inc
      b_or_1_mux = 1'b1;
      alu_op = 4'b0001;
      reg_wr_en = 1'b1;
    end
    'b101001: begin // lsl
      alu_op = 4'b0011;
      b_or_1_mux = 1'b1; 
      reg_wr_en = 1'b1;
    end
    'b101010: begin // rol 
      alu_op = 4'b0101;
      b_or_1_mux = 1'b1; 
      reg_wr_en = 1'b1;
    end
    'b101011: begin // clr
      b_or_0_mux = 1'b1;
      alu_op = 4'b0111; // AND op1 with 'b0;
      reg_wr_en = 1'b1;
    end
    'b101100: begin // not 
      alu_op = 4'b1010;
      reg_wr_en = 1'b1;
    end
    'b101101: begin // lsr
      alu_op = 4'b0100;
      b_or_1_mux = 1'b1;
      reg_wr_en = 1'b1;
    end
    
    'b101110: begin // ldr 
      reg_wr_en = 1'b1;
      alu_or_reg_to_dat_sel = 1'b1; // load from [reg0] to reg
    end
    'b101111: begin // str 
      dat_wr_en = 1'b1;
      dat_in_sel = 1'b1;  // store from reg0 to [reg]
    end
    'b110000: begin // ldi
      reg_wr_en = 1'b1;
      alu_or_reg_to_dat_sel = 1'b1; // load from 64+imm to reg0
    end
    'b110001: begin // sti 
      dat_wr_en = 1'b1;
      dat_in_sel = 1'b1;  // store from reg0 to 64+imm
    end

  endcase

end
	
endmodule
