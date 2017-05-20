module MemtoRegMux (MemtoReg, in_mdrExtI, in_mdrExtII, in_mdrWrite, in_shift, in_hi, in_lo, in_ALUOut, in_lt, mux_out);

input [3:0] MemtoReg;
input [31:0] in_mdrExtI;
input [31:0] in_mdrExtII;
input [31:0] in_mdrWrite;
input [31:0] in_shift;
input [31:0] in_hi;
input [31:0] in_lo;
input [31:0] in_ALUOut;
input [31:0] in_lt;
output reg [31:0] mux_out;

always @(1) begin
	
	case (MemtoReg)
		4'b0000: 
			begin
				mux_out <= in_mdrExtI;
			end
		4'b0001:
			begin
				mux_out <= in_mdrExtII;
			end
		4'b0010:
			begin
				mux_out <= in_mdrWrite;
			end
		4'b0011: 
			begin
				mux_out <= in_shift;
			end
		4'b0100:
			begin
			mux_out <= in_hi;
			end
		4'b0101:
			begin
				mux_out <= in_lo;
			end
		4'b0110:
			begin
			mux_out <= in_ALUOut;
			end
		4'b0111: 
			begin
				mux_out <= in_lt;
			end
		4'b1000:
			begin
				mux_out <= 8'b11100011;
			end
		4'b1001: 
			begin
				mux_out <= 2'b01;
			end
		4'b1010: 
			begin
				mux_out <= 2'b10;
			end
		4'b1011:
			begin
				mux_out <= 2'b11;		
			end
		default: mux_out <= mux_out;
	endcase
end
endmodule