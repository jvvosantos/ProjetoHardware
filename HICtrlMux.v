module HICtrlMux (HICtrl, in_mult, in_div, hi_out);

input HICtrl;
input [31:0] in_mult;
input [31:0] in_div;
output reg [31:0] hi_out;

always @(1) begin
	
	case (HICtrl)
		0: 
			begin
				hi_out <= in_mult;
			end
		1: 
			begin
				hi_out <= in_div;
			end
		default: hi_out <= hi_out;
	endcase
end
endmodule