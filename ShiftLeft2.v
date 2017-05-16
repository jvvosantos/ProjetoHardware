module ShiftLeft2 (inPut, /**/ outPut); 
	input [25:0] inPut;
	output reg [27:0] outPut;

	always @(*) begin
		outPut = {inPut, 2'b0};
	end
endmodule
