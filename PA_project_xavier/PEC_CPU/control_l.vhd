LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY control_l IS 
	PORT (	ir				: IN	STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
			
				op				: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
				f				: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				ldpc			: OUT	STD_LOGIC;
				wrd			: OUT	STD_LOGIC;
				addr_a		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_io		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				immed			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				wr_m			: OUT STD_LOGIC;
				in_d			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				immed_x2		: OUT STD_LOGIC;
				word_byte	: OUT STD_LOGIC;
				rd_in			: OUT STD_LOGIC;
				wr_out		: OUT STD_LOGIC;
				Rb_N			: OUT STD_LOGIC);
END control_l;

ARCHITECTURE Structure OF control_l IS

SIGNAL bus_op : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	op 						<= ir(15 DOWNTO 12);
	bus_op 					<= ir(15 DOWNTO 12);
	f 							<=	ir(5 DOWNTO 3) WHEN bus_op = "0000" or bus_op = "0001" or bus_op = "1000" ELSE
									ir(2 DOWNTO 0) WHEN bus_op = "1010" ELSE
									"00"&ir(8);
	ldpc						<= '0' WHEN ir = x"ffff"
									ELSE '1';
	wrd						<= '0' WHEN bus_op = "0100" or bus_op = "1110" or ir = x"ffff" or bus_op = "0110" or (bus_op = "1010" and ir(2 DOWNTO 0) /= "100") or (bus_op = "0111" and ir(8) = '1')
									ELSE '1';
	addr_a					<= ir(11 DOWNTO 9) WHEN bus_op = "0101"
									ELSE ir(8 DOWNTO 6);
	addr_b					<= ir(2 DOWNTO 0) WHEN bus_op = "0000" or bus_op = "0001" or bus_op = "1000" ELSE
									ir(11 DOWNTO 9);
	addr_d					<= ir(11 DOWNTO 9);
	immed(15 DOWNTO 8)	<= (others => ir(7)) WHEN bus_op = "0101" or bus_op = "0110"
									ELSE (others => ir(5));
	immed(7 DOWNTO 6)		<= ir(7 DOWNTO 6) WHEN bus_op = "0101" or bus_op = "0110"
									ELSE (others => ir(5));
	immed(5 DOWNTO 0)		<= ir(5 DOWNTO 0);
	wr_m 						<= '1' WHEN bus_op = "0100" or bus_op = "1110"
									ELSE '0';
	in_d 						<=	"01"	WHEN bus_op = "0011" or bus_op = "1101" ELSE
									"10"	WHEN bus_op = "1010" and ir(2 DOWNTO 0) = "100" ELSE
									"11"	WHEN bus_op = "0111" and ir(8) = '0' ELSE
									"00";
	immed_x2					<=	'1' WHEN bus_op = "0011" or bus_op = "0100"
									ELSE '0';
	word_byte				<=	'1' WHEN bus_op = "1101" or bus_op = "1110"
									ELSE '0';
	Rb_N						<=	'1' WHEN bus_op = "0010" or bus_op = "0011" or bus_op = "0100" or bus_op = "0101" or bus_op = "1101" or bus_op = "1110"
									ELSE '0';
	addr_io					<=	ir(7 DOWNTO 0);
	rd_in						<= '1' WHEN bus_op = "0111" and ir(8) = '0' ELSE
									'0';
	wr_out					<=	'1' WHEN bus_op = "0111" and ir(8) = '1' ELSE
									'0';
	-- Aqui iria la generacion de las senales de control del datapath

END Structure;