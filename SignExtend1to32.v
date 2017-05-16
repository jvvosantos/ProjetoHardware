module SignExtend1to32 (inPut, /**/ outPut);
	input inPut;
	output [31:0] outPut;

	always @(*) begin
		outPut = {31'b0, inPut};
	end
endmodule
