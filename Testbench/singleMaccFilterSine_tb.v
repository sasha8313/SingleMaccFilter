`timescale 1ps / 1ps
module singleMaccFilterSine_tb;

	// Inputs
	reg Rst_i;
	reg CoeffClk_i;
	reg [3:0] CoeffAddr_i;
	reg [17:0] CoeffData_i;
	reg CoeffWr_i;
	reg Clk_i;
	reg [17:0] Data_i;
	reg DataNd_i;

	// Outputs
	wire [17:0] Data_o;
	wire DataValid_o;

	// Instantiate the Unit Under Test (UUT)
	singleMaccFilter uut 
	(
		.Rst_i(Rst_i), 
		.CoeffClk_i(CoeffClk_i), 
		.CoeffAddr_i(CoeffAddr_i), 
		.CoeffData_i(CoeffData_i), 
		.CoeffWr_i(CoeffWr_i), 
		.Clk_i(Clk_i), 
		.Data_i(Data_i), 
		.DataNd_i(DataNd_i), 
		.Data_o(Data_o), 
		.DataValid_o(DataValid_o)
	);

	initial begin
		Rst_i = 1;
		CoeffClk_i = 0;
		CoeffAddr_i = 0;
		CoeffData_i = 0;
		CoeffWr_i = 0;
		Clk_i = 0;
		Data_i = 0;
		DataNd_i = 0;
		#100;
		Rst_i <= 0;
	end
      
	parameter period = 5000;
	always # (period / 2) Clk_i <= ~Clk_i;
	
	integer simCnt = 0;
	always @ (posedge Clk_i) simCnt <= simCnt + 1;
	
	real pi = 3.14159265358;
	real phase = 0;
	real phaseInc = 0.01;
	real signal;
	always @ (posedge Clk_i)
		if (simCnt % 16 == 0)
			begin
				DataNd_i <= 1;
				if (simCnt >= 1000)
					begin
						phase = phase + phaseInc;
						signal = $sin(2*pi*phase);
						Data_i = 2**16 * signal;
					end
				else
					Data_i = 0;
			end
		else
			DataNd_i <= 0;
			
	reg [17:0] dataOutTest;
	always @ (posedge Clk_i)
		if (DataValid_o)
			dataOutTest <= Data_o;
		
endmodule

