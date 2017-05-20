module ShiftLeft2d2 (inPut, /**/ outPut); 
	input [31:0] inPut;
	output reg [31:0] outPut;

	always @(*) begin
		outPut = inPut << 2;
	end
endmodule
