module dataBank # (
	parameter addrWidth = 8,
	parameter dataWidth = 18
)
(
	input Clk_i,
	input [addrWidth - 1:0] AddrWr_i,
	input Wr_i,
	input [dataWidth - 1:0] Din_i,	
	
	input [addrWidth - 1:0] Addr_i,
	output [dataWidth - 1:0] Dout_o
);

	reg [dataWidth - 1:0] dataOutReg;
	reg [dataWidth - 1:0] memArray[(2**addrWidth)-1:0];
	//pragma attribute memArray block_ram true

	always @ (posedge Clk_i)
	begin
		if (Wr_i)
			memArray[AddrWr_i] <= Din_i;
	end
	
	always @ (posedge Clk_i)
		dataOutReg[dataWidth - 1: 0] <= memArray[Addr_i];
	
	assign Dout_o = dataOutReg;

endmodule
