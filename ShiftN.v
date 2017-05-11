module ShiftNMux (ShiftN, in_shamt, in_funct, mux_out);

input [1:0] ShiftN;
input [31:0] in_shamt;
input [31:0] in_funct;
output reg [31:0] mux_out;

always @(ShiftN) begin
	
	case (ShiftN)
		2b'00: mux_out <= in_regA;
		2b'01: mux_out <= in_regB;
		2b'10: mux_out <= 5b'10000;
	endcase
end
endmodule