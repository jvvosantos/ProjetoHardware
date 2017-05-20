module ALUflagMux (ALUflag, in_OR, in_gt, in_zero, in_Nzero, mux_out);

input [1:0] ALUflag;
input in_OR;
input in_gt;
input in_zero;
input in_Nzero;
output reg mux_out;

always @(ALUflag or in_OR or in_gt or in_zero or in_Nzero) begin
	case (ALUflag)
		2'b00: 
			begin
				mux_out = in_OR;
			end
		2'b01: 
			begin
				mux_out = in_gt;
			end
		2'b10: 
			begin
				mux_out = in_zero;
			end
		2'b11: 
			begin
				mux_out = in_Nzero;
			end
		default: mux_out = mux_out;
	endcase
end
endmodule