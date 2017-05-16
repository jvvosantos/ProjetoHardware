module EPC (clk, EPCWrite, inPut, /**/ outPut);
	input clk;
	input EPCWrite;
	input [31:0] inPut;

	output reg [31:0] outPut;

	always @(posedge clk) begin
		if (EPCWrite) outPut = inPut;
	end
endmodule
