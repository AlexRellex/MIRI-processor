LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY rellotge IS
	GENERIC (mida : NATURAL := 25;
				valor_inicial : NATURAL := 25000000);
	PORT( CLOCK : IN std_logic;
			CLK_OUT : BUFFER std_logic := '0');
END rellotge;

ARCHITECTURE Structure OF rellotge IS

SIGNAL comptador : STD_LOGIC_VECTOR(mida-1 DOWNTO 0):= STD_LOGIC_VECTOR(to_unsigned(valor_inicial, mida));

BEGIN

	PROCESS (CLOCK)
	BEGIN
		if (rising_edge(CLOCK)) then
			comptador <= comptador - 1;
			if (comptador = "0") then
				CLK_OUT <= not CLK_OUT;
				comptador <= STD_LOGIC_VECTOR(to_unsigned(valor_inicial, mida));
			end if;
		end if;
	END PROCESS;

END Structure;