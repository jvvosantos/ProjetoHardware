module SignExtend8to32 (inPut, /**/ outPut) begin
	input [7:0] inPut;
	output reg [31:0] outPut;

	always @(*) begin
		outPut = {inPut[7], 24'b0, inPut[6:0]};
	end
end
