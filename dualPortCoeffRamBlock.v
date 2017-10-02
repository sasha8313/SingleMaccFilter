module dualPortCoeffRamBlock #
(
	parameter addrWidth = 12,
	parameter dataWidth = 8
)
(
	input ClkWr_i,
	input ClkRd_i,
	input [addrWidth-1:0] Addra_i,
	input [addrWidth-1:0] Addrb_i,
	input Wea_i,
	input [dataWidth-1:0] Dina_i,
	output [dataWidth-1:0] Douta_o,
	output [dataWidth-1:0] Doutb_o
);

	reg [dataWidth-1:0] dataOutA;
	reg [dataWidth-1:0] dataOutB;
	reg [dataWidth-1:0] memArray[(2**addrWidth)-1:0];
	//*pragma attribute memArray block_ram true
	
	initial begin
		memArray[0] = 18'h3e6c9;
		memArray[1] = 18'h3c349;
		memArray[2] = 18'h3cfde;
		memArray[3] = 18'h3f440;
		memArray[4] = 18'h05e4b;
		memArray[5] = 18'h0e79f;
		memArray[6] = 18'h172aa;
		memArray[7] = 18'h1c760;
		memArray[8] = 18'h1c760;
		memArray[9] = 18'h172aa;
		memArray[10] = 18'h0e79f;
		memArray[11] = 18'h05e4b;
		memArray[12] = 18'h3f440;
		memArray[13] = 18'h3cfde;
		memArray[14] = 18'h3c349;
		memArray[15] = 18'h3e6c9;
	end

	always @ (posedge ClkWr_i)
	begin
		if (Wea_i)
			memArray[Addra_i] = Dina_i;
	end
		
	always @ (posedge ClkRd_i)
	begin
		dataOutA <= memArray[Addra_i];
	end
	
	always @ (posedge ClkRd_i)
	begin
		dataOutB <= memArray[Addrb_i];
	end
			
	assign Douta_o = dataOutA;
	assign Doutb_o = dataOutB;

endmodule
