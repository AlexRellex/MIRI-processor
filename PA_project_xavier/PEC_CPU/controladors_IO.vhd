LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY controladors_IO IS
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
END controladors_IO;

ARCHITECTURE Structure OF controladors_IO IS
	TYPE Ports_IO is array (255 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	--TYPE Ports_IO is array (15 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL ports : Ports_IO := (others => (others => '0'));

	SIGNAL bus_ledg		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_ledr		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_p_visors	: STD_LOGIC_VECTOR(15 DOWNTO 0);

	BEGIN

	rd_io 	<= ports(CONV_INTEGER(addr_io));
	bus_ledg	<=	ports(5);
	bus_ledr	<= ports(6);
	bus_p_visors <= ports(9);

	PROCESS (CLOCK_50, wr_out, boot) BEGIN
		if rising_edge(CLOCK_50) then
			ports(7) <= x"000"&pulsadores;
			ports(8) <= x"00"&interruptores;
			if boot = '1' then
				ports <= (others => (others => '0'));
			elsif wr_out = '1' then
				if (CONV_INTEGER(addr_io) /= 7) and (CONV_INTEGER(addr_io) /= 8) then
					ports(CONV_INTEGER(addr_io)) <= wr_io;
				end if;
			end if;
		end if;
	END PROCESS;

	led_verdes	<= bus_ledg(7 DOWNTO 0);
	led_rojos	<= bus_ledr(7 DOWNTO 0);
	visors_p 	<= bus_p_visors(3 DOWNTO 0);
	visors		<= ports(10);

END Structure;