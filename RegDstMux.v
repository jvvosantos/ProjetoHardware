module RegDstMux (RegDst, in_rt, in_rd, mux_out);

input RegDst;
input [4:0] in_rt;
input [4:0] in_rd;
output reg [31:0] mux_out;

always @(RegDst) begin
	
	case (RegDst)
		3b'000: mux_out <= in_rt;
		3b'001: mux_out <= in_rd;
		3b'010: mux_out <= 5b'11111;
		3b'011: mux_out <= 5b'11101;
		3b'100: mux_out <= 5b'11110;
	endcase
end
endmodule