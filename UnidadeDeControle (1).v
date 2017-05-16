module UnidadeDeControle ( clk, reset, opcode, funct, ET, GT, LT, Zero, /**/ PCCtrl, PCWrite, PCWriteCond, IorD, MemD, MemToReg, Write, IRWrite, ALUflag, ShiftSrc, ShiftN,
							set, RegDst, MemD, RegWrite, MultCtrl, DivCtrl, AluSrcA, AluSrcB, ALUop, EPCWrite, HICtrl, LOCtrl, PCSource, DivOut, divZero, MultOut);

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

//	output reg [5:0] estadoSaida;

	reg [5:0] estado;

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
	parameter Add = 4;
	parameter AND = 5;
	parameter Div = 6;
	parameter Mult = 7;
	parameter Jr = 8;
	parameter Mfhi = 9;
	parameter Mflo = 10;
	parameter Sll = 11;
	parameter Slv = 12;
	parameter Slt = 13;
	parameter Sra = 14;
	parameter Srav = 15;
	parameter Srl = 16;
	parameter Sub = 17;
	parameter Break = 18;
	parameter Rte = 19;
	parameter END_Add = 50;
	parameter DIV_0 = 51;
	parameter Shift_END = 52;
	parameter END_Slt = 53;

	//ESTADOS
	// TIPO I
	parameter Addi = 20;
	parameter Addiu = 21;
	parameter Beq = 22;
	parameter Bne = 23;
	parameter Ble = 24;
	parameter Bgt = 25;
	parameter Beqm = 26;
	parameter Lb = 27;
	parameter Lh = 28;
	parameter Lui = 29;
	parameter Lw = 30;
	parameter Sb = 31;
	parameter Sh = 32;
	parameter Slti = 33;
	parameter Sw = 34;
	parameter  Addi_END = 70;
	parameter  Addiu_END = 71;
	parameter  BRANCH_CONFIRMATION_eq = 72;
	parameter  BRANCH_CONFIRMATION_le = 73;
	parameter  BRANCH_CONFIRMATION_gt = 74;
	parameter  Beqm_2 = 74;
	parameter  Branch_END_EQ = 75;
	parameter  BRANCH_END_neq = 76;
	parameter  BRANCH_END_le = 77;
	parameter  BRANCH_END_gt = 78;
	parameter  Lw_MID = 79;
	parameter  Lh_MID = 80;
	parameter  Lb_MID = 81;
	parameter  Lw_END = 82;
	parameter  Lh_END = 83;
	parameter  Lb_END = 84;
	parameter  Lui_END = 85;
	parameter  Sw_END = 86;
	parameter  Sh_MID = 87;
	parameter  SB_MID = 88;
	parameter  SH_END = 89;
	parameter  SB_END = 90;
	parameter  SLTI_END = 91;


	//ESTADOS
	// TIPO J
	parameter j = 35;
	parameter Jal = 36;
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


	initial begin
		estado <= RESET;
	end

	always@(posedge clk) begin
		case (estado)
			//lendo da memoria a instrucao no endereco de PC
			RESET: begin
				//pegando o endereco de PC e lendo da memoria com esse endereco
				IorD     <= 3'b001;
				Write    <= 1'b0;

				estado   <= BUSCA;
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

				//decodificando
				case(opcode)

					OPCODE_R: begin
						case(funct)
							FUNCT_ADD: begin
								estado  <= Add;
							end

							FUNCT_AND: begin
								estado  <= Add;
							end


							FUNCT_DIV: begin
								estado <= Div;
							end


							FUNCT_MULT: begin
								estado <= Mult;
							end

							FUNCT_JR: begin
								estado	 <= Jr;
							end

							FUNCT_MFHI: begin
								estado   <= Mfhi;
							end

							FUNCT_MFLO: begin
								estado   <= Mflo;
							end

							FUNCT_SLL: begin
								estado 	  <= Sll;
							end

							FUNCT_SLV: begin
								estado 	  <= Slv;
							end

							FUNCT_SLT: begin
								estado <= Slt;
							end

							FUNCT_SRA: begin
								estado 	  <= Sra;
							end

							FUNCT_SRAV: begin
								estado 	  <= Srav;
							end

							FUNCT_SRL: begin
								estado 	  <= Srl;
							end

							FUNCT_SUB: begin
								estado  <= Sub;
							end

							FUNCT_BREAK: begin
								estado <= Break;
							end

							FUNCT_RTE: begin
								estado <= Rte;
							end

							default: begin
								estado <= OPCODE_INEXISTENTE;
							end

						endcase
					end

					OPCODE_ADDI: begin
						estado <= Addi;
					end

					OPCODE_ADDIU: begin
						estado <= Addiu;
					end

					OPCODE_BEQ: begin
						estado <= Beq;
					end

					OPCODE_BNE: begin
						estado <= Bne;
					end

					OPCODE_BLE: begin
						estado <= Ble;
					end

					OPCODE_BGT: begin
						estado <= Bgt;
					end

					OPCODE_BEQM: begin
						estado <= Beqm;
					end

					OPCODE_LB: begin
						estado <= Lb;
					end

					OPCODE_LH: begin
						estado <= Lh;
					end

					OPCODE_LUI: begin
						estado <= Lui;
					end

					OPCODE_LW: begin
						estado <= Lw;
					end

					OPCODE_SB: begin
						estado <= Sb;
					end

					OPCODE_SH: begin
						estado <= Sh;
					end

					OPCODE_SLTI: begin
						estado <= Slti;
					end

					OPCODE_SW: begin
						estado <= Sw;
					end

					OPCODE_J: begin
						estado <= j;
					end

					OPCODE_JAL: begin
						estado <= Jal;
					end

				endcase

			//EXECUCOES TIPO R


			ADD: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b001;

				estado  <= END_Add;
			end

			AND: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b011;

				estado  <= END_Add;
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

				estado <= RESET;
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
				set       <= 3'b010;

				estado 	  <= Shift_END;
			end

			SLV: begin
				ShiftN    <= 2'b00;
				ShiftSrc  <= 2'b01;
				set       <= 3'b010;

				estado 	  <= Shift_END;
			end

			SLT: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= END_Slt;
			end

			SRA: begin
				ShiftN    <= 2'b01;
				ShiftSrc  <= 2'b00;
				set       <= 3'b100;

				estado 	  <= Shift_END;
			end

			SRAV: begin
				ShiftN    <= 2'b00;
				ShiftSrc  <= 2'b01;
				set       <= 3'b100;

				estado 	  <= Shift_END;
			end

			SRL: begin
				ShiftN    <= 2'b01;
				ShiftSrc  <= 2'b00;
				set       <= 3'b011;

				estado 	  <= Shift_END;
			end

			SUB: begin
				AluSrcB <= 3'b000;
				AluSrcA <= 2'b10;
				ALUop   <= 3'b010;

				estado  <= END_Add;
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
				AluSrcB <= 3'b010;
				ALUop   <= 3'b001;

				estado <= Addi_END;
			end

			ADDI_END: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0110;
				RegWrite <= 1'b1;

				estado <= RESET;
			end

			ADDIU: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b010;
				ALUop   <= 3'b111;

				estado <= Addiu_END;
			end

			ADDIU_END: begin
				RegDst   <= 3'b000;
				MemToReg <= 4'b0111;
				RegWrite <= 1'b1;

				estado <= RESET;
			end

			BEQ: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b010;

				estado <= BRANCH_CONFIRMATION_eq;
			end

			BNE: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b010;

				estado <= Branch_CONFIRMATION_NEQ;
			end

			BLE: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= BRANCH_CONFIRMATION_le;
			end

			BGT: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b111;

				estado <= BRANCH_CONFIRMATION_gt;
			end

			BEQM: begin
				IorD  <= 3'b000;
				Write <= 1'b0;

				estado <= Beqm_2;
			end

			BEQM_2: begin
				AluSrcA <= 2'b01;
				AluSrcB <= 3'b000;
				ALUop   <= 3'b010;

				estado <= BRANCH_CONFIRMATION_eq;
			end

			BRANCH_CONFIRMATION_EQ: begin
				if(Zero)begin
					estado <= Branch_END_EQ;
				end else begin
					estado <= RESET;
				end
			end

			Branch_CONFIRMATION_NEQ: begin
				if(Zero == 1'b0)begin
					estado <= BRANCH_END_neq;
				end else begin
					estado <= RESET;
				end
			end

			BRANCH_CONFIRMATION_LE: begin
				if(GT == 1'b0)begin
					estado <= BRANCH_END_le;
				end else begin
					estado <= RESET;
				end
			end

			BRANCH_CONFIRMATION_GT: begin
				if(GT == 1'b1)begin
					estado <= BRANCH_END_gt;
				end else begin
					estado <= RESET;
				end
			end

			Branch_END_EQ: begin
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

			BRANCH_END_le: begin
				PCSource 	<= 2'b01;
				PCCtrl   	<= 1'b0;
				ALUflag  	<= 2'b00;
				PCWriteCond <= 1'b1;

				estado <= RESET;
			end

			BRANCH_END_gt: begin
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

				estado <= Lw_MID;
			end

			LH: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b010;
				ALUop	<= 3'b001;

				estado <= Lh_MID;
			end

			LB: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b010;
				ALUop	<= 3'b001;

				estado <= Lb_MID;
			end

			Lw_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;

				estado <= Lw_END;
			end

			Lh_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;

				estado <= Lh_END;
			end

			Lb_MID: begin
				IorD  <= 3'b010;
				Write <= 1'b0;

				estado <= Lb_END;
			end

			Lw_END: begin
				RegDst	  <= 3'b000;
				MemToReg  <= 4'b0010;
				RegWrite  <= 1'b1;

				estado <= RESET;
			end

			Lh_END: begin
				RegDst	  <= 3'b000;
				MemToReg  <= 4'b0000;
				RegWrite  <= 1'b1;

				estado <= RESET;
			end

			Lb_END: begin
				RegDst	  <= 3'b000;
				MemToReg  <= 4'b0001;
				RegWrite  <= 1'b1;

				estado <= RESET;
			end


			LUI: begin
				ShiftN	 <= 2'b10;
				ShiftSrc <= 2'b10;
				set		 <= 3'b010;

				estado 	 <= Lui_END;
			end

			Lui_END: begin
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

				estado <= Sw_END;
			end

			SH: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b011;
 				ALUop   <= 3'b001;

				estado <= Sh_MID;
			end

			SB: begin
				AluSrcA <= 2'b10;
				AluSrcB <= 3'b011;
 				ALUop   <= 3'b001;

				estado <= SB_MID;
			end

			Sw_END: begin
				IorD  <= 3'b010;
				MemD  <= 2'b00;
				Write <= 1'b1;

				estado <= RESET;
			end

			Sh_MID: begin
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




			end
		endcase


//fim do always

	end
endmodule
