LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;

ENTITY regfile IS 
	PORT (	clk		: IN	STD_LOGIC;
				wrd		: IN	STD_LOGIC;
				d 			: IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_a	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);

				a			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				b			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;

ARCHITECTURE Structure OF regfile IS

	TYPE Banc_reg IS array (7 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Reg : Banc_reg;	

BEGIN

	a <= Reg(CONV_INTEGER(addr_a));
	b <= Reg(CONV_INTEGER(addr_b));
	
	PROCESS (clk, wrd) BEGIN
		if rising_edge(clk) and wrd = '1' then
			Reg(CONV_INTEGER(addr_d)) <= d;
		end if;
	END PROCESS;

	-- Aqui iria la definicion del comportamiento del banco de registros
	-- Os puede ser util usar la funcion "conv_integer" o "to_integer"
	-- Una buena (y limpia) implementacion no deberia ocupar m�s de 7 o 8 lineas

END Structure;