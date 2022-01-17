LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY SRAMController IS 
	PORT (clk			: IN  std_logic;  
			address		: IN  std_logic_vector(15 downto 0) := "0000000000000000";
			dataToWrite	: IN  std_logic_vector(15 downto 0);
			WR				: IN  std_logic;
			byte_m		: IN  std_logic := '0';
			
			SRAM_DQ 		: INOUT std_logic_vector(15 downto 0);
			
			SRAM_ADDR 	: OUT std_logic_vector(19 downto 0);
			dataReaded	: OUT std_logic_vector(15 downto 0);
			SRAM_UB_N 	: OUT std_logic;
			SRAM_LB_N 	: OUT std_logic;
			SRAM_CE_N 	: OUT std_logic := '1';
			SRAM_OE_N 	: OUT std_logic := '1';
			SRAM_WE_N 	: OUT std_logic := '1');
END SRAMController;

ARCHITECTURE comportament OF SRAMController IS

TYPE tipus_estat IS (LECTURA, ESC1, ESC2);

SIGNAL estat 			: tipus_estat;
SIGNAL data_written	: STD_LOGIC := '1';

BEGIN
   PROCESS (clk) BEGIN
		if (rising_edge(clk)) then
			if (estat = LECTURA) then
				if (WR = '0') then 
					estat <= LECTURA;
					data_written <= '0';
				elsif (WR = '1' and data_written = '0') then
					estat <= ESC1;
				else
					estat <= LECTURA;
				end if;
			elsif (estat = ESC1) then
				estat <= ESC2;
			elsif (estat = ESC2) then
				data_written <= '1';
				estat <= LECTURA;
			end if;
		end if;
	END PROCESS;

	SRAM_ADDR <= "00000"&address(15 DOWNTO 1);
	SRAM_WE_N <= '0' WHEN estat = ESC1 ELSE
						'1';
	SRAM_UB_N <= '1' WHEN byte_m = '1' and address(0) = '0' ELSE
						'0';
	SRAM_LB_N <= '1' WHEN byte_m = '1' and address(0) = '1' ELSE
						'0';
	SRAM_CE_N <= '0';--, '0' after 70 ns;
	SRAM_OE_N <= '0';
	dataReaded(7 DOWNTO 0) <= SRAM_DQ(15 DOWNTO 8) WHEN estat = LECTURA and byte_m = '1' and address(0) = '1' ELSE
										SRAM_DQ(7 DOWNTO 0);
	dataReaded(15 DOWNTO 8) <= (others => SRAM_DQ(7)) WHEN estat = LECTURA and byte_m = '1' and address(0) = '0' ELSE
										(others => SRAM_DQ(15)) WHEN estat = LECTURA and byte_m = '1' and address(0) = '1' ELSE
										SRAM_DQ(15 DOWNTO 8);
	SRAM_DQ(7 DOWNTO 0) <= dataToWrite(7 DOWNTO 0) WHEN (estat = ESC1 or estat = ESC2) and address(0) = '0' ELSE
									(others => 'Z');
	SRAM_DQ(15 DOWNTO 8) <= dataToWrite(7 DOWNTO 0) WHEN (estat = ESC1 or estat = ESC2) and byte_m = '1' and address(0) = '1' ELSE
									dataToWrite(15 DOWNTO 8) WHEN (estat = ESC1 or estat = ESC2) and byte_m = '0'ELSE
									(others => 'Z');
END comportament;