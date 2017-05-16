module MemDMux (MemD, in_wordB, in_byteB, in_halfB, mux_out);

input [1:0] MemD;
input [31:0] in_wordB;
input [31:0] in_byteB;
input [31:0] in_halfB;
output reg [31:0] mux_out;

always @(MemD) begin
	
	case (MemD)
		2'b00: 
			begin
				mux_out <= in_wordB;
			end
		2'b01: 
			begin
				mux_out <= in_byteB;
			end
		2'b10: 
			begin
				mux_out <= in_halfB;
			end
	endcase
end
endmodule