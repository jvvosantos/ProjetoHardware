module PCSourceMux (PCSource, in_ALUresult, in_ALUout, in_JInst, in_EPC, mux_out);

input [1:0] PCSource;
input [31:0] in_ALUresult;
input [31:0] in_ALUout;
input [31:0] in_JInst;
input [31:0] in_EPC;
output reg [31:0] mux_out;

always @(PCSource) begin
	
	case (PCSource)
		2'b00: 
			begin
				mux_out <= in_ALUresult;
			end
		2'b01: 
			begin
				mux_out <= in_ALUout;
			end
		2'b10: 
			begin
				mux_out <= in_JInst;
			end
		2'b11: 
			begin
				mux_out <= in_EPC;
			end
	endcase
end
endmodule