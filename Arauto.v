module Arauto (rs, rt, rd, rs_out, rs_out2, rt_out, rt_out2, rt_out3, rd_out15, rd_out, funct);

input [4:0] rs;
input [4:0] rt;
input [15:0] rd;
output reg [4:0] rs_out;
output reg [4:0] rs_out2;
output reg [4:0] rt_out;
output reg [4:0] rt_out2;
output reg [4:0] rt_out3;
output reg [4:0] rd_out;
output reg [15:0] rd_out15;
output reg [5:0] funct;

always @(1) begin
	rs_out <= rs;
	rs_out2 <= rs;
	rt_out <= rt;
	rt_out2 <= rt;
	rt_out3 <= rt;
	rd_out <= rd[15:11];
	rd_out15 <= rd;
	funct <= rd[5:0];
	
end
endmodule