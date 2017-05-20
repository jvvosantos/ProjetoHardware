module Arauto2 (vc, vt, qz, saida);

input [4:0] vc;
input [4:0] vt;
input [15:0] qz;
output reg [25:0] saida;

always @(1) begin
	saida = {vc[4:0], vt[4:0], qz[15:0]};
end
endmodule