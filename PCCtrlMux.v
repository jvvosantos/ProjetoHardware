module PCCtrlMux (PCCtrl, in_PCSource, in_MemData, mux_out);

input PCCtrl;
input [31:0] in_PCSource;
input [31:0] in_MemData;
output reg [31:0] mux_out;

always @(PCCtrl) begin
	
	case (PCCtrl)
		0: mux_out <= in_PCSource;
		1: mux_out <= in_MemData;
	endcase
end
endmodule