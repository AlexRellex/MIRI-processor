LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY MemoryController IS 
	PORT (CLOCK_50    : IN  STD_LOGIC;
			addr       	: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_data     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			we          : IN  STD_LOGIC;
			byte_m      : IN  STD_LOGIC;
			boot			: IN	STD_LOGIC;

			SRAM_DQ 		: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);

			SRAM_UB_N 	: OUT STD_LOGIC;
			SRAM_LB_N 	: OUT STD_LOGIC;
			SRAM_CE_N 	: OUT STD_LOGIC := '1';
			SRAM_OE_N 	: OUT STD_LOGIC := '1';
			SRAM_WE_N 	: OUT STD_LOGIC := '1';
			SRAM_ADDR 	: OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
			rd_data     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END MemoryController;

ARCHITECTURE comportament OF MemoryController IS

	COMPONENT SRAMController IS 
		PORT (clk			: IN  STD_LOGIC;  
				SRAM_ADDR 	: OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
				SRAM_DQ 		: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				SRAM_UB_N 	: OUT STD_LOGIC;
				SRAM_LB_N 	: OUT STD_LOGIC;
				SRAM_CE_N 	: OUT STD_LOGIC := '1';
				SRAM_OE_N 	: OUT STD_LOGIC := '1';
				SRAM_WE_N 	: OUT STD_LOGIC := '1';

				address		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
				dataReaded	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				dataToWrite	: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				WR				: IN  STD_LOGIC := '0';
				byte_m		: IN  STD_LOGIC := '0');
	END COMPONENT;

	SIGNAL bus_WR 			: STD_LOGIC;
	SIGNAL bus_SRAM_CE_N : STD_LOGIC;
	SIGNAL bus_SRAM_WE_N : STD_LOGIC;

BEGIN

	sram : SRAMController
	Port Map(clk			=> CLOCK_50,
				SRAM_ADDR 	=> SRAM_ADDR,
				SRAM_DQ 		=> SRAM_DQ,
				SRAM_UB_N 	=> SRAM_UB_N,
				SRAM_LB_N 	=> SRAM_LB_N,
				SRAM_CE_N 	=> bus_SRAM_CE_N,
				SRAM_OE_N 	=> SRAM_OE_N,
				SRAM_WE_N 	=> bus_SRAM_WE_N,
				
				address		=> addr,
				dataReaded	=> rd_data,
				dataToWrite	=> wr_data,
				WR				=> bus_WR,
				byte_m		=> byte_m);

	bus_WR <=	we WHEN addr < x"C000" ELSE
					'0';
	SRAM_CE_N <=	'1' WHEN boot = '1' ELSE
						bus_SRAM_CE_N;

	SRAM_WE_N <=	'1' WHEN boot = '1' ELSE
						bus_SRAM_WE_N;

END comportament;
