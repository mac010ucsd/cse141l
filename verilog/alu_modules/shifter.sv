// combinational -- no clock
// sample -- change as desired
module shifter(
    input[7:0] input_A, input_B,	 // 8-bit wide data path
    // input      sc_i,       // shift_carry in
    input dir, mode,
    output logic[7:0] out
);

// logic add_cin;

// logic [2:0] 

always_comb begin 
    case ({dir, mode})
        /*
        2'b00:            out = {input_A[input_B:0], input_B{1'b0}};
        2'b01:            out = {input_A[8'd7-input_B:0], input_A[8'd7:8'd7-input_B]};
        2'b10:            out = {input_B{1'b0}, input_A[7:input_B]};
        2'b11:            out = {input_A[input_B:0], input_A[7:input_B]};*/
        2'b00:
            out = input_A << input_B;
        2'b01:
            out = input_A << input_B | input_A >> (7-input_B);
        2'b10:
            out = input_A >> input_B;
        2'b11:            
            out = input_A >> input_B | input_A << (input_B);

    endcase
end
endmodule