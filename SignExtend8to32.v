module SignExtend8to32 (inPut, /**/ outPut);
	input [7:0] inPut;
	output reg [31:0] outPut;

	always @(*) begin
		if (inPut[7]) outPut = ~({24'b0, (~inPut + 1)}) + 1;
		else outPut = {24'b0, inPut};
	end
endmodule
