LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY proc IS 
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
END proc;

ARCHITECTURE Structure OF proc IS

	COMPONENT unidad_control IS 
		PORT (	boot			: IN	STD_LOGIC;
					clk			: IN	STD_LOGIC;
					datard_m		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
					z				: IN STD_LOGIC;
					pc_Ra			: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);

					op				: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
					f				: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
					wrd			: OUT	STD_LOGIC;
					addr_a		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
					addr_b		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
					addr_d		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
					addr_io		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
					immed			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
					pc				: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
					ins_dad 		: OUT STD_LOGIC;
					in_d 			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
					immed_x2 	: OUT STD_LOGIC;
					wr_m 			: OUT STD_LOGIC;
					word_byte	: OUT STD_LOGIC;
					rd_in			: OUT STD_LOGIC;
					wr_out		: OUT STD_LOGIC;
					Rb_N			: OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT datapath IS 
		PORT (	clk		: IN	STD_LOGIC;
					op			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
					f			: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
					wrd		: IN	STD_LOGIC;
					addr_a	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
					addr_b	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
					addr_d	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
					immed		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
					immed_x2 : IN	STD_LOGIC;
					datard_m : IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
					ins_dad 	: IN 	STD_LOGIC;
					pc 		: IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
					in_d 		: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
					Rb_N		: IN	STD_LOGIC;
					rd_io		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);

					addr_m 	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
					data_wr 	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
					wr_io 	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
					z			: OUT STD_LOGIC;
					pc_Ra		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

	SIGNAL bus_wrd 		: STD_LOGIC;
	SIGNAL bus_immed_x2	: STD_LOGIC;
	SIGNAL bus_Rb_N		: STD_LOGIC;
	SIGNAL bus_z			: STD_LOGIC;
	SIGNAL bus_ins_dad	: STD_LOGIC;
	SIGNAL bus_immed 		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_pc			: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_pc_Ra		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_op 			: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL bus_addr_a 	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL bus_addr_b 	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL bus_addr_d 	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL bus_f 			: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL bus_in_d		: STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

	c0 : unidad_control
	Port Map (	boot			=> boot,
					clk			=> clk,
					datard_m		=> datard_m,
					op				=> bus_op,
					f				=> bus_f,
					wrd			=> bus_wrd,
					addr_a		=> bus_addr_a,
					addr_b		=> bus_addr_b,
					addr_d		=> bus_addr_d,
					addr_io		=> addr_io,
					immed			=> bus_immed,
					pc				=> bus_pc,
					ins_dad 		=> bus_ins_dad,
					in_d 			=> bus_in_d,
					immed_x2 	=> bus_immed_x2,
					wr_m 			=> wr_m,
					word_byte	=> word_byte,
					Rb_N			=> bus_Rb_N,
					z				=> bus_z,
					wr_out		=> wr_out,
					rd_in			=> rd_in,
					pc_Ra			=> bus_pc_Ra);

	e0 : datapath
	Port Map (	clk		=> clk,
					op			=> bus_op,
					f			=> bus_f,
					wrd		=> bus_wrd,
					addr_a	=> bus_addr_a,
					addr_b	=> bus_addr_b,
					addr_d	=> bus_addr_d,
					immed		=> bus_immed,
					immed_x2 => bus_immed_x2,
					datard_m => datard_m,
					ins_dad 	=> bus_ins_dad,
					pc 		=> bus_pc,
					in_d 		=> bus_in_d,
					addr_m 	=> addr_m,
					data_wr 	=> data_wr,
					Rb_N		=>	bus_Rb_N,
					z 			=> bus_z,
					wr_io		=> wr_io,
					rd_io		=> rd_io,
					pc_Ra		=> bus_pc_Ra);

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0

END Structure;