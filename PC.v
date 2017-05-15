module PC (/**/);
	input PCWriteCond, PCWrite, ALUflagMuxOut;
	input [31:0] instructionIn;

	output reg [31:0] instructionOut;

	always @(posedge clk) begin
		if ((PCWriteCond && ALUflagMuxOut) || PCWrite) begin
			instructionOut <= instructionIn;
		end
	end
endmodule
