module ALUSrcBMux (ALUSrcB, in_regB, in_signExt, mux_out);

input [3:0] ALUSrcB;
input [31:0] in_regB;
input [31:0] in_signExt;
output reg [31:0] mux_out;

always @(ALUSrcB) begin
	
	case (ALUSrcB)
		3b'000: mux_out <= in_B;
		3b'001: mux_out <= 32b'100;
		3b'010: mux_out <= in_signExt;
		3b'011: mux_out <= 32b'000;
	endcase
end
endmodule