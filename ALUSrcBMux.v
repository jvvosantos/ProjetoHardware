module ALUSrcBMux (ALUSrcB, in_regB, in_signExt, in_signExtSL, mux_out);

input [2:0] ALUSrcB;
input [31:0] in_regB;
input [31:0] in_signExt;
input [31:0] in_signExtSL;
output reg [31:0] mux_out;

always @(1) begin
	
	case (ALUSrcB)
		3'b000: 
			begin
				mux_out <= in_regB;
			end
		3'b001:
			begin
				mux_out <= 32'b100;
			end
		3'b010:
			begin
				mux_out <= in_signExt;
			end
		3'b011:
			begin
				mux_out <= in_signExtSL;
			end
		3'b100:
			begin
				mux_out <= 32'b000;
			end
	endcase
end
endmodule