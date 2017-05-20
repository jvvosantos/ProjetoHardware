module LOCtrlMux (LOCtrl, in_mult, in_div, lo_out);

input LOCtrl;
input [31:0] in_mult;
input [31:0] in_div;
output reg [31:0] lo_out;

always @(1) begin
	
	case (LOCtrl)
		0: 
			begin
				lo_out <= in_mult;
			end
		1: 
			begin
				lo_out <= in_div;
			end
		default: lo_out <= lo_out;
	endcase
end
endmodule