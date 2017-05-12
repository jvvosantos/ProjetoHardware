module divisor (clk, DivCtrl, divisor, dividendo, /**/ HI, LO)
    //Inputs
    input clk;
    input DivCtrl;
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
    
    //Outputs HI e LO
    output reg [31:0] HI;
    output reg [31:0] LO;
    
    //Número para fim das iterações
    parameter END <= 6'b100000;
    
    //Executar somente quando DivCtrl estiver ativado
    always @(clk posedge && DivCtrl) begin
        if (count < END) begin
            if (divisorIn <= dividendoIn) begin
                dividendoIn <= dividendoIn - divisorIn;
                quotient <= quotient + quotientCounter;
            end
            
            quotientCounter >> 1;
            divisorIn <= divisorIn >> 1;
            count <= count + 1;
        end else begin
            HI <= dividendoIn [31:0];
            LO <= quotient;
    end
        
    initial begin
        //divisorIn a princípio está shifted left 32 vezes
        divisorIn <= {divisor, 32'b00000000000000000000000000000000};
        dividendoIn <= {32'b00000000000000000000000000000000, dividendo};
        quotientCounter <= 32'b10000000000000000000000000000000;
        count <= 0;
    end
endmodule
