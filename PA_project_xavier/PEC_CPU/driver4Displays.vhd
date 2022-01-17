LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY driver4Displays IS
	PORT( codiCaracter : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			permis : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			dis0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			dis1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			dis2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			dis3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END driver4Displays;

ARCHITECTURE Structure OF driver4Displays IS

	COMPONENT display7Segments IS
	PORT( codiCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			permis : IN STD_LOGIC;
			bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;

	SIGNAL bus_display0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL bus_display1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL bus_display2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL bus_display3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN
	Visor0 : display7Segments
	Port Map( 	codiCaracter => bus_display0,
					permis		=> permis(0),
					bitsCaracter => dis0);

	Visor1 : display7Segments
	Port Map( 	codiCaracter => bus_display1,
					permis		=> permis(1),
					bitsCaracter => dis1);
					
	Visor2 : display7Segments
	Port Map( 	codiCaracter => bus_display2,
					permis		=> permis(2),
					bitsCaracter => dis2);
					
	Visor3 : display7Segments
	Port Map( 	codiCaracter => bus_display3,
					permis		=> permis(3),
					bitsCaracter => dis3);
					
	bus_display0 <= codiCaracter(3 DOWNTO 0);
	bus_display1 <= codiCaracter(7 DOWNTO 4);
	bus_display2 <= codiCaracter(11 DOWNTO 8);
	bus_display3 <= codiCaracter(15 DOWNTO 12);
END Structure;