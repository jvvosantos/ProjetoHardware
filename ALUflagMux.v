module ALUflagMux (ALUflag, in_OR, in_gt, in_zero, in_Nzero, mux_out);

input [1:0] ALUflag;
input in_OR;
input in_gt;
input in_zero;
input in_Nzero;

always @(ALUflag) begin
	
	case (ALUflag)
		2b'00: mux_out <= in_OR;
		2b'01: mux_out <= in_gt;
		2b'10: mux_out <= in_zero;
		2b'11: mux_out <= in_Nzero;
	endcase
end
endmodule