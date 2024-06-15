module decoder (
    input [8:0] instr,    
    // output logic [8:0] opcode, // opcode passthrough
    output logic [3:0] reg0, reg1,
    output logic [7:0] imm,
    output logic use_imm);

always_comb begin
    // opcode = instr;
    imm = 'b0;
    use_imm = 'b0;
    reg0 = 'b0;
    reg1 = 'b1;
    casez(instr)    // override defaults with exceptions
        'b00???????: begin // for cmp, mov
            reg0 = instr[5:3];
            reg1 = instr[2:0];
            use_imm = 'b0;
        end // [3 bit op] [3 bit reg] x 2
        'b01???????: begin
            reg0 = {1'b0, instr[3:2]};
            reg1 = {1'b0, instr[1:0]};
            use_imm = 'b0;
        end // [5 bit op] [4 bit imm] for jumps. prio over other reg case.
        'b1000?????: begin // jg, jge
            reg0 = 'b0;
            reg1 = 'b0;
            imm = {4'b0, instr[3:0]};
            use_imm = 'b1;
        end 
        'b1001?????: begin // jmp
            reg0 = 'b0;
            reg1 = 'b0;
            imm = {4'b0, instr[3:0]};
            use_imm = 'b1;
        end 
        'b1010?????: begin // 1 3-bit reg inc ... clr
            reg0 = {instr[2:0]};
            reg1 = 'b0;
            use_imm = 'b0;
        end 
        'b10110????: begin // 1 3-bit reg not, lsr
            reg0 = {instr[2:0]};
            reg1 = 'b0;
            use_imm = 'b0;
        end 
        'b10111????: begin // ldr, str
            reg0 = {instr[2:0]};
            reg1 = 'b0;
            use_imm = 'b0;
        end 
        'b11000????: begin // ldi, sti (+64)
            reg0 = 'b0;
            reg1 = 'b0;
            /// 0100 0000
            imm = {4'b01000, instr[2:0]};
            use_imm = 'b1;
        end 
        default: begin
            reg0 = 'b0;
            reg1 = 'b0;
            imm = 'b0;
            use_imm = 'b0;
        end
    endcase
end
	
endmodule