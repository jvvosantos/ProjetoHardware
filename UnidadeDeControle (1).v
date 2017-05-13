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
	parameter BRANCH_CALC = 37;
	parameter WAIT = 3;
	
	//ESTADOS	
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
	
	//ESTADOS
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
	
	//ESTADOS
	// TIPO J
	parameter J = 35;
	parameter JAL = 36;

	
	
	// OPCODES DAS INSTRUCOES
	parameter OPCODE_R = 6'h0;
	parameter OPCODE_ADDI = 6'h8;
	parameter OPCODE_ADDIU = 6'h9;
	parameter OPCODE_BEQ = 6'h4;
	parameter OPCODE_RTE = 6'h10;
	parameter OPCODE_BNE = 6'h5;
	parameter OPCODE_BLE = 6'h6;
	parameter OPCODE_BGT = 6'h7;
	parameter OPCODE_BEQM = 6'h1;
	parameter OPCODE_LB = 6'h20;
	parameter OPCODE_LH = 6'h21;
	parameter OPCODE_LUI = 6'hf;
	parameter OPCODE_LW = 6'h23;
	parameter OPCODE_SB = 6'h28;
	parameter OPCODE_SH = 6'h29;
	parameter OPCODE_SLTI = 6'ha;
	parameter OPCODE_SW = 6'h2b;
	parameter OPCODE_J = 6'h2;
	parameter OPCODE_JAL = 6'h3;

	//FUNCT DAS INSTRUCOES TIPO R
	parameter FUNCT_ADD    = 6'h20;
	parameter FUNCT_AND    = 6'h24;
	parameter FUNCT_DIV	   = 6'h1a;
	parameter FUNCT_MULT   = 6'h;
	parameter FUNCT_JR     = 6'h;
	parameter FUNCT_MFHI   = 6'h;
	parameter FUNCT_MFLO   = 6'h;
	parameter FUNCT_SLL    = 6'h;
	parameter FUNCT_SLV    = 6'h;
	parameter FUNCT_SLT    = 6'h;
	parameter FUNCT_SRA    = 6'h;
	parameter FUNCT_SRAV   = 6'h;
	parameter FUNCT_SRL    = 6'h;
	parameter FUNCT_SUB    = 6'h;
	parameter FUNCT_BREAK  = 6'h; 
	parameter FUNCT_RTE    = 6'h;
	
	//EXCESSOES
	parameter OPCODE_INEXISTENTE = 50;
	
	
	initial begin
		estado <= RESET
	end
	
	always @(clk posedge) begin
		case (estado)
			//lendo da memoria a instrucao no endereco de PC
			RESET:
				//pegando o endereco de PC e lendo da memoria com esse endereco
				IorD     <= 3'b001;
				Write    <= 1'b0;
				
				estado   <= BUSCA
				
			
			BUSCA:
				//escrevendo a instrucao no IRWrite
				//incrementando o PC e atualizando seu valor
				IRWrite  <= 1'b0;
				AluSrcA  <= 2'b0;
				AluSrcB  <= 3'b001;
				ALUop    <= 3'b001;
				PCSource <= 2'b0;
				PCCtrl   <= 1'b0;
				PCWrite  <= 1'b0;
				
				estado   <= DECODIFICAO;

			DECODIFICAO:
				//calculo de um possivel branch
				AluSrcA  <= 2'b0;
				AluSrcB  <= 3'b011;
				ALUop    <= 3'b001;
				
				case(opcode) 
					OPCODE_R:
						case(funct)
							
						endcase
					
					OPCODE_ADDI:
						estado <= ADDI;
					
					OPCODE_ADDIU:
						estado <= ADDIU;
					
					OPCODE_BEQ:
						estado <= BEQ;
					
					OPCODE_BNE:
						estado <= BNE;
					
					OPCODE_BLE:
						estado <= BLE;
					
					OPCODE_BGT:
						estado <= BGT;
					
					OPCODE_BEQM:
						estado <= BEQM;
					
					OPCODE_LB: 
						estado <= LB;
					
					OPCODE_LH:
						estado <= LH;
					
					OPCODE_LUI:
						estado <= LUI;
					
					OPCODE_LW:
						estado <= LW;
					
					OPCODE_SB:
						estado <= SB;
					
					OPCODE_SH:
						estado <= SH;
					
					OPCODE_SLTI:
						estado <= SLTI;
					
					OPCODE_SW:
						estado <= SW;
					
					OPCODE_J:
						estado <= J;
					
					OPCODE_JAL:
						estado <= JAL;
					
					default: begin
						state <= OPCODE_INEXISTENTE;
					end
				endcase
				
				
				
				
				
		endcase 
	end

endmodule
