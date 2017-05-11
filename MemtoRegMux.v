module MemtoRegMux (MemtoReg, in_mdrExtI, in_mdrExtII, in_mdrWrite, in_shift, in_hi, in_lo, in_ALUOut, in_lt, mux_out);

input MemtoReg;
input [3:0] in_mdrExtI;
input [3:0] in_mdrExtII;
input [31:0] in_mdrWrite;
input [31:0] in_shift;
input [31:0] in_hi;
input [31:0] in_lo;
input [31:0] in_ALUOut;
input [31:0] in_lt;
output reg [31:0] mux_out;

always @(MemtoReg) begin
	
	case (MemtoReg)
		4b'0000: mux_out <= in_mdrExtI;
		4b'0001: mux_out <= in_mdrExtII;
		4b'0010: mux_out <= in_mdrWrite;
		4b'0011: mux_out <= in_shift;
		4b'0100: mux_out <= in_hi;
		4b'0101: mux_out <= in_lo;
		4b'0110: mux_out <= in_ALUOut;
		4b'0111: mux_out <= in_lt;
		4b'1000: mux_out <= 8b'11100011;
		4b'1001: mux_out <= 2b'01;
		4b'1010: mux_out <= 2b'10;
		4b'1011: mux_out <= 2b'11;		
	endcase
end
endmodule