`ifndef _datapath
`define _datapath

module datapath
#(parameter ADDR_WIDTH=32, parameter DATA_WIDTH=32, parameter MEM_BUS_WIDTH=128)

(input DP_clk);

	/** Fetch **/
	reg [(ADDR_WIDTH-1):0] pc;
	reg [(ADDR_WIDTH-1):0] newPc;
	wire [(ADDR_WIDTH-1):0] Br_Pc;
	wire [(ADDR_WIDTH-1):0] muxPc_newPc;

	/** Register file **/
//	wire RF_clk;
//	wire RF_wrd;
//	wire RF_addrA;
//	wire RF_addrD;
   wire [4:0] RF_addrB;
	wire [(DATA_WIDTH-1):0] RF_a;
	wire [(DATA_WIDTH-1):0] RF_b;	
	wire [(DATA_WIDTH-1):0] RF_d;
	
	/** ALU **/
//	wire ALU_op;
//	wire ALU_x;
	wire [(DATA_WIDTH-1):0] ALU_y;
	wire [(DATA_WIDTH-1):0] ALU_w;
	wire ALU_z;

	/** Data cache **/
//	wire DC_clk;
//	wire DC_we;
//	wire DC_rdWr;
//	wire DC_addrData;
	wire [(DATA_WIDTH-1):0] DC_dataToWrite;
	wire [(DATA_WIDTH-1):0] DC_dataRead;
	wire [(MEM_BUS_WIDTH-1):0] DC_dataMemWrite;
	wire [(MEM_BUS_WIDTH-1):0] DC_dataMemRead;
	wire DC_cacheMiss;
	
	/** Instruction cache **/
// wire IC_clk;
// wire IC_addrInst;
//	wire IC_we;
	wire [(ADDR_WIDTH-1):0] IC_instr;
	wire [(MEM_BUS_WIDTH-1):0] IC_dataMemRead;
	wire IC_cacheMiss;
	
	/** Control unit **/
//	wire UC_clk;
//	wire UC_instr;
	wire [1:0] UC_muxB;
	wire UC_muxAddrB;
	wire UC_muxD;
	wire [1:0] UC_muxPc;
	wire UC_RF_wrd;
	wire [1:0] UC_DC_rdWr;
	wire UC_DC_we;
	wire UC_IC_we;
	wire UC_Nop;
	
	wire MuxB_out;

	wire [(DATA_WIDTH-1):0] FD_instr;
	wire [(ADDR_WIDTH-1):0] FD_Pc;
	wire FFD_kill;
	wire FDD_kill;
	
	wire [(DATA_WIDTH-1):0] DA_dataA;
	wire [(DATA_WIDTH-1):0] DA_dataB;
	wire [(ADDR_WIDTH-1):0] DA_Pc;
	wire [(DATA_WIDTH-1):0] DA_BranchOffset;
	wire [6:0] DA_opcode;
	wire [4:0] DA_regDst;
	wire [1:0] DA_DC_rd_wr;
	wire DA_MuxD;
	wire DDA_kill;
	wire DAA_kill;
	wire DAA_DC_we;
	wire DAA_RF_wrd;
	wire AAC_DC_we;
	wire AAC_RF_wrd;
	
	wire [(DATA_WIDTH-1):0] AC_w;
	wire [4:0] AC_regDst;
	wire [1:0] AC_DC_rd_wr;
	wire AC_MuxD;
	wire AC_RF_wrd;
	
	wire [(DATA_WIDTH-1):0] CW_dataD;
	wire [(DATA_WIDTH-1):0] CW_w;
	wire [4:0] CW_regDst;
	wire CW_MuxD;
	wire CW_RF_wrd;
	
	initial begin
		pc <= 32'h0000_0000;
	end

	always @(posedge DP_clk) begin
		pc <= newPc;
	end

	always @(muxPc_newPc) begin
		newPc <= muxPc_newPc;
	end
	
		/** Register file **/
	FD_decoupler FD_dec(
		.clk(DP_clk),

		.F_instr(IC_instr),
		.F_Pc(pc),
		.F_kill(FFD_kill),

		.D_instr(FD_instr),
		.D_Pc(FD_Pc),
		.D_kill(FDD_kill)
	);
	
	DA_decoupler DA_dec(
		.clk(DP_clk),

		/** Inputs **/
		.D_dataA(RF_a),
		.D_dataB(MuxB_out),
		.D_opcode(FD_instr[31:25]),
		.D_regDst(FD_instr[24:20]),
		.D_DC_rd_wr(UC_DC_rdWr),
		.D_DC_we(UC_DC_we),
		.D_MuxD(UC_muxD),
		.D_PC(FD_Pc),
		.D_BranchOffset({{17{FD_instr[24]}}, FD_instr[24:20], FD_instr[9:0]}),
		.D_RF_wrd(UC_RF_wrd),
		.D_kill(DDA_kill),

		/** Outputs **/
		.A_dataA(DA_dataA),
		.A_dataB(DA_dataB),
		.A_opcode(DA_opcode),
		.A_regDst(DA_regDst),
		.A_DC_rd_wr(DA_DC_rd_wr),
		.A_DC_we(DAA_DC_we),
		.A_MuxD(DA_MuxD),
		.A_PC(DA_Pc),
		.A_BranchOffset(DA_BranchOffset),
		.A_RF_wrd(DAA_RF_wrd),
		.A_kill(DAA_kill)
	);
	
	AC_decoupler AC_dec(
		.clk(DP_clk),
		
		/** Inputs **/
		.A_w(ALU_w),
		.A_regDst(DA_regDst),
		.A_DC_rd_wr(DA_DC_rd_wr),
		.A_DC_we(AAC_DC_we),
		.A_MuxD(DA_MuxD),
		.A_RF_wrd(AAC_RF_wrd),
		
		/** Outputs **/
		.C_w(AC_w),
		.C_regDst(AC_regDst),
		.C_DC_rd_wr(AC_DC_rd_wr),
		.C_DC_we(AC_DC_we),
		.C_MuxD(AC_MuxD),
		.C_RF_wrd(AC_RF_wrd)
	);
	
	CW_decoupler CW_dec(
		.clk(DP_clk),
		
		/** Inputs **/
		.C_dataD(DC_dataRead),
		.C_w(AC_w),
		.C_regDst(AC_regDst),
		.C_MuxD(AC_MuxD),
		.C_RF_wrd(AC_RF_wrd),
		
		/** Outputs **/
		.W_dataD(CW_dataD),
		.W_w(CW_w),
		.W_regDst(CW_regDst),
		.W_MuxD(CW_MuxD),
		.W_RF_wrd(CW_RF_wrd)

	);
	
	/** Register file **/
	regFile regFile(
		.clk(DP_clk),
		.wrd(CW_RF_wrd),
		.addrA(FD_instr[19:15]),
		.addrB(RF_addrB),
		.addrD(CW_regDst),
		.d(RF_d),
		.a(RF_a),
		.b(RF_b)
	);
	
//	assign RF_d = UC_muxD ? DC_dataRead : ALU_w;
	
	mux2to1 muxD(
		.in0(CW_w),
		.in1(CW_dataD),
		.sel(CW_MuxD),
		.out(RF_d)
	);

	mux4to1 muxPc(
		.in0(pc+4),
		.in1(DA_Pc+DA_BranchOffset),
		.in2(ALU_w),
		.in3(32'h0000_0000),
		.sel(UC_muxPc),
		.out(muxPc_newPc)
	);

	/** ALU **/
	alu alu(
		.op(DA_opcode),
		.x(DA_dataA),
		.y(DA_dataB),
		.w(ALU_w),
		.z(ALU_z)
	);
	
//	assign ALU_y =
//		(UC_muxB == 2'b00) ? RF_b :
//		(UC_muxB == 2'b01) ? {{8{IC_instr[14]}}, IC_instr[14:0]} :
//		(UC_muxB == 2'b10) ? {IC_instr[24:20],IC_instr[14:0]} :
//		32'h0000_0000;

	/** Data cache **/
	dCache dCache(
		.clk(DP_clk),
		.WE(AC_DC_we),
		.rd_wr(AC_DC_rd_wr),
		.addrData(AC_w),
		.data_to_write(DC_dataToWrite),
		.data_read(DC_dataRead),
		.data_mem_write(DC_dataMemWrite),
		.data_mem_read(DC_dataMemRead),
		.cache_miss(DC_cacheMiss)
	);

	assign DC_dataToWrite = RF_b;
	
	/** Instruction cache **/
	iCache iCache(
		.clk(DP_clk),
		.addrInst(pc),
		.we(UC_IC_we),
		.instr(IC_instr),
		.data_mem_read(IC_dataMemRead),
		.cache_miss(IC_cacheMiss)
	);
	
	mux4to1 muxB(
		.in0(RF_b),
		.in1({{17{FD_instr[14]}},FD_instr[14:0]}),
		.in2({{12{FD_instr[24]}},FD_instr[24:20],FD_instr[14:0]}),
		.in3(32'h0000_0000),
		.sel(UC_muxB),
		.out(MuxB_out)
	);

	mux2to1 muxAddrB(
		.in0(FD_instr[14:10]),
		.in1(FD_instr[24:20]),
		.sel(UC_muxAddrB),
		.out(RF_addrB)
	);
	
	/* Kill multiplexer of Fetch */
	mux2to1 killFetchMux(
		.in0(0),
		.in1(1),
		.sel(UC_Nop),
		.out(FFD_kill)
	);
	
	/* Kill multiplexer of Decode & Read */
	mux2to1 killDecodeMux(
		.in0(FDD_kill),
		.in1(1),
		.sel(UC_Nop),
		.out(DDA_kill)
	);
		
	/* Multiplexer for disabling DC_we if needed */
	mux2to1 disDC_we(
		.in0(DAA_DC_we),
		.in1(0),
		.sel(DAA_kill),
		.out(AAC_DC_we)
	);
	
	/* Multiplexer for disabling RF_wrd if needed */
	mux2to1 disRF_wrd(
		.in0(DAA_RF_wrd),
		.in1(0),
		.sel(DAA_kill),
		.out(AAC_RF_wrd)
	);
	
	/** Control unit **/
	UC uc(
		.clk(DP_clk),
		.instr(FD_instr),
		.z(ALU_z),
		.opcode_ALU(DA_opcode),
		.kill(DAA_kill),
		.iCacheMiss(IC_cacheMiss),
		.dCacheMiss(DC_cacheMiss),
		.MuxB(UC_muxB),
		.MuxAddrB(UC_muxAddrB),
		.MuxD(UC_muxD),
		.MuxPc(UC_muxPc),
		.RF_wrd(UC_RF_wrd),
		.DC_rd_wr(UC_DC_rdWr),
		.Nop(UC_Nop),
		.DC_we(UC_DC_we),
		.IC_we(UC_IC_we)
	);

//	/** Memory **/
//	wire MEM_clk;
//	wire MEM_rdWr;
//	wire MEM_we;
//	wire MEM_addr;
//	wire MEM_dataWr;
//	wire MEM_dataRd;
//
//	memory mem(
//		.clk(DP_clk),
//		.rd_wr(MEM_rdWr),
//		.we(MEM_we),
//		.addr(MEM_addr),
//		.data_wr(MEM_dataWr),
//		.data_rd(MEM_dataRd)
//	);	

//	wire RF_a_ALU_x;
//	assign RF_a_ALU_x = RF_a;
//	assign ALU_x = RF_a_ALU_x;

//	wire ALU_w_DC_addrData;
//	assign ALU_w_DC_addrData = ALU_w;
//	assign DC_addrData = ALU_w_DC_addrData;

//	wire IC_instr_UC_instr;
//	assign IC_instr_UC_instr = IC_instr;
//	assign UC_instr = IC_instr_UC_instr;

//	wire IC_instr_RF_addrA;
//	wire [31:0]instr;
//	assign instr = IC_instr;
//	assign IC_instr_RF_addrA = instr[19:15];
//	assign RF_addrA = IC_instr_RF_addrA;
//	
//	wire IC_addrA_RF;
//	assign IC_addrA_RF = IC_instr[19:15];
//	assign RF_addrA = IC_addrA_RF;
//	
//	wire IC_addrB_RF;
//	assign IC_addrB_RF = IC_instr[14:10];
//	assign RF_addrB = IC_addrB_RF;
//	
//	wire IC_addrD_RF;
//	assign IC_addrD_RF = IC_instr[24:20];
//	assign RF_addrD = IC_addrD_RF;
	
//	wire IC_instr_RF_addrB;
//	
//	wire IC_instr_RF_addrD;

endmodule

`endif
