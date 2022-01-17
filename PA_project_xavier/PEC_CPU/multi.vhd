LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY multi IS
	PORT (	clk			: IN	STD_LOGIC;
				boot			: IN	STD_LOGIC;
				ldpc_1		: IN	STD_LOGIC;	
				wrd_1 		: IN	STD_LOGIC;	
				wr_m_1		: IN	STD_LOGIC;
				w_b			: IN	STD_LOGIC;

				ldpc 			: OUT	STD_LOGIC;	
				wrd 			: OUT	STD_LOGIC;	
				wr_m 			: OUT	STD_LOGIC;
				ldir 			: OUT	STD_LOGIC;
				ins_dad		: OUT	STD_LOGIC;
				word_byte	: OUT	STD_LOGIC);
END ENTITY;

ARCHITECTURE Structure OF multi IS
	SIGNAL bus_ins_dad : STD_LOGIC;
	-- Aqui iria la declaracion de las los estados de la maquina de estados
BEGIN
	PROCESS (clk, boot) BEGIN
		if rising_edge(clk) THEN
			if boot = '1' THEN
				bus_ins_dad <= '0';
			else bus_ins_dad <= not bus_ins_dad;
			end if;
		end if;
	END PROCESS;

	ins_dad <= bus_ins_dad;

	ldpc <= '0' WHEN bus_ins_dad = '0'
				ELSE ldpc_1;
	wrd <= '0' WHEN bus_ins_dad = '0'
				ELSE wrd_1;
	wr_m <= '0' WHEN bus_ins_dad = '0'
				ELSE wr_m_1;					-- glitch (en el ModelSim)
	ldir <= not bus_ins_dad;
	word_byte <= '0' WHEN bus_ins_dad = '0'
					ELSE w_b;

	-- Aqui iria la m�quina de estados del modelos de Moore que gestiona el multiciclo
	-- Aqui irian la generacion de las senales de control que su valor depende del ciclo en que se esta.

END Structure;
