module LOMux (LOCtrl, in_mult, in_div, lo_out);

input LOCtrl;
input [31:0] in_mult;
input [31:0] in_div;
output reg [31:0] lo_out;

always @(LOCtrl) begin
	
	case (LOCtrl)
		0: lo_out <= in_mult;
		1: lo_out <= in_div;
	endcase
end
endmodule