module ALUSrcAMux (ALUSrcA, in_pc, in_mdr, in_regA, mux_out);

input [1:0] ALUSrcA;
input [31:0] in_pc;
input [31:0] in_mdr;
input [31:0] in_regA;
output reg [31:0] mux_out;

always @(ALUSrcA) begin
	
	case (ALUSrcA)
		2'b00: 
			begin
				mux_out <= in_pc;
			end
		2'b01: 
			begin
				mux_out <= in_mdr;
			end	
		2'b10: 
			begin
				mux_out <= in_regA;
			end
	endcase
end
endmodule