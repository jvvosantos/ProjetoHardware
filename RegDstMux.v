module RegDstMux (RegDst, in_rt, in_rd, mux_out);

input [2:0] RegDst;
input [4:0] in_rt;
input [4:0] in_rd;
output reg [4:0] mux_out;

always @(1) begin
	
	case (RegDst)
		3'b000: 
			begin
				mux_out <= in_rt;
			end
		3'b001:
			begin
				mux_out <= in_rd;
			end
		3'b010:
			begin
				mux_out <= 5'b11111;
			end
		3'b011:
			begin
				mux_out <= 5'b11101;
			end
		3'b100:
			begin
				mux_out <= 5'b11110;
			end
		default: mux_out <= mux_out;
	endcase
end
endmodule