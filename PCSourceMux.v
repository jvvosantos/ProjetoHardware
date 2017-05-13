module PCSourceMux (PCSource, in_ALUresult, in_ALUout, in_JInst, in_EPC, mux_out);

input [1:0] PCSource;
input [31:0] in_ALUresult;
input [31:0] in_ALUout;
input [31:0] in_JInst;
input [31:0] in_EPC;
output reg [31:0] mux_out;

always @(PCSource) begin
	
	case (PCSource)
		2b'00: mux_out <= in_ALUresult;
		2b'01: mux_out <= in_ALUout;
		2b'10: mux_out <= in_JInst;
		2b'11: mux_out <= in_EPC;
	endcase
end
endmodule