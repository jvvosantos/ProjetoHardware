module ALUSrcBMux (ALUSrcB, in_regB, in_signExt, in_signExtSL, mux_out);

input [2:0] ALUSrcB;
input [31:0] in_regB;
input [31:0] in_signExt;
input [31:0] in_signExtSL;
output reg [31:0] mux_out;

always @(ALUSrcB) begin
	
	case (ALUSrcB)
		3b'000: mux_out <= in_B;
		3b'001: mux_out <= 32b'100;
		3b'010: mux_out <= in_signExt;
		3b'011: mux_out <= in_signExtSL;
		3b'100: mux_out <= 32b'000;
	endcase
end
endmodule