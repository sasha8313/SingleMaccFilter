module roundSymmetric #
( 
	parameter inDataWidth = 35,
	parameter outDataWidth = 17
)
(
	input Rst_i,
	input Clk_i,
	input [inDataWidth-1 : 0] Data_i,
	input DataNd_i,
	output [outDataWidth-1 : 0] Data_o,
	output DataValid_o
);
	
	parameter [inDataWidth-1 : 0] addPositive = 2**(inDataWidth-outDataWidth-1);
	parameter [inDataWidth-1 : 0] addNegative = 2**(inDataWidth-outDataWidth-1)-1;
	
	reg [inDataWidth-1 : 0] corrData;
	always @ (posedge Clk_i or posedge Rst_i)
		if (Rst_i)
			corrData <= 0;
		else if (DataNd_i)
			begin
				if (Data_i[inDataWidth-1])
					corrData <= Data_i + addNegative;
				else 
					corrData <= Data_i + addPositive;
			end
			
	assign Data_o = corrData[inDataWidth-1 : inDataWidth-outDataWidth];
	
	reg outDataValidReg;
	always @ (posedge Clk_i) outDataValidReg <= DataNd_i;
	assign DataValid_o = outDataValidReg;

endmodule
