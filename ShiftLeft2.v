module ShiftLeft2 (inPut, /**/ outPut) begin
	input [25:0] inPut;
	output [27:0] outPut;

	always @(*) begin
		outPut = {inPut, 2'b0};
	end
end
