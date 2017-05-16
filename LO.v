module LO (LOIn, /**/ LOOut);
	input [31:0] LOIn;
	output reg [31:0] LOOut;

	always @(posedge clk) begin
		LOOut <= LOIn;
	end
endmodule
