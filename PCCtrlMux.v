module PCCtrlMux (PCCtrl, in_PCSource, in_MemData, mux_out);

input PCCtrl;
input [31:0] in_PCSource;
input [31:0] in_MemData;
output reg [31:0] mux_out;

always @(1) begin
	
	case (PCCtrl)
		0: 
			begin
				mux_out <= in_PCSource;
			end
		1: 
			begin
				mux_out <= in_MemData;
			end
		default: mux_out <= mux_out;
	endcase
end
endmodule