module UnidadeDeControle ( clk, reset, opcode, funct, ET, GT, LT, Zero, MultOut, divZero, divOut, /**/ PCCtrl, PCWrite, PCWriteCond, IorD, MemD, Write, IRWrite, ALUflag, ShiftSrc, ShiftN, set, RegDst, MemToReg, RegWrite, MultCtrl, DIVCtrl, AluSrcA, AluSrcB, ALUop, EPCWrite, HICtrl, LOCtrl, PCSource);

	input clk;
	input reset;
	input [5:0] opcode;
	input [5:0] funct;
	input ET;
	input GT;
	input LT;
	input Zero;
	input MultOut;
	input divZero;
	input divOut;

//	output reg [5:0] estadoSaida;

	reg [7:0] estado;
	reg [1:0] counter;
	reg [7:0] tempestado;
	output reg PCCtrl;
	output reg PCWrite;
	output reg PCWriteCond;
	output reg [2:0] IorD;
	output reg [1:0] MemD;

	output reg Write;
	output reg IRWrite;
	output reg [1:0] ALUflag;
	output reg [1:0] ShiftSrc;
	output reg [1:0] ShiftN;
	output reg set;
	output reg [2:0] RegDst;
	output reg [3:0] MemToReg;
	output reg RegWrite;
	output reg MultCtrl;
	output reg DIVCtrl;
	output reg [1:0] AluSrcA;
	output reg [2:0] AluSrcB;
	output reg [2:0] ALUop;
	output reg EPCWrite;
	output reg HICtrl;
	output reg LOCtrl;
	output reg [1:0] PCSource;
	
	

	// DEFINICAO DOS ESTADOS
	parameter RESET = 0;
	parameter BUSCA = 1;
	parameter DECODIFICACAO = 2;
	parameter BRANCH_CALC = 37;

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
	parameter END_ADD = 50;
	parameter DIV_0 = 51;
	parameter SHIFT_END = 52;
	parameter END_SLT = 53;

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
	parameter  ADDI_END = 70;
	parameter  ADDIU_END = 71;
	parameter  BRANCH_CONFIRMATION_EQ = 72;
	parameter  BRANCH_CONFIRMATION_LE = 73;
	parameter  BRANCH_CONFIRMATION_GT = 74;
	parameter  BRANCH_CONFIRMATION_NEQ = 113;
	parameter  BEQM_2 = 74;
	parameter  BRANCH_END_EQ = 75;
	parameter  BRANCH_END_NEQ = 76;
	parameter  BRANCH_END_LE = 77;
	parameter  BRANCH_END_GT = 78;
	parameter  LW_MID = 79;
	parameter  LH_MID = 80;
	parameter  LB_MID = 81;
	parameter  LW_END = 82;
	parameter  LH_END = 83;
	parameter  LB_END = 84;
	parameter  LUI_END = 85;
	parameter  SW_END = 86;
	parameter  SH_MID = 87;
	parameter  SB_MID = 88;
	parameter  SH_END = 89;
	parameter  SB_END = 90;
	parameter  SLTI_END = 91;


	//ESTADOS
	// TIPO J
	parameter J = 35;
	parameter JAL = 36;
	parameter  JAL_END = 92;



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
	parameter FUNCT_MULT   = 6'h18;
	parameter FUNCT_JR     = 6'h8;
	parameter FUNCT_MFHI   = 6'h10;
	parameter FUNCT_MFLO   = 6'h12;
	parameter FUNCT_SLL    = 6'h0;
	parameter FUNCT_SLV    = 6'h4;
	parameter FUNCT_SLT    = 6'h2A;
	parameter FUNCT_SRA    = 6'h3;
	parameter FUNCT_SRAV   = 6'h7;
	parameter FUNCT_SRL    = 6'h2;
	parameter FUNCT_SUB    = 6'h22;
	parameter FUNCT_BREAK  = 6'hxd;
	parameter FUNCT_RTE    = 6'h13;

	//EXCESSOES
	parameter OPCODE_INEXISTENTE = 50;
	//parameter OVERFLOW = 
	
	//WAITS
	parameter WAIT = 95;
	
	
	initial begin
		estado <= RESET;
		counter <= 2'b0;
	end

	always@(posedge clk) begin
		case (estado)
			
			95:
				begin
					counter <= counter + 1;
					if(counter == 2'b11) begin
						estado <= tempestado;
						counter <= 2'b00;
					end
				end
				
			
			//lendo da memoria a instrucao no endereco de PC
			5'b00000 /*RESET*/: begin
				//pegando o endereco de PC e lendo da memoria com esse endereco
				IorD     <= 3'b001;
				Write    <= 1'b0;

				estado   <= BUSCA;
			end

			5'b00001 /*BUSCA*/: begin
				//escrevendo a instrucao no IRWrite
				//incrementando o PC e atualizando seu valor
				IRWrite  <= 1'b1;
				AluSrcA  <= 2'b0;
				AluSrcB  <= 3'b001;
				ALUop    <= 3'b001;
				PCSource <= 2'b0;
				PCCtrl   <= 1'b0;
				PCWrite  <= 1'b0;

				estado   <= DECODIFICACAO;
			end

			5'b00010 /*DECODIFICACAO*/: begin
				//calculo de um possivel branch
				AluSrcA  <= 2'b0;
				AluSrcB  <= 3'b011;
				ALUop    <= 3'b001;

				//decodificando
				case(opcode)

					6'h0/* opcode_r */: begin
						case(funct)
							6'h20/* funct_ add */: begin
								estado  <= ADD;
							end

							6'h24/* funct_and */: begin
								estado  <= ADD;
							end


							6'h1a/* funct_div */: begin
								estado <= DIV;
							end


							6'h18/* funct_mult */: begin
								estado <= MULT;
							end

							6'h8/* funct_jr */: begin
								estado	 <= JR;
							end

							6'h10/* funct_mfhi */: begin
								estado   <= MFHI;
							end

							6'h12/* funct_mflo */: begin
								estado   <= MFLO;
							end

							6'h0/* funct_sll */: begin
								estado 	  <= SLL;
							end

							6'h4/* funct_slv */: begin
								estado 	  <= SLV;
							end

							6'h2a/* funct_slt */: begin
								estado <= SLT;
							end

							6'h3/* funct_sra */: begin
								estado 	  <= SRA;
							end

							6'h7/* funct_srav */: begin
								estado 	  <= SRAV;
							end

							6'h2/* funct_srl */: begin
								estado 	  <= SRL;
							end

							6'h22/* funct_sub */: begin
								estado  <= SUB;
							end

							6'hxd/* funct_break */: begin
								estado <= BREAK;
							end

							6'h13/* funct_rte */: begin
								estado <= RTE;
							end

							default: begin
								estado <= END_ADD;
							end

						endcase
					end

					6'h8/* opcode_addi */: begin
						estado <= ADDI;
					end

					6'h9/* opcode_addiu */: begin
						estado <= ADDIU;
					end

					6'h4/* opcode_beq */: begin
						estado <= BEQ;
					end

					6'h5/* opcode_bne */: begin
						estado <= BNE;
					end

					6'h6/* opcode_ble */: begin
						estado <= BLE;
					end

					6'h7/* opcode_bgt */: begin
						estado <= BGT;
					end

					6'h1/* opcode_beqm */: begin
						estado <= BEQM;
					end

					6'h20/* opcode_lb */: begin
						estado <= LB;
					end

					6'h21/* opcode_lh */: begin
						estado <= LH;
					end

					6'hf/* opcode_lui */: begin
						estado <= LUI;
					end

					6'h23/* opcode_lw */: begin
						estado <= LW;
					end

					6'h28/* opcode_sb */: begin
						estado <= SB;
					end

					6'h29/* opcode_sh */: begin
						estado <= SH;
					end

					6'ha/* opcode_slti */: begin
						estado <= SLTI;
					end

					6'h2b/* opcode_sw */: begin
						estado <= SW;
					end

					6'h2/* opcode_j */: begin
						estado <= J;
					end

					6'h3/* opcode_jal */: begin
						estado <= JAL;
					end

				endcase

			//EXECUCOES TIPO R
			end

			4/* add */: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b001;

				estado  <= 50/* end_add */;
			end

			5 /*and*/: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b011;

				estado  <= 50/* end_add */;
			end

			//incompleto
			6 /* div */: begin
				DIVCtrl <= 1'b1;

				if(divZero) begin
					DIVCtrl <= 1'b0;
					estado  <= 51/* div_0 */;
				end 
				if(divOut)begin
					estado <= RESET;
				end
			end

			//incompleto
			7 /* mult */: begin
				MultCtrl <= 1'b1;

				if(MultOut) begin

					MultCtrl <= 1'b0;
					estado <= RESET;
				end

			end

			8/* jr */: begin
				AluSrcA  <= 2'b10;
				AluSrcB  <= 3'b100;
				ALUop    <= 3'b001;
				PCSource <= 2'b00;
				PCCtrl	 <= 1'b0;
				PCWrite  <= 1'b1;

				estado	 <= RESET;
			end

			9/* mfhi */: begin
				RegDst   <= 3'b001;
				MemToReg <= 4'b0100;
				RegWrite <= 1'b1;

				estado   <= RESET;
			end

			10/* mflo */: begin
				RegDst   <= 3'b001;
				MemToReg <= 4'b0101;
				RegWrite <= 1'b1;

				estado   <= RESET;
			end

			//shitfs incompletos, verificar se precisa de waits
			11/* sll */: begin
				ShiftN    <= 2'b01;
				ShiftSrc  <= 2'b00;
				set       <= 3'b010;

				estado 	  <= 52/* shift_end */;
			end

			12/* slv */: begin
				ShiftN    <= 2'b00;
				ShiftSrc  <= 2'b01;
				set       <= 3'b010;

				estado 	  <= 52/* shift_end */;
			end

			13/* slt */: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= END_SLT;
			end

			14/* sra */: begin
				ShiftN    <= 2'b01;
				ShiftSrc  <= 2'b00;
				set       <= 3'b100;

				estado 	  <= 52/* shift_end */;
			end

			15/* srav */: begin
				ShiftN    <= 2'b00;
				ShiftSrc  <= 2'b01;
				set       <= 3'b100;

				estado 	  <= 52/* shift_end */;
			end

			16/* srl */: begin
				ShiftN    <= 2'b01;
				ShiftSrc  <= 2'b00;
				set       <= 3'b011;

				estado 	  <= SHIFT_END;
			end

			17/* sub */: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b010;

				estado  <= 50/* end_add */;
			end

			18/* break */: begin
				AluSrcA  <= 2'b00;
				AluSrcB  <= 3'b001;
				ALUop    <= 3'b010;
				PCSource <= 2'b00;
				PCCtrl   <= 1'b0;
				PCWrite  <= 1'b1;

				estado <= RESET;
			end

			19/* rte */: begin
				PCSource <= 2'b11;
				PCCtrl   <= 1'b0;
				PCWrite  <= 1'b1;

				estado <= RESET;
			end

			//segunda parte do add/sub/and
			50/* end_add */: begin
				RegDst   <= 3'b001;
				MemToReg <= 4'b0110;
				RegWrite <= 1'b1;

				estado <= RESET;
			end

			53/* end_slt */: begin
				RegDst   <= 3'b001;
				MemToReg <= 4'b0111;
				RegWrite <= 1'b1;

				estado <= RESET;

			end

			52/* shift_end */: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0011;
				RegWrite <= 1'b1;

				estado <= RESET;
			end


			//EXECUCAO TIPO I

			20/* addi */: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b010;
				ALUop   <= 3'b001;

				estado <= ADDI_END;
			end

			70/* addi_end */: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0110;
				RegWrite <= 1'b1;

				estado <= RESET;
			end

			21/* addiu */: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b010;
				ALUop   <= 3'b111;

				estado <= ADDIU_END;
			end

			71 /* addiu_end */: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0111;
				RegWrite <= 1'b1;

				estado <= RESET;
			end

			22/* beq */: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b010;

				estado <= BRANCH_CONFIRMATION_EQ;
			end

			23/* bne */: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b010;

				estado <= BRANCH_CONFIRMATION_NEQ;
			end

			24/* ble */: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= BRANCH_CONFIRMATION_LE;
			end

			25/* bgt */: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= BRANCH_CONFIRMATION_GT;
			end

			26/* beqm */: begin
				IorD  <= 3'b000;
				Write <= 1'b0;

				tempestado <= BEQM_2;
				estado <= WAIT;
			end

			BEQM_2: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b010;

				estado <= BRANCH_CONFIRMATION_EQ;
			end

			BRANCH_CONFIRMATION_EQ: begin
				if(Zero)begin
					estado <= BRANCH_END_EQ;
				end else begin
					estado <= RESET;
				end
			end

			BRANCH_CONFIRMATION_NEQ: begin
				if(Zero == 1'b0)begin
					estado <= BRANCH_END_NEQ;
				end else begin
					estado <= RESET;
				end
			end

			BRANCH_CONFIRMATION_LE: begin
				if(GT == 1'b0)begin
					estado <= BRANCH_END_LE;
				end else begin
					estado <= RESET;
				end
			end

			BRANCH_CONFIRMATION_GT: begin
				if(GT == 1'b1)begin
					estado <= BRANCH_END_GT;
				end else begin
					estado <= RESET;
				end
			end

			BRANCH_END_EQ: begin
				PCSource 	<= 2'b01;
				PCCtrl   	<= 1'b0;
				ALUflag  	<= 2'b10;
				PCWriteCond <= 1'b1;

				estado <= RESET;
			end

			BRANCH_END_NEQ: begin
				PCSource 	<= 2'b01;
				PCCtrl   	<= 1'b0;
				ALUflag  	<= 2'b11;
				PCWriteCond <= 1'b1;

				estado <= RESET;
			end

			BRANCH_END_LE: begin
				PCSource 	<= 2'b01;
				PCCtrl   	<= 1'b0;
				ALUflag  	<= 2'b00;
				PCWriteCond <= 1'b1;

				estado <= RESET;
			end

			BRANCH_END_GT: begin
				PCSource 	<= 2'b01;
				PCCtrl   	<= 1'b0;
				ALUflag  	<= 2'b01;
				PCWriteCond <= 1'b1;

				estado <= RESET;
			end


			LW: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b010;
				ALUop	<= 3'b001;

				estado <= LW_MID;
			end

			LH: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b010;
				ALUop	<= 3'b001;

				estado <= LH_MID;
			end

			27/* lb */: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b010;
				ALUop	<= 3'b001;

				estado <= LB_MID;
			end

			LW_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;
				
				tempestado <= LW_END;
				estado <= WAIT;
			end

			LH_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;

				tempestado <= LH_END;
				estado <= WAIT;
			end

			LB_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;

				tempestado <= LB_END;
				estado <= WAIT;
			end

			LW_END: begin
				RegDst	  <= 3'b000;
				MemToReg  <= 4'b0010;
				RegWrite  <= 1'b1;

				estado <= RESET;
			end

			LH_END: begin
				RegDst	  <= 3'b000;
				MemToReg  <= 4'b0000;
				RegWrite  <= 1'b1;

				estado <= RESET;
			end

			LB_END: begin
				RegDst	  <= 3'b000;
				MemToReg  <= 4'b0001;
				RegWrite  <= 1'b1;

				estado <= RESET;
			end


			29/* lui */: begin
				ShiftN	 <= 2'b10;
				ShiftSrc <= 2'b10;
				set		 <= 3'b010;

				estado 	 <= LUI_END;
			end

			LUI_END: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0001;
				RegWrite <= 1'b1;

				estado   <= RESET;
			end

			//ADICIONAR WAITS NOS STORES E NO RESTO TBM
			SW: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b011;
 				ALUop   <= 3'b001;

				estado <= SW_END;
			end

			SH: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b011;
 				ALUop   <= 3'b001;

				estado <= SH_MID;
			end

			SB: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b011;
 				ALUop   <= 3'b001;

				estado <= SB_MID;
			end

			SW_END: begin
				IorD  <= 3'b010;
				MemD  <= 2'b00;
				Write <= 1'b1;

				tempestado <= RESET;
				estado <= WAIT;
			end

			SH_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b1;

				tempestado <= SH_END;
				estado <= WAIT;
				
			end

			SB_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b1;

				tempestado <= SB_END;
				estado <= WAIT;
			end

			SH_END: begin
				IorD  <= 3'b010;
				MemD  <= 2'b10;
				Write <= 1'b1;

				tempestado <= RESET;
				estado <= WAIT;
			end

			SB_END: begin
				IorD  <= 3'b010;
				MemD  <= 2'b01;
				Write <= 1'b1;

				tempestado <= RESET;
				estado <= WAIT;
			end



			33/* slti */: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b010;
				ALUop   <= 3'b111;

				estado <= SLTI_END;
			end

			SLTI_END: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0111;
				RegWrite <= 1'b1;

				estado <= RESET;
			end


			//EXECUCAO TIPO J

			J: begin
				PCSource <= 2'b10;
				PCCtrl   <= 1'b0;
				PCWrite  <= 1'b1;

				estado   <= RESET;
			end

			JAL: begin
				PCSource <= 2'b10;
				PCCtrl 	 <= 1'b0;
				PCWrite  <= 1'b1;
				AluSrcA  <= 2'b00;
				AluSrcB  <= 3'b100;
				ALUop    <= 3'b001;

				estado <= JAL_END;
			end

			JAL_END: begin
				RegDst   <= 3'b010;
				MemToReg <= 4'b0110;

				estado   <= RESET;
			end

			

			endcase
			end
		endmodule


//fim do always
/*
	end
endmodule*/
