input clock;
input DivCtrl;

input  reg [63:0] dividend;
input  reg [63:0] divisor;
output reg [63:0] quotient;
output reg [63:0] remainder;


for(i = 0; i < 33; i= i + 1) begin
    if(remainder < 0) begin
        remainder = remainder + divisor;
        quotient << 1;
    end else begin
        quotient << 1;
    end
    
    divisor >> 1;
end
