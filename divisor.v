module Divisor (/**/)
    //Inputs
    input clk;
    input DivCtrl;
    input reg [31:0] divisor;
    input reg [31:0] dividendo;
    
    reg [63:0] divisorIn;
    reg [63:0] dividendoIn;
    reg [31:0] quotient;
    reg [31:0] quotientCounter;
    reg [5:0] count;
    
    output reg [31:0] HI;
    output reg [31:0] LO;
    
    parameter END <= 6'b000000;
    
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
        divisorIn = {divisor, 32'b00000000000000000000000000000000};
    end
            
endmodule
