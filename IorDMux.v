module IorDMux (IorD, in_regA, in_PC, in_ALUout, mux_out);

input [2:0] IorD;
input [31:0] in_regA;
input [31:0] in_PC;
input [31:0] in_ALUout;
output reg [31:0] mux_out;

always @(1) begin
	
	case (IorD)
		3'b000: 
			begin
				mux_out <= in_regA;
			end
		3'b001: 
			begin
				mux_out <= in_PC;
			end
		3'b010: 
			begin
				mux_out <= in_ALUout;
			end
		3'b011: 
			begin
				mux_out <= 16'd253;
			end
		3'b100: 
			begin
				mux_out <= 16'b0000000011111110;
			end
		3'b101: 
			begin
				mux_out <= 16'b0000000011111111;		
			end
		default: mux_out <= mux_out;
	endcase
end
endmodule