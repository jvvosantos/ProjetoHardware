module MemDMux (MemD, in_wordB, in_byteB, in_halfB, mux_out);

input MemD;
input [31:0] in_wordB;
input [31:0] in_byteB;
input [31:0] in_halfB;
output reg [31:0] mux_out;

always @(MemD) begin
	
	case (MemD)
		2b'00: mux_out <= in_wordB;
		2b'01: mux_out <= in_byteB;
		2b'10: mux_out <= in_halfB;
	endcase
end
endmodule