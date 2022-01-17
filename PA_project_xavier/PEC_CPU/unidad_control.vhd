LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;

ENTITY unidad_control IS 
	PORT (	boot			: IN	STD_LOGIC;
				clk			: IN	STD_LOGIC;
				z				: IN	STD_LOGIC;
				datard_m		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				pc_Ra			: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				
				wrd			: OUT	STD_LOGIC;
				ins_dad 		: OUT STD_LOGIC;
				immed_x2 	: OUT STD_LOGIC;
				wr_m 			: OUT STD_LOGIC;
				word_byte	: OUT STD_LOGIC;
				rd_in			: OUT STD_LOGIC;
				wr_out		: OUT STD_LOGIC;
				Rb_N			: OUT STD_LOGIC;
				immed			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				pc				: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_io		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				op				: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
				addr_a		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d		: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
				f				: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				in_d 			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	COMPONENT control_l IS 
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
	END COMPONENT;

	COMPONENT multi IS
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
	END COMPONENT;

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	-- Aqui iria la definicion del program counter

	SIGNAL ctrl_halt 	: STD_LOGIC := '1';
	SIGNAL new_pc 		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_ldpc	: STD_LOGIC;
	SIGNAL bus_w_b		: STD_LOGIC;
	SIGNAL bus_wr_m	: STD_LOGIC;
	SIGNAL bus_wrd		: STD_LOGIC;
	SIGNAL bus_ldir	: STD_LOGIC;
	SIGNAL bus_f		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL bus_ir		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL bus_op		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL bus_immed	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL tknbr		: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL bus_op_f	: STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

	c0 : control_l
	Port Map( 	ir 			=> bus_ir,
					op 			=> bus_op,
					f				=> bus_f,
					ldpc 			=> bus_ldpc,
					wrd 			=> bus_wrd,
					addr_a 		=> addr_a,
					addr_b		=> addr_b,
					addr_d 		=> addr_d,
					addr_io		=> addr_io,
					immed 		=> bus_immed,
					wr_m			=> bus_wr_m,
					in_d			=> in_d,
					immed_x2		=> immed_x2,
					word_byte	=> bus_w_b,
					rd_in			=> rd_in,
					wr_out		=> wr_out,
					Rb_N			=> Rb_N);

	m0 : multi
	Port Map(	clk			=> clk,
					boot			=> boot,
					ldpc_1		=> bus_ldpc,	
					wrd_1 		=> bus_wrd,	
					wr_m_1		=> bus_wr_m,
					w_b			=> bus_w_b,
					ldpc			=> ctrl_halt,	
					wrd			=> wrd,	
					wr_m			=> wr_m,
					ldir			=> bus_ldir,
					ins_dad		=> ins_dad,
					word_byte	=> word_byte);

	PROCESS (clk, boot) BEGIN
		if rising_edge(clk) then
			if (boot = '1') then
				new_pc <= x"C000";
				bus_ir <= (others => '0');
			elsif (ctrl_halt = '1') then
				case tknbr is
						when "00" =>	new_pc <= new_pc + 2;
						when "10" =>	new_pc <= pc_Ra;
						when "01" =>	new_pc <= (new_pc + 2 + (bus_immed(14 DOWNTO 0)&'0'));
						when others =>	new_pc <= new_pc;
				end case;
			end if;
			if (bus_ldir = '1' and boot = '0') then
				bus_ir <= datard_m;
			end if;
		end if;
	END PROCESS;
	pc <= new_pc;
	op <= bus_op;
	immed <= bus_immed;
	f <= bus_f;
	bus_op_f <= bus_op&bus_f;

	tknbr <= "10"	WHEN	((bus_op_f = "1010000" and z = '1') or (bus_op_f = "1010001" and z = '0') or (bus_op_f = "1010011") or (bus_op_f = "1010100"))	ELSE
				"01"	WHEN	((bus_op_f = "0110000" and z = '1') or (bus_op_f = "0110001" and z = '0'))	ELSE
				"00";

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
	-- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

END Structure;