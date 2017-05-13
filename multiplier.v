module multiplier (clk, fator0, fator1, /**/ HI, LO)
    input clk;
    input reg [31:0] fator0;
    input reg [31:0] fator1;
    
    reg [5:0] count;
    reg [63:0] resultado;
    
    output reg [31:0] HI;
    output reg [31:0] LO;
    
    
    always @(clk posedge && MultCtrl) begin
        if (count < END) begin
            if (fator[count]) resultado <= resultado + shiftedFator;
            
            shiftedFator <= shiftedFator << 1;
            count <= count + 1;
        end else begin
            HI <= resultado[63:32];
            LO <= resultado[31:0];
        end
    end
    
    initial begin
        count <= 0;
    end
endmodule