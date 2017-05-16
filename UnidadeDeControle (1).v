module UnidadeDeControle ( clk, reset, opcode, funct, ET, GT, LT, Zero /**/ PCCtrl, PCWrite, PCWriteCond, IorD, MemD, MemToReg, Write, IRWrite, ALUflag, ShiftSrc, ShiftN, set, RegDst, MemDReg, RegWrite, MultCtrl, DivCtrl, AluSrcA, AluSrcB, ALUop, EPCWrite, HICtrl, LOCtrl, PCSource);

	input clk;
	input reset;
	input [5:0] opcode;
	input [5:0] funct;
	input ET;
	input GT;
	input LT;
	input Zero;
	input MultOut;
	input DivOut;
	input divZero;

	output reg [5:0] estadoSaida;

	reg [5:0] estado;

	output reg PCCtrl,;
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
	output reg [3:0] MemtoReg;
	output reg RegWrite;
	output reg MultCtrl;
	output reg DivCtrl;
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
	parameter FUNCT_MULT   = 6'18;
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


	initial begin
		estado <= RESET;
	end

	always @(clk posedge) begin
		case (estado)
			//lendo da memoria a instrucao no endereco de PC
			RESET: begin
				//pegando o endereco de PC e lendo da memoria com esse endereco
				IorD     <= 3'b001;
				Write    <= 1'b0;

				estado   <= BUSCA
			end

			BUSCA: begin
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
			end

			DECODIFICAO: begin
				//calculo de um possivel branch
				AluSrcA  <= 2'b0;
				AluSrcB  <= 3'b011;
				ALUop    <= 3'b001;

				case(opcode)

					OPCODE_R: begin
						case(funct)
							FUNCT_ADD: begin
								estado  <= ADD;
							end

							FUNCT_AND: begin
								estado  <= ADD;
							end


							FUNCT_DIV: begin
								estado <= DIV;
							end


							FUNCT_MULT: begin
								estado <= MULT;
							end

							FUNCT_JR: begin
								estado	 <= JR;
							end

							FUNCT_MFHI: begin
								estado   <= MFHI;
							end

							FUNCT_MFLO: begin
								estado   <= MFLO;
							end

							FUNCT_SLL: begin
								estado 	  <= SLL;
							end

							FUNCT_SLV: begin
								estado 	  <= SLV;
							end

							FUNCT_SLT: begin
								estado <= SLT;
							end

							FUNCT_SRA: begin
								estado 	  <= SRA;
							end

							FUNCT_SRAV: begin
								estado 	  <= SRAV;
							end

							FUNCT_SRL: begin
								estado 	  <= SRL;
							end

							FUNCT_SUB: begin
								estado  <= SUB;
							end

							FUNCT_BREAK: begin
								estado <= BREAK;
							end

							FUNCT_RTE: begin
								estado <= RTE;
							end

							default: begin
								state <= OPCODE_INEXISTENTE;
							end

						endcase
					end

					OPCODE_ADDI: begin
						estado <= ADDI;
					end

					OPCODE_ADDIU: begin
						estado <= ADDIU;
					end

					OPCODE_BEQ: begin
						estado <= BEQ;
					end

					OPCODE_BNE: begin
						estado <= BNE;
					end

					OPCODE_BLE: begin
						estado <= BLE;
					end

					OPCODE_BGT: begin
						estado <= BGT;
					end

					OPCODE_BEQM: begin
						estado <= BEQM;
					end

					OPCODE_LB: begin
						estado <= LB;
					end

					OPCODE_LH: begin
						estado <= LH;
					end

					OPCODE_LUI: begin
						estado <= LUI;
					end

					OPCODE_LW: begin
						estado <= LW;
					end

					OPCODE_SB: begin
						estado <= SB;
					end

					OPCODE_SH: begin
						estado <= SH;
					end

					OPCODE_SLTI: begin
						estado <= SLTI;
					end

					OPCODE_SW: begin
						estado <= SW;
					end

					OPCODE_J: begin
						estado <= J;
					end

					OPCODE_JAL: begin
						estado <= JAL;
					end

				endcase

			//EXECUCOES TIPO R


			ADD: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b001;

				estado  <= END_ADD;
			end

			AND: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b011;

				estado  <= END_ADD;
			end

			//incompleto
			DIV: begin
				DivCtrl <= 1'b1;

				if(divZero) begin
					DivCtrl <= 1'b0;
					estado  <= DIV_0;
				end

				if(DivOut) begin
				end

				state <= RESET;
			end

			//incompleto
			MULT: begin
				MultCtrl <= 1'b1;

				if(MultOut) begin
					MultCtrl <= 1'b0;
					estado <= RESET;
				end

			end

			JR: begin
				AluSrcA  <= 2'b10;
				AluSrcB  <= 3'b100;
				ALUop    <= 3'b001;
				PCSource <= 2'b00;
				PCCtrl	 <= 1'b0;
				PCWrite  <= 1'b1;

				estado	 <= RESET;
			end

			MFHI: begin
				RegDst   <= 3'b001;
				MemToReg <= 4'b0100;
				RegWrite <= 1'b1;

				estado   <= RESET;
			end

			MFLO: begin
				RegDst   <= 3'b001;
				MemToReg <= 4'b0101;
				RegWrite <= 1'b1;

				estado   <= RESET;
			end

			//shitfs incompletos, verificar se precisa de waits
			SLL: begin
				ShiftN    <= 2'b01;
				ShiftSrc  <= 2'b00;
				Set       <= 3'b010;

				estado 	  <= SHIFT_END;
			end

			SLV: begin
				ShiftN    <= 2'b00;
				ShiftSrc  <= 2'b01;
				Set       <= 3'b010;

				estado 	  <= SHIFT_END;
			end

			SLT: begin
				AluSrcA <= 2'b01;
				ALuSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= END_SLT;
			end

			SRA: begin
				ShiftN    <= 2'b01;
				ShiftSrc  <= 2'b00;
				Set       <= 3'b100;

				estado 	  <= SHIFT_END;
			end

			SRAV: begin
				ShiftN    <= 2'b00;
				ShiftSrc  <= 2'b01;
				Set       <= 3'b100;

				estado 	  <= SHIFT_END;
			end

			SRL: begin
				ShiftN    <= 2'b01;
				ShiftSrc  <= 2'b00;
				Set       <= 3'b011;

				estado 	  <= SHIFT_END;
			end

			SUB: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b010;

				estado  <= END_ADD;
			end

			BREAK: begin
				AluSrcA  <= 2'b00;
				AluSrcB  <= 3'b001;
				ALUop    <= 3'b010;
				PCSource <= 2'b00;
				PCCtrl   <= 1'b0;
				PCWrite  <= 1'b1;

				estado <= RESET;
			end

			RTE: begin
				PCSource <= 2'b11;
				PCCtrl   <= 1'b0;
				PCWrite  <= 1'b1;

				estado <= RESET;
			end

			//segunda parte do add/sub/and
			END_ADD: begin
				RegDst   <= 3'b001;
				MemToReg <= 4'b0110;
				RegWrite <= 1'b1;

				estado <= RESET;
			end

			END_SLT: begin
				RegDst   <= 3'b001;
				MemToReg <= 4'b0111;
				RegWrite <= 1'b1;

				estado <= RESET;

			end

			SHIFT_END: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0011;
				RegWrite <= 1'b1;

				estado <= RESET;
			end


			//EXECUCAO TIPO I

			ADDI: begin
				AluSrcA <= 2'b01;
				ALuSrcB <= 3'b010;
				ALUop   <= 3'b001;

				estado <= ADDI_END;
			end

			ADDI_END: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0110;
				RegWrite <= 1'b1;

				estado <= RESET;
			end

			ADDIU: begin
				AluSrcA <= 2'b10;
				ALuSrcB <= 3'b010;
				ALUop   <= 3'b111;

				estado <= ADDIU_END;
			end

			ADDIU_END: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0111;
				RegWrite <= 1'b1;

				estado <= RESET;
			end

			BEQ: begin
				AluSrcA <= 2'b01;
				ALuSrcB <= 3'b000;
				ALUop   <= 3'b010;

				estado <= BRANCH_CONFIRMATION_EQ;
			end

			BNE: begin
				AluSrcA <= 2'b01;
				ALuSrcB <= 3'b000;
				ALUop   <= 3'b010;

				estado <= BRANCH_CONFIRMATION_NEQ;
			end

			BLE: begin
				AluSrcA <= 2'b01;
				ALuSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= BRANCH_CONFIRMATION_LE;
			end

			BGT: begin
				AluSrcA <= 2'b01;
				ALuSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= BRANCH_CONFIRMATION_GT;
			end

			BEQM: begin
				IorD  <= 3'b000;
				Write <= 1'b0;

				estado <= BEQM_2;
			end

			BEQM_2: begin
				AluSrcA <= 2'b01;
				ALuSrcB <= 3'b000;
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

			BRANCH_CONFIRMATION_NEQ begin
				if(Zero == 1'b0)begin
					estado <= BRANCH_END_NEQ;
				end else begin
					estado <= RESET;
				end
			end

			BRANCH_CONFIRMATION_LE begin
				if(GT == 1'b0)begin
					estado <= BRANCH_END_LE;
				end else begin
					estado <= RESET;
				end
			end

			BRANCH_CONFIRMATION_GT begin
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

			BRANCH_END_NEQ begin
				PCSource 	<= 2'b01;
				PCCtrl   	<= 1'b0;
				ALUflag  	<= 2'b11;
				PCWriteCond <= 1'b1;

				estado <= RESET;
			end

			BRANCH_END_LE begin
				PCSource 	<= 2'b01;
				PCCtrl   	<= 1'b0;
				ALUflag  	<= 2'b00;
				PCWriteCond <= 1'b1;

				estado <= RESET;
			end

			BRANCH_END_GT begin
				PCSource 	<= 2'b01;
				PCCtrl   	<= 1'b0;
				ALUflag  	<= 2'b01;
				PCWriteCond <= 1'b1;

				estado <= RESET;
			end


			LW: begin
				AluSrcA <= 2'b10;
				ALuSrcB <= 3'b010;
				ALUop	<= 3'b001;

				estado <= LW_MID;
			end

			LH: begin
				AluSrcA <= 2'b10;
				ALuSrcB <= 3'b010;
				ALUop	<= 3'b001;

				estado <= LH_MID;
			end

			LB: begin
				AluSrcA <= 2'b10;
				ALuSrcB <= 3'b010;
				ALUop	<= 3'b001;

				estado <= LB_MID;
			end

			LW_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;

				estado <= LW_END;
			end

			LH_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;

				estado <= LH_END;
			end

			LB_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;

				estado <= LB_END;
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


			LUI: begin
				ShiftN	 <= 2'b10;
				ShiftSrc <= 2'b10;
				Set		 <= 3'b010;

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
				ALuSrcB <= 3'b011;
 				ALUop   <= 3'b001;

				estado <= SW_END;
			end

			SH: begin
				AluSrcA <= 2'b10;
				ALuSrcB <= 3'b011;
 				ALUop   <= 3'b001;

				estado <= SH_MID;
			end

			SB: begin
				AluSrcA <= 2'b10;
				ALuSrcB <= 3'b011;
 				ALUop   <= 3'b001;

				estado <= SB_MID;
			end

			SW_END: begin
				IorD  <= 3'b010;
				MemD  <= 2'b00;
				Write <= 1'b1;

				estado <= RESET;
			end

			SH_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b1;

				estado <= SH_END;
			end

			SB_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b1;

				estado <= SB_END;
			end

			SH_END: begin
				IorD  <= 3'b010;
				MemD  <= 2'b10;
				Write <= 1'b1;

				estado <= RESET;
			end

			SB_END: begin
				IorD  <= 3'b010;
				MemD  <= 2'b01;
				Write <= 1'b1;

				estado <= RESET;
			end



			SLTI: begin
				AluSrcA <= 2'b10;
				ALuSrcB <= 3'b010;
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
				PCWrite  <= 1'b1
				AluSrcA  <= 2'b00;
				ALuSrcB  <= 3'b100;
				ALUop    <= 3'b001;

				estado JAL_END;
			end

			JAL_END: begin
				RegDst   <= 3'b010;
				MemToReg <= 4'b0110;

				estado   <= RESET;
			end

			end
					default: begin
						state <= OPCODE_INEXISTENTE;
					end
				endcase





		endcase
	end

endmodule
