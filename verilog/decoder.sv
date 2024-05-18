module decoder #()(
    input [8:0] instr,    
    output logic [8:0] opcode, // opcode passthrough
    output logic [3:0] reg0, reg1
    output logic [7:0] imm);

always_comb begin
    opcode = instr;
    casez(instr)    // override defaults with exceptions
        'b00???????: begin
            reg0 = instr[5:3];
            reg1 = instr[2:0];
            imm = 'b0;
        end // [3 bit op] [3 bit reg] x 2
        'b0111?????: begin
            reg0 = 'b0;
            reg1 = 'b0;
            imm = {4'b0, opcode[3:0]};
        end // [5 bit op] [4 bit imm] for jumps. prio over other reg case.
        'b10000????: begin
            reg0 = 'b0;
            reg1 = 'b0;
            imm = {4'b0, opcode[3:0]};
        end // [5 bit op] [4 bit imm] for jmp
        'b01???????: begin
            reg0 = {1'b0, instr[3:2]};
            reg1 = {1'b0, instr[1:0]};
            imm = 'b0;
        end // [5 bit op] [2 bit reg] x 2
        'b100??????: begin
            reg0 = 'b0;
            reg1 = {1'b0, instr[3:2]};
            imm = 'b0;
        end // [6 bit op] [3 bit reg]. these insts all store into a register.
        'b101??????: begin
            reg0 = 'b0;
            reg1 = 'b0;
            imm = instr{3:0};
        end // [6 bit op] [3 bit imm]
        default: begin
            reg0 = 'b0;
            reg1 = 'b0;
            imm = 'b0;
        end
    endcase
end
	
endmodule