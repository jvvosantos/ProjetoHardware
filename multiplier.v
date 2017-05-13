module multiplier (clk, MultCtrl, MultReset, fator0, fator1, /**/ HI, LO, MultOUT)
    input clk;
	input MultCtrl;
	input MultReset;
    input reg [31:0] fatorA;
    input reg [31:0] fatorB;
    
	reg [63:0] multiplicando;
	reg [31:0] multiplicador;
    reg [5:0] count;
    reg [63:0] resultado;
    
    output reg [31:0] HI;
    output reg [31:0] LO;
	output MultOUT;
	
	parameter RESET = 0;
	parameter EXECUTE = 1;
    
    always @(clk posedge) begin

		if (MultReset) begin
			HI <= 32'b0;
			LO <= 32'b0;
			resultado <= 64'b0;
		end
	   if (count < END) begin
            if (multiplicador[count] == 1'b1) begin
			resultado <= resultado + multiplicando;
            end
            multiplicando <= multiplicando << 1;
            count <= count + 1;
        end 
		if (count == 32) begin
			HI <= resultado[63:32];
			LO <= resultado[31:0];
			MultOUT <= 1'b1;
			count <= 0;
		end
    end
    
    initial begin
        count <= 0;
		// o fatorA será inicialmente concatenado com 32 zeros a esquerda
		multiplicando <= (32'b0, fatorA);
		multiplicador <= fatorB;
		resultado <= 64'b0;
    end
endmodule 