module multiplier (/**/)
    input clk;
    input reg [31:0] fator0;
    input reg [31:0] fator1;
    
    reg [5:0] count;
    
    
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
endmodule
