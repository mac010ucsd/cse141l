// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module top (
    input   clock,
            start,
    output  done
);

    logic reset;
    logic pc_jmp_abs;
    logic pc_jmp_en;
    logic target;
    logic [9:0] pc;
    logic[2:0] alu_flags;

    PC pc0 (.reset(reset), .clk(clock), .absjump_en(pc_jmp_abs),
            .jmp_en (pc_jmp_en),
            .target(target), .prog_ctr(pc));

    logic [8:0] inst;
    instr_ROM inst_mem0 (.prog_ctr(pc), .mach_code(inst));

    logic sel_a_mux,
        sel_b_mux,
        sel_gd_b_mux,
        sel_bit_mux,
        sel_shift_mux,
        shift_dir,
        shift_mode,
        reg_wr_en,
        dat_wr_en,
        reg_in_sel,
        dat_in_sel,
        reg_alu_dat_sel;
    logic [2:0] alu_sel_out;

    control control0 (.instr(inst), .sel_a_mux(sel_a_mux), .sel_b_mux(sel_b_mux),
        .sel_gd_b_mux(sel_gd_b_mux), .sel_bit_mux(sel_bit_mux), .sel_shift_mux(sel_shift_mux),
        .shift_dir(shfit_dir), .shift_mode(shift_mode), .reg_wr_en(reg_wr_en), .dat_wr_en(dat_wr_en),
        .pc_jmp_abs(pc_jmp_abs), .reg_in_sel(reg_in_sel), .dat_in_sel(dat_in_sel), 
        .reg_alu_dat_sel(reg_alu_dat_sel), .alu_sel_out(alu_sel_out), .pc_jmp_en(pc_jmp_en), .alu_flags(alu_flags));

    logic [3:0] reg0, reg1;
    logic [7:0] imm;
    logic use_imm;

    decoder decode0 (.instr(inst), .reg0(reg0), .reg1(reg1), .imm(imm), .use_imm(use_imm));

    logic[7:0] reg_dat_in;
    logic[3:0] rdwr_addr, rd_addr;
    logic[7:0] reg_datA_out, reg_datB_out;
    reg_file regfile0 (.dat_in(reg_dat_in), .clk(clock), .wr_en(reg_wr_en),
        .rdwr_addr(rdwr_addr), .rd_addr(rd_addr), .datA_out(reg_datA_out),
        .datB_out(reg_datB_out));

    logic[7:0] alu_out;

    logic reg_A_out;
    assign reg_A_out = use_imm ? imm : reg_datA_out;

    alu alu0 (.sel_a_mux(sel_a_mux),
          .sel_b_mux(sel_b_mux),
          .sel_gd_b_mux(sel_gd_b_mux),
          .sel_bit_mux(sel_bit_mux),
          .sel_shift_mux(sel_shift_mux),
          .shift_dir(shift_dir),
          .shift_mode(shift_mode), 
          .sel_out_mux(alu_sel_out),
          .input_A(reg_A_out), // select from a mux.
          .input_B(reg_datB_out),
          .out(alu_out),
          .flags(alu_flags));
    
    logic[7:0] dat_mem_out;

    dat_mem mem0 (.dat_in(dat_in_sel ? reg_datB_out : alu_out), 
        .clk(clock), .wr_en(dat_wr_en), .addr(reg_A_out), .dat_out(dat_mem_out));

    assign reg_dat_in = dat_in_sel ? reg_datB_out : (reg_alu_dat_sel ? dat_mem_out : alu_out);
    assign target = reg_A_out;
    
endmodule