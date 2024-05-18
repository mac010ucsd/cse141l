// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file (
	input[7:0] 	dat_in,
	input      	clk,
	input      	wr_en,           // write enable
	input[3:0] 	rd_addr,		  // read address pointers
				rdwr_addr,
	output logic[7:0] 	datA_out, // read data
						datB_out);

  	logic[7:0] regs [8];    // 2-dim array  8 wide  8 deep

	assign datA_out = regs[rd_addr];
	assign datB_out = regs[rdwr_addr];

	// writes are sequential (clocked)
	always_ff @(posedge clk) begin
		if(wr_en)				   
			regs [rdwr_addr] <= dat_in; 
	end

endmodule