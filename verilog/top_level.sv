// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module top (
    input   clk,
            start,
    output  done
);

    logic[9:0] absaddress;
    logic[3:0] LutPointer;

    LUT lut0(.LutPointer(LutPointer), .absaddress(absaddress));

    logic reset;

    assign reset = start;
    
    logic pc_jmp_en;
    logic [9:0] pc;

    logic[2:0] alu_flags;

    PC pc0 (.reset(reset), .clk(clk), 
            .jmp_en (pc_jmp_en),
            .prog_ctr(pc), 
            .absaddress(absaddress));

    logic [8:0] inst;

    instr_ROM rom (.prog_ctr(pc), .mach_code(inst));

    logic inv_b_mux,
            b_or_0_mux,
            b_or_1_mux,
            cin,
            reg_wr_en,
            reg_loopback,
            dat_wr_en,
            dat_in_sel,
            alu_or_reg_to_dat_sel;
    logic [3:0] alu_op;

    logic regA_dual_output;

    control control0 (.instr(inst), .alu_flags(alu_flags), .LutPointer(LutPointer),
        .inv_b_mux(inv_b_mux), .b_or_1_mux(b_or_1_mux), .b_or_0_mux(b_or_0_mux),
        .cin(cin), .pc_jmp_en(pc_jmp_en), .reg_wr_en(reg_wr_en), .reg_loopback(reg_loopback),
        .dat_wr_en(dat_wr_en), .dat_in_sel(dat_in_sel), .alu_or_reg_to_dat_sel(alu_or_reg_to_dat_sel),
        .regA_dual_output(regA_dual_output),
        .alu_op(alu_op));

    logic [3:0] reg0, reg1;
    logic [7:0] imm;
    logic use_imm;

    decoder decode0 (.instr(inst), .reg0(reg0), .reg1(reg1), .imm(imm), .use_imm(use_imm));

    logic[7:0] reg_dat_in;
     // logic[3:0] rdwr_addr, rd_addr;
    logic[7:0] reg_datA_out, reg_datB_out;
    
    logic [7:0] b_or_1;
    assign b_or_1 = b_or_1_mux ? 8'b00000001 : reg_datB_out;

    reg_file regfile0 (.dat_in(reg_dat_in), .clk(clk), .wr_en(reg_wr_en),
        .rdwr_addr(reg0), .rd_addr(reg1), .datA_out(reg_datA_out),
        .datB_out(reg_datB_out));

    logic[7:0] alu_out;

    logic [7:0] imm_value;

    assign imm_value = use_imm ? imm : reg_datA_out;

    alu alu0 (.alu_op(alu_op),
     .cin(cin), 
     .input_A(reg_datA_out), 
     .input_B(b_or_1), 
     .out(alu_out), 
     .flags(alu_flags));
    
    logic[7:0] dat_mem_out;

    logic[7:0] dat_mem_in;

    assign dat_mem_in = regA_dual_output ? reg_datA_out : alu_out;

    dat_mem dm (.dat_in(dat_mem_in), 
        .clk(clk), .wr_en(dat_wr_en), .addr(imm_value), .dat_out(dat_mem_out));

    assign reg_dat_in = dat_in_sel ? reg_datB_out : (alu_or_reg_to_dat_sel ? dat_mem_out : alu_out);
    // assign target = reg_A_out;
    
endmodule