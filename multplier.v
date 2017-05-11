input clock;
input MultCtrl;


input  reg [63:0] multiplicand;
input  reg [63:0] multiplier;
output reg [63:0] product;

for(i = 0; i < 32; i = i + 1) begin
    
    if(multiplier && 1 == 1'd1) begin
        product = product + multiplicand;  
    end

    multiplicand << 1;
    multiplier >> 1;

end
