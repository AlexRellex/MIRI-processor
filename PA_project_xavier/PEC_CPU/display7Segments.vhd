LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY display7Segments IS
	PORT( codiCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			permis		 : IN STD_LOGIC;
			bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END display7Segments;

ARCHITECTURE Structure OF display7Segments IS
BEGIN
	with codiCaracter&permis select
		bitsCaracter <= 	"1000000" when "00001",
								"1111001" when "00011",
								"0100100" when "00101",
								"0110000" when "00111",
								"0011001" when "01001",
								"0010010" when "01011",
								"0000010" when "01101",
								"1111000" when "01111",
								"0000000" when "10001",
								"0010000" when "10011",
								"0001000" when "10101",
								"0000011" when "10111",
								"1000110" when "11001",
								"0100001" when "11011",
								"0000110" when "11101",
								"0001110" when "11111",
								"1111111" when others;
END Structure;