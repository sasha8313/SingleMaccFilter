//fir lpf
//fs = 48000
//fpass = 3000
//fstop = 8000
//order = 15
module singleMaccFilter(
	input Rst_i,
	
	input CoeffClk_i,
	input [3:0] CoeffAddr_i,
	input [17:0] CoeffData_i,
	input CoeffWr_i,
	
	input Clk_i,
	input [17:0] Data_i,
	input DataNd_i,
	output [17:0] Data_o,
	output DataValid_o
);

	wire [3:0] coeffRdAddr;
	wire [17:0] rdCoeff;
	dualPortCoeffRamBlock #
	(
		.addrWidth(4),
		.dataWidth(18)
	)
	coeffBankInst
	(
		.ClkWr_i(CoeffClk_i),
		.ClkRd_i(Clk_i),
		.Addra_i(CoeffAddr_i),
		.Addrb_i(coeffRdAddr),
		.Wea_i(CoeffWr_i),
		.Dina_i(CoeffData_i),
		.Douta_o(),
		.Doutb_o(rdCoeff)
	);

	wire [3:0] rdAddr;
	wire [17:0] rdData;
	wire [3:0] addrWr;
	dataBank # (
		.addrWidth(4),
		.dataWidth(18)
	)
	dataBankInst
	(
		.Clk_i(Clk_i),
		.AddrWr_i(addrWr),
		.Wr_i(DataNd_i),
		.Din_i(Data_i),	
	
		.Addr_i(rdAddr),
		.Dout_o(rdData)
	);
	
	wire startAcc;
	wire outDataValid;
	ctrlBlock ctrlBlockInst (
		.Rst_i(Rst_i),
		.Clk_i(Clk_i),
	
		.DataNd_i(DataNd_i),
	
		.DataAddrWr_o(addrWr),
		.DataAddr_o(rdAddr),
		.CoeffAddr_o(coeffRdAddr),
		.StartAcc_o(startAcc),
	
		.DataValid_o(outDataValid)
	);	
	
	wire [47:0] outData;
	maccBlock maccInst(
		.Rst_i(Rst_i),
		.Clk_i(Clk_i),
	
		.StartAcc_i(startAcc),
	
		.A_i(rdData),
		.B_i(rdCoeff),
	
		.P_o(outData)
	);	
	
	wire dataValid;
	roundSymmetric #
	( 
		.inDataWidth(38),
		.outDataWidth(18)
	)
	roundInst
	(
		.Rst_i(Rst_i),
		.Clk_i(Clk_i),
		.Data_i(outData[37:0]),
		.DataNd_i(outDataValid),
		.Data_o(Data_o),
		.DataValid_o(DataValid_o)
	);	
	
endmodule
