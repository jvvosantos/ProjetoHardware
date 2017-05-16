module ShiftSrcMux (ShiftSrc, in_regA, in_regB, in_immed, mux_out);

input [1:0] ShiftSrc;
input [31:0] in_regA;
input [31:0] in_regB;
input [31:0] in_immed;
output reg [31:0] mux_out;

always @(ShiftSrc) begin
	
	case (ShiftSrc)
		2'b00: 
			begin
				mux_out <= in_regA;
			end
		2'b01: 
			begin
				mux_out <= in_regB;
			end
		2'b10: 
			begin
				mux_out <= in_immed;
			end
	endcase
end
endmodule