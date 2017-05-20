module SignExtend24to32 (inPut, /**/ outPut);
	input [23:0] inPut;
	output reg [4:0] outPut;

	always @(*) begin
		if (inPut[23]) outPut = ~({8'b0, (~inPut + 1)}) + 1;
		else outPut = {8'b0, inPut};
	end
endmodule
