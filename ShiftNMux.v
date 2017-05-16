module ShiftNMux (ShiftN, in_shamt, in_funct, mux_out);

input [1:0] ShiftN;
input [4:0] in_shamt;
input [4:0] in_funct;
output reg [31:0] mux_out;

always @(ShiftN) begin
	
	case (ShiftN)
		2'b00: 
			begin
				mux_out <= in_shamt;
			end
		2'b01: 
			begin
				mux_out <= in_funct;
			end
		2'b10: 
			begin
				mux_out <= 5'b10000;
			end
	endcase
end
endmodule