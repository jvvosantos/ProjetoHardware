module SignExtend16to32 (inPut, /**/ outPut) begin
	input [15:0] inPut;
	output [31:0] outPut;

	always @(*) begin
		if (inPut[15]) outPut = ~({16'b0, (~inPut + 1)}) + 1;
		else outPut = {16'b0, inPut};
	end
end
