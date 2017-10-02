module ctrlBlock(
	input Rst_i,
	input Clk_i,
	
	input DataNd_i,
	
	output [3:0] DataAddrWr_o,
	output [3:0] DataAddr_o,
	output [3:0] CoeffAddr_o,
	output StartAcc_o,
	
	output DataValid_o
);

	reg [3:0] addrWr;
	reg [3:0] dataAddr;
	reg [3:0] coeffAddr;
	reg rdy;
	always @ (posedge Clk_i or posedge Rst_i)
		if (Rst_i)
			begin
				addrWr <= 0;
				dataAddr <= 0;
				coeffAddr <= 0;
				rdy <= 0;
			end
		else if (DataNd_i)
			begin
				addrWr <= addrWr + 1;
				dataAddr <= addrWr;
				coeffAddr <= 0;
				rdy <= 0;
			end
		else if (coeffAddr != 15)
			begin
				dataAddr <= dataAddr - 1;
				coeffAddr <= coeffAddr + 1;
				if (coeffAddr != 14)
					rdy <= 0;
				else
					rdy <= 1;
			end
		else
			rdy <= 0;
			
	reg [3:0] rdyShReg;
	always @ (posedge Rst_i or posedge Clk_i)
		if (Rst_i)
			rdyShReg <= 0;
		else
			rdyShReg <= {rdyShReg[2:0], rdy};
			
	reg [2:0] startAccShReg;
	always @ (posedge Rst_i or posedge Clk_i)
		if (Rst_i)
			startAccShReg <= 0;
		else
			startAccShReg <= {startAccShReg[1:0], DataNd_i};
			
	assign DataAddrWr_o = addrWr;
	assign DataAddr_o = dataAddr;
	assign CoeffAddr_o = coeffAddr;
	assign StartAcc_o = startAccShReg[2];
			
	assign DataValid_o = rdyShReg[2];

endmodule
