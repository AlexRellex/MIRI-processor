LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY sisa IS
	PORT (CLOCK_50		: IN	STD_LOGIC;
			SW 			: IN  STD_LOGIC_VECTOR(9 downto 0);
			KEY 			: IN  STD_LOGIC_VECTOR(3 downto 0);

			SRAM_DQ 		: INOUT STD_LOGIC_VECTOR(15 downto 0);

			SRAM_ADDR 	: OUT STD_LOGIC_VECTOR(19 downto 0);
			SRAM_UB_N 	: OUT STD_LOGIC;
			SRAM_LB_N 	: OUT STD_LOGIC;
			SRAM_CE_N 	: OUT STD_LOGIC := '1';
			SRAM_OE_N 	: OUT STD_LOGIC := '1';
			SRAM_WE_N 	: OUT STD_LOGIC := '1';
			LEDG 			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			LEDR 			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX1			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX2			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX3			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END sisa;

ARCHITECTURE Structure OF sisa IS

	COMPONENT rellotge IS
		GENERIC (mida : NATURAL := 25;
					valor_inicial : NATURAL := 25000000);
		PORT( CLOCK : IN STD_LOGIC;
				CLK_OUT : BUFFER STD_LOGIC := '0');
	END COMPONENT;

	COMPONENT MemoryController is 
		PORT (addr       	: IN  STD_LOGIC_VECTOR(15 downto 0);
				wr_data     : IN  STD_LOGIC_VECTOR(15 downto 0);
				we          : IN  STD_LOGIC;
				byte_m      : IN  STD_LOGIC;
				boot			: IN	STD_LOGIC;
				CLOCK_50    : IN  STD_LOGIC;

				SRAM_DQ 		: INOUT STD_LOGIC_VECTOR(15 downto 0);

				SRAM_ADDR 	: OUT STD_LOGIC_VECTOR(19 downto 0);
				rd_data     : OUT STD_LOGIC_VECTOR(15 downto 0);
				SRAM_UB_N 	: OUT STD_LOGIC;
				SRAM_LB_N 	: OUT STD_LOGIC;
				SRAM_CE_N 	: OUT STD_LOGIC := '1';
				SRAM_OE_N 	: OUT STD_LOGIC := '1';
				SRAM_WE_N 	: OUT STD_LOGIC := '1');
	END COMPONENT;

	COMPONENT proc IS 
	PORT (	boot			: IN	STD_LOGIC;
				clk			: IN	STD_LOGIC;
				datard_m		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				rd_io			: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);

				addr_m		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				data_wr		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_io		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				wr_io 		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				wr_m			: OUT STD_LOGIC;
				word_byte	: OUT STD_LOGIC;
				rd_in			: OUT STD_LOGIC;
				wr_out		: OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT controladors_IO IS
	PORT (	boot 				: IN STD_LOGIC;
				CLOCK_50			: IN STD_LOGIC;
				addr_io			: IN STD_LOGIC_VECTOR(7 downto 0);
				wr_io				: IN STD_LOGIC_VECTOR(15 downto 0);
				wr_out			: IN STD_LOGIC;
				rd_in				: IN STD_LOGIC;
				interruptores	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				pulsadores		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

				rd_io				: OUT STD_LOGIC_VECTOR(15 downto 0);
				led_verdes		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				led_rojos		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				visors_p			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
				visors			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	COMPONENT driver4Displays IS
	PORT( codiCaracter	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			permis			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

			dis0				: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			dis1				: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			dis2				: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			dis3				: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;

	SIGNAL bus_clock 		: STD_LOGIC;
	SIGNAL bus_wr_out		: STD_LOGIC;
	SIGNAL bus_rd_in		: STD_LOGIC;
	SIGNAL bus_wr_we		: STD_LOGIC;
	SIGNAL bus_word_byte	: STD_LOGIC;
	SIGNAL bus_data_wr	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_addr		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_wr_io		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_rd_io		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_data_rd	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_visors		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_addr_io	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL bus_visors_p	: STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN		

	Rlltge : rellotge
	Generic Map( mida 			=> 3,
					valor_inicial	=> 7)
	Port Map(	CLOCK 			=> CLOCK_50,
					CLK_OUT 			=> bus_clock);

	ctl_io : controladors_IO
	Port Map (	boot       		=> SW(9),
					CLOCK_50    	=> CLOCK_50,
					addr_io			=> bus_addr_io,
					wr_io				=> bus_wr_io,
					wr_out			=> bus_wr_out,
					rd_in				=> bus_rd_in,
					interruptores	=> SW(7 DOWNTO 0),	
					pulsadores		=> KEY,

					rd_io				=> bus_rd_io,
					led_verdes		=> LEDG,
					led_rojos		=> LEDR,
					visors_p			=> bus_visors_p,
					visors			=> bus_visors);			

	mem0 : MemoryController
	Port Map (	addr       	=> bus_addr,
					wr_data     => bus_data_wr,
					rd_data     => bus_data_rd,
					we          => bus_wr_we,
					byte_m      => bus_word_byte,
					boot			=> SW(9),

					CLOCK_50    => CLOCK_50,

					SRAM_ADDR 	=> SRAM_ADDR,
					SRAM_DQ 		=> SRAM_DQ,
					SRAM_UB_N 	=> SRAM_UB_N,
					SRAM_LB_N 	=> SRAM_LB_N,
					SRAM_CE_N 	=> SRAM_CE_N,
					SRAM_OE_N 	=> SRAM_OE_N,
					SRAM_WE_N 	=> SRAM_WE_N);

	pro0 : proc				
	Port Map (	boot			=> SW(9),
					clk			=> bus_clock,
					datard_m		=> bus_data_rd,
					addr_io		=> bus_addr_io,
					wr_io			=> bus_wr_io,
					wr_out		=> bus_wr_out,
					rd_in			=> bus_rd_in,

					rd_io			=> bus_rd_io,
					addr_m		=> bus_addr,
					data_wr		=> bus_data_wr,
					wr_m			=> bus_wr_we,
					word_byte	=> bus_word_byte);

	dsplay : driver4Displays
	Port Map( codiCaracter	=> bus_visors,
					permis		=> bus_visors_p,
					dis0 			=> HEX0,
					dis1			=> HEX1,
					dis2			=> HEX2,
					dis3			=> HEX3);

END Structure;