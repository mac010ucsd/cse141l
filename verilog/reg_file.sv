// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file (
	input[7:0] 	dat_in,
	input      	clk,
	input      	wr_en,           // write enable
	input[3:0] 	rd_addr0,		  // read address pointers
				rd_addr1,
				wr_addr0,
	input[2:0] 	alu_flags,
	// input reset,
	output logic[7:0] 	datA_out, // read data
						datB_out,
	output logic[2:0] alu_flag_ff);

  	logic[7:0] regs [8];    // 2-dim array  8 wide  8 deep
	logic[2:0] alu_reg;

	assign datA_out = regs[rd_addr0];
	assign datB_out = regs[rd_addr1];
	assign alu_flag_ff = alu_reg;

	// writes are sequential (clocked)
	always_ff @(posedge clk) begin
		if(wr_en)				   
			regs [wr_addr0] <= dat_in; 
		regs[7] <= {7'b0, alu_flags[2]};
		alu_reg <= alu_flags;
	end

endmodule