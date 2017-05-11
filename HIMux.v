module HIMux (HICtrl, in_mult, in_div, hi_out);

input HICtrl;
input [31:0] in_mult;
input [31:0] in_div;
output reg [31:0] hi_out;

always @(HICtrl) begin
	
	case (HICtrl)
		0: hi_out <= in_mult;
		1: hi_out <= in_div;
	endcase
end
endmodule