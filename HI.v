module HI (clk, HIIn, /**/ HIOut);
	input clk;
	input [31:0] HIIn;
	output reg [31:0] HIOut;

	always @(posedge clk) begin
		HIOut <= HIIn;
	end
endmodule
