// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=10)(
  input reset,					// synchronous reset
        clk,
        jmp_en,
  input       [D-1:0] absaddress,
  output logic[D-1:0] prog_ctr,
  output done
);


  always_ff @(posedge clk) begin
    if(reset)
	    prog_ctr <= 'b0;
    else if(jmp_en)
	    prog_ctr <= absaddress;
    else
      prog_ctr <= prog_ctr + 'b1;
  end

  assign done = prog_ctr >= 2**(D) - 1;
endmodule