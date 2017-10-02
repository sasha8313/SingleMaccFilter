module maccBlock(
	input Rst_i,
	input Clk_i,
	
	input StartAcc_i,
	
	input signed [17:0] A_i,
	input signed [17:0] B_i,
	
	output signed [47:0] P_o
);

	reg signed [35:0] m;
	always @ (posedge Clk_i)
		m <= A_i * B_i;
		
	reg signed [47:0] p;
	always @ (posedge Clk_i)
		if (StartAcc_i)
			p <= m;
		else
			p <= p + m;
		
	assign P_o = p;

endmodule
