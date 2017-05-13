module divisor (clk, DivCtrl, divisor, dividendo, /**/ HI, LO)
    //Input
    input clk;
    input DivCtrl;
	input reset;
    input reg [31:0] divisor;
    input reg [31:0] dividendo;
    
    //divisorIn e dividendoIn são registradores para guardar e operar internamente sobre os divisor e dividendo, respectivamente
    //quotientCounter é um bit para adição ao quociente toda vez que divisorIn for subtraído de dividendoIn
    //count conta o número de iterações
    reg [63:0] divisorIn;
    reg [63:0] dividendoIn;
    reg [31:0] quotient;
    reg [31:0] quotientCounter;
    reg [5:0] count;
	reg divisorNegativo;
	reg dividendoNegativo;
    reg start;
	
    //Outputs HI e LO
	output reg divZero;
    output reg [31:0] HI;
    output reg [31:0] LO;
    
    //Número para fim das iterações
    parameter END <= 6'b100000;
    
    //Executar somente quando DivCtrl estiver ativado
    always @(clk posedge && (DivCtrl || reset)) begin
		if (reset) begin
			divisorIn <= 64'b0;
			dividendoIn <= 64'b0;
			quotient <= 32'b0;
			quotientCounter <= 32'b0;
			count <= 6'b0;
			HI <= 32'b0;
			LO <= 32'b0;
			start <= 2'b00;
		end else begin
			case (start) begin
				2'b00:
				begin
					if (divisor[31]) begin
						divisorNegativo <= 1;
						divisorIn <= {32'b0, (~divisor + 1)};
					end else begin
						divisorNegativo <= 0;
						divisorIn <= {32'b0, divisor};
					end
					if (dividendo[31]) begin
						dividendoNegativo <= 1;
						dividendoIn <= {32'b0, (~dividendo + 1)};
					end else begin
						dividendoNegativo <= 0;
						dividendoIn <= {32'b0, dividendo};
					end
					
					if (divisor == 0) divZero <= 1;
					
					quotient <= 32'b0;
					quotientCounter <= 32'b0;
					count <= 6'b0;
					HI <= 32'b0;
					LO <= 32'b0;
					start <= 2'b01;
				end
				
				2'b01:
				begin
					if (count < END) begin
						if (divisorIn <= dividendoIn) begin
							dividendoIn <= dividendoIn - divisorIn;
							quotient <= quotient + quotientCounter;
						end
						
						quotientCounter <= quotientCounter >> 1;
						divisorIn <= divisorIn >> 1;
						count <= count + 1;
					end else begin
						if (divisorNegativo == dividendoNegativo) begin
							if (dividendoNegativo) HI <= (~dividendoIn [31:0]) + 1;
							else HI <= dividendoIn [31:0];
							LO <= quotient;
						end else begin
							if (dividendoNegativo) HI <= (~dividendoIn [31:0]) + 1;
							else HI <= dividendoIn [31:0];
							LO < (~quotient + 1);
						end
						start <= 2b'10;
					end
				end
				
				2'b10:
				begin
					divisorIn <= 64'b0;
					dividendoIn <= 64'b0;
					quotient <= 32'b0;
					quotientCounter <= 32'b0;
					count <= 32'b0;
					start <= 2'b0;
				end
			endcase
		end
    end
        
    initial begin
		divisorIn <= 32'b0;
		dividendoIn <= 32'b0;
		quotient <= 32'b0;
		quotientCounter <= 32'b0;
		count <= 32'b0;
		HI <= 32'b0;
		LO <= 32'b0;
		start <= 1'b0;
    end
endmodule
