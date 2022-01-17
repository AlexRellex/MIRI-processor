LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;

ENTITY datapath IS 
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
END datapath;

ARCHITECTURE Structure OF datapath IS

	COMPONENT regfile IS 
	PORT (	clk		: IN	STD_LOGIC;
				wrd		: IN	STD_LOGIC;
				d 			: IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_a	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
				
				a			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				b			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	COMPONENT alu IS 
	PORT (	x 	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				y 	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				op	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
				f	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);

				w	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				z	: OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL bus_a	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_b	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL w_d 		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_wr	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_y	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_z	: STD_LOGIC;

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

BEGIN

	alu0 : alu
	Port Map(x 	=> bus_a,
				y 	=> bus_y,
				op => op,
				f	=> f,
				w 	=> w_d,
				z	=> bus_z);

	reg0 : regfile
	Port Map(clk 		=> clk,
				wrd 		=> wrd,
				d 			=> bus_wr,
				addr_a 	=> addr_a,
				addr_b	=> addr_b,
				addr_d	=> addr_d,

				a			=> bus_a,
				b			=> bus_b);

	bus_wr <=	datard_m	WHEN in_d = "01" ELSE
					pc	+ 2	WHEN in_d = "10" ELSE
					rd_io		WHEN in_d = "11" ELSE
					w_d;

	bus_y <=	bus_b WHEN Rb_N = '0' ELSE
				immed WHEN immed_x2 = '0' ELSE
				immed(14 DOWNTO 0)&'0';

	addr_m <= pc WHEN ins_dad = '0' ELSE w_d;

	data_wr	<= bus_b;
	wr_io		<=	bus_b;
	z 			<= bus_z;
	pc_Ra		<= bus_a;

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del banco de registros le hemos llamado reg0 y a la de la alu le hemos llamado alu0

END Structure;