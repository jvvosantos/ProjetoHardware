module ShiftSrcMux (ShiftSrc, in_regA, in_regB, in_immed, mux_out);

input [1:0] ShiftSrc;
input [31:0] in_regA;
input [31:0] in_regB;
input [31:0] in_immed;
output reg [31:0] mux_out;

always @(ShiftSrc) begin
	
	case (ShiftSrc)
		2b'00: mux_out <= in_regA;
		2b'01: mux_out <= in_regB;
		2b'10: mux_out <= in_immed;
	endcase
end
endmodule