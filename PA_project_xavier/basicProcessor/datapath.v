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
	
	initial begin
		pc <= 32'h0000_0000;
	end

	always @(posedge DP_clk) begin
		//pc <= pc + 4;
		pc <= newPc;
	end

	always @(muxPc_newPc) begin
		newPc <= muxPc_newPc;
	end
	
	/** Register file **/
	regFile regFile(
		.clk(DP_clk),
		.wrd(UC_RF_wrd),
		.addrA(IC_instr[19:15]),
		.addrB(RF_addrB),
		.addrD(IC_instr[24:20]),
		.d(RF_d),
		.a(RF_a),
		.b(RF_b)
	);
	
//	assign RF_d = UC_muxD ? DC_dataRead : ALU_w;
	
	mux2to1 muxD(
		.in0(ALU_w),
		.in1(DC_dataRead),
		.sel(UC_muxD),
		.out(RF_d)
	);

	//assign newPc = muxPc_newPc;

	mux2to1 muxBr(
		.in0(pc+4),
		.in1(pc+{{17{IC_instr[24]}}, IC_instr[24:20], IC_instr[9:0]}),
		.sel(ALU_z),
		.out(Br_Pc)
	);

	mux4to1 muxPc(
		.in0(pc+4),
		.in1(Br_Pc),
		.in2(ALU_w),
		.in3(32'h0000_0000),
		.sel(UC_muxPc),
		.out(muxPc_newPc)
	);

	/** ALU **/
	alu alu(
		.op(IC_instr[31:25]),
		.x(RF_a),
		.y(ALU_y),
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
		.WE(UC_DC_we),
		.rd_wr(UC_DC_rdWr),
		.addrData(ALU_w),
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
		.in1({{17{IC_instr[14]}},IC_instr[14:0]}),
		.in2({{12{IC_instr[24]}},IC_instr[24:20],IC_instr[14:0]}),
		.in3(32'h0000_0000),
		.sel(UC_muxB),
		.out(ALU_y)
	);

	mux2to1 muxAddrB(
		.in0(IC_instr[14:10]),
		.in1(IC_instr[24:20]),
		.sel(UC_muxAddrB),
		.out(RF_addrB)
	);

	/** Control unit **/
	UC uc(
		.clk(DP_clk),
		.instr(IC_instr),
		.iCacheMiss(IC_cacheMiss),
		.dCacheMiss(DC_cacheMiss),
		.MuxB(UC_muxB),
		.MuxAddrB(UC_muxAddrB),
		.MuxD(UC_muxD),
		.MuxPc(UC_muxPc),
		.RF_wrd(UC_RF_wrd),
		.DC_rd_wr(UC_DC_rdWr),
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
