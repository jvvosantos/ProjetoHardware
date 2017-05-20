module multiplier (clk, MultCtrl, MultReset, fatorA, fatorB, /**/ HI, LO, MultOUT);
    input clk;
	input MultCtrl;
	input MultReset;
    input [31:0] fatorA;
    input [31:0] fatorB;
    
	reg [63:0] multiplicando;
	reg [31:0] multiplicador;
    reg [63:0] resultado;
    reg [5:0] count;
	
    output reg [31:0] HI;
    output reg [31:0] LO;
	output reg [1:0] MultOUT;
    
    always @(posedge clk) begin

		if (MultReset) begin
			HI <= 32'b0;
			LO <= 32'b0;
			resultado <= 64'b0;
			count <= 0;
		end
		if (MultCtrl) begin
			// o fatorA será inicialmente concatenado com 32 zeros a esquerda
			if (count == 0) begin
				multiplicando <= {32'b0, fatorA};
				multiplicador <= fatorB;
			end
		   if (count < 32) begin
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
			end
		end
    end
    
    initial begin
        count <= 0;
		multiplicando <= 64'b0;
		multiplicador <= 32'b0;
		resultado <= 64'b0;
    end
endmodule