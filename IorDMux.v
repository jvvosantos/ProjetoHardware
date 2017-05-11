module IorDMux (IorD, in_regA, in_PC, in_ALUout, mux_out);

input [2:0] IorD;
input [31:0] in_regA;
input [31:0] in_PC;
input [31:0] in_ALUout;
output reg [31:0] mux_out;

always @(IorD) begin
	
	case (IorD)
		3b'000: mux_out <= in_regA;
		3b'001: mux_out <= in_PC;
		3b'010: mux_out <= in_ALUout;
		3b'011: mux_out <= 16b'1110001111111101;
		3b'100: mux_out <= 16b'1110001111111110;
		3b'101: mux_out <= 16b'1110001111111111;		
	endcase
end
endmodule