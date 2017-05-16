module HICtrlMux (HICtrl, in_mult, in_div, hi_out);

input HICtrl;
input [31:0] in_mult;
input [31:0] in_div;
output reg [31:0] hi_out;

always @(HICtrl) begin
	
	case (HICtrl)
		0: 
			begin
				hi_out <= in_mult;
			end
		1: 
			begin
				hi_out <= in_div;
			end
	endcase
end
endmodule