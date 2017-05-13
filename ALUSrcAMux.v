module ALUSrcAMux (ALUSrcA, in_pc, in_mdr, in_regA, hi_out);

input [1:0] ALUSrcA;
input [31:0] in_pc;
input [31:0] in_mdr;
input [31:0] in_regA;
output reg [31:0] mux_out;

always @(ALUSrcA) begin
	
	case (ALUSrcA)
		2b'00: mux_out <= in_pc;
		2b'01: mux_out <= in_mdr;
		2b'10: mux_out <= in_regA;
	endcase
end
endmodule