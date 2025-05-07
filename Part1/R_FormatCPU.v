/*
 *	Template for Project 2 Part 1
 *	Copyright (C) 2025  Xi-Zhu Wang or any person belong ESSLab.
 *	All Right Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *	This file is for people who have taken the cource (1132 Computer
 *	Organizarion) to use.
 *	We (ESSLab) are not responsible for any illegal use.
 *
 */

/*
 * Declaration of top entry for this project.
 * CAUTION: DONT MODIFY THE NAME AND I/O DECLARATION.
 */
module R_FormatCPU(
	// Outputs
	output	wire	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);
    wire [31:0] Instruction, RsData, RtData, ALU_result, MemReadData;
    wire [1:0] Funct, ALU_op;

	/* 
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	IM Instr_Memory(
        .InstrAddr(Input_Addr),
        .Instr(Instruction)
	);

	/* 
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	RF Register_File(
        .RsData(RsData),
        .RtData(RtData),
        .RsAddr(Instruction[25:21]),
        .RtAddr(Instruction[20:16]),
        .RdAddr(Reg_dst ? Instruction[15:11] : Instruction[20:16]),
        .RdData(Mem_to_reg ? MemReadData : ALU_result),
        .RegWrite(Reg_w),
        .clk(clk)
	);

	/* 
	 * Declaration of Data Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	DM Data_Memory(
        .MemReadData(MemReadData),
        .MemAddr(ALU_result),
        .MemWriteData(RtData),
        .MemWrite(Mem_w),
        .MemRead(1'b1),
        .clk(clk)
	);
    
    wire [31:0] imm_extend = {16'b0, Instruction[15:0]};

    ALU alu(
        .Src_1(RsData),
        .Src_2(ALU_src ? imm_extend : RtData),
        .Shamt(Instruction[10:6]),
        .Funct(Funct),
        .ALU_result(ALU_result),
        .Zero(Zero)
    );

    ALU_Control aluControl(
        .Funct_ctrl(Instruction[5:0]),
        .ALU_op(ALU_op),
        .Funct(Funct)
    );

    Control control(
        .OpCode(Instruction[31:26]),
        .Reg_dst(Reg_dst), 
        .Branch(Branch), 
        .Reg_w(Reg_w), 
        .ALU_src(ALU_src), 
        .Mem_w(Mem_w), 
        .Mem_to_reg(Mem_to_reg), 
        .Jump(Jump),
        .ALU_op(ALU_op)
    );

    wire [31:0] NextPC = Input_Addr + 4;

    assign Output_Addr = 
        Jump ? {NextPC[31:28], Instruction[25:0], 2'b00} :
        (Branch & Zero) ? NextPC + {imm_extend[29:0], 2'b00} : 
        NextPC;

endmodule
