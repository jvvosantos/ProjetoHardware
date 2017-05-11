module UnidadeDeControle ( clk, reset, opcode, funct, ET, GT, LT, /**/ PCCtrl, PCWrite, PCWriteCond, IorD, MemD, MemToReg, Write, IRWrite, ALUflag, ShiftSrc, ShiftN, set, RegDst, MemDReg, RegWrite, MultCtrl, DivCtrl, AluSrcA, AluSrcB, ALUop, EPCWrite, HICtrl, LOCtrl, PCSource);

	input clk;
	input reset;
	input [5:0] opcode;
	input [5:0] funct;
	input ET;
	input GT;
	input LT;
	
	output reg [5:0] estadoSaida;

	reg [5:0] estado;

	output reg PCCtrl,;
	output reg PCWrite;
	output reg PCWriteCond;
	output reg [2:0] IorD;
	output reg MemD;
	output reg Write;
	output reg IRWrite;
	output reg ALUflag;
	output reg ShiftSrc;
	output reg ShiftN;
	output reg set;
	output reg RegDst;
	output reg MemDReg;
	output reg RegWrite;
	output reg MultCtrl;
	output reg DivCtrl;
	output reg [1:0] AluSrcA;
	output reg [2:0] AluSrcB;
	output reg [2:0] ALUop;
	output reg EPCWrite;
	output reg HICtrl; 
	output reg LOCtrl;
	output reg PCSource;
	
	// DEFINICAO DOS ESTADOS
	parameter RESET = 0;
	parameter BUSCA = 1;
	parameter DECODIFICAO = 2; 
	parameter WAIT = 3;
	
	// TIPO R
	parameter ADD = 4;
	parameter AND = 5;
	parameter DIV = 6;
	parameter MULT = 7;
	parameter JR = 8;
	parameter MFHI = 9;
	parameter MFLO = 10;
	parameter SLL = 11;
	parameter SLV = 12;
	parameter SLT = 13;
	parameter SRA = 14;
	parameter SRAV = 15;
	parameter SRL = 16;
	parameter SUB = 17;
	parameter BREAK = 18;
	parameter RTE = 19;
	
	// TIPO I
	parameter ADDI = 20;
	parameter ADDIU = 21;
	parameter BEQ = 22;
	parameter BNE = 23;
	parameter BLE = 24;
	parameter BGT = 25;
	parameter BEQM = 26;
	parameter LB = 27;
	parameter LH = 28;
	parameter LUI = 29;
	parameter LW = 30;
	parameter SB = 31;
	parameter SH = 32;
	parameter SLTI = 33;
	parameter SW = 34;
	
	// TIPO J
	parameter J = 35;
	parameter JAL = 36;

	initial begin
		estado <= RESET
	end
	
	always @(clk posedge) begin
		case (estado)
			RESET:
				IorD <= CLEAR;
			
		endcase 
	end

endmodule
