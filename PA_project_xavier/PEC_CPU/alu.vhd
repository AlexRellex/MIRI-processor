LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;

ENTITY alu IS
	PORT (	x 	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				y 	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				op	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
				f	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);

				w	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				z	: OUT STD_LOGIC);
END alu;

ARCHITECTURE Structure OF alu IS

	SIGNAL bus_w		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL op_f			: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL mul_res 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL mul_res_u	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL div_res 	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL div_res_u 	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL sha_res_l 	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL sha_res_r 	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL shl_res_l 	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL shl_res_r 	: STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

	op_f <= op&f;

	mul_res		<= std_logic_vector(signed(x) * signed(y));
	mul_res_u	<= std_logic_vector(unsigned(x) * unsigned(y));
	div_res		<= std_logic_vector(signed(x) / signed(y));
	div_res_u	<= std_logic_vector(unsigned(x) / unsigned(y));

	sha_res_l <= std_logic_vector(SHIFT_LEFT(signed(x), to_integer(unsigned(y))));
	sha_res_r <= std_logic_vector(SHIFT_RIGHT(signed(x), -to_integer(signed(y))));
	shl_res_l <= std_logic_vector(SHIFT_LEFT(unsigned(x), to_integer(unsigned(y))));
	shl_res_r <= std_logic_vector(SHIFT_RIGHT(unsigned(x), -to_integer(signed(y))));

	bus_w <=	x and y		WHEN op_f = "0000000" ELSE		-- AND
				x or y		WHEN op_f = "0000001" ELSE		-- OR
				x xor y		WHEN op_f = "0000010" ELSE		-- XOR
				not x			WHEN op_f = "0000011" ELSE		-- NOT
				x + y			WHEN op_f = "0000100" ELSE		-- ADD
				x - y			WHEN op_f = "0000101" ELSE		-- SUB

				sha_res_l	WHEN op_f = "0000110" and signed(y) > 0	ELSE		-- SHA (left)
				sha_res_r	WHEN op_f = "0000110" and signed(y) < 0	ELSE		-- SHA (right)
				x				WHEN op_f = "0000110" 							ELSE		-- SHA (0)
				shl_res_l	WHEN op_f = "0000111" and signed(y) > 0	ELSE		-- SHL (left)
				shl_res_r	WHEN op_f = "0000111" and signed(y) < 0	ELSE		-- SHL (right)
				x				WHEN op_f = "0000111"							ELSE		-- SHL (0)

				x"0001"	WHEN op_f = "0001000" and signed(x) < signed(y)			ELSE	-- CMPLT (true)
				x"0000"	WHEN op_f = "0001000"											ELSE	-- CMPLT (false)
				x"0001"	WHEN op_f = "0001001" and signed(x) <= signed(y)		ELSE	-- CMPLE (true)
				x"0000"	WHEN op_f = "0001001"											ELSE	-- CMPLE (false)
				x"0001"	WHEN op_f = "0001011" and x = y								ELSE	-- CMPEQ (true)
				x"0000"	WHEN op_f = "0001011"											ELSE	-- CMPEQ (false)
				x"0001"	WHEN op_f = "0001100" and unsigned(x) < unsigned(y)	ELSE	-- CMPLTU (true)
				x"0000"	WHEN op_f = "0001100"											ELSE	-- CMPLTU (false)
				x"0001"	WHEN op_f = "0001101" and unsigned(x) <= unsigned(y)	ELSE	-- CMPLEU (true)
				x"0000"	WHEN op_f = "0001101"											ELSE	-- CMPLEU (false)

				x + y 	WHEN op = "0010"	ELSE	-- ADDI

				mul_res(15 DOWNTO 0)		WHEN op_f = "1000000" ELSE		-- MUL
				mul_res(31 DOWNTO 16)	WHEN op_f = "1000001" ELSE		-- MULH
				mul_res_u(31 DOWNTO 16)	WHEN op_f = "1000010" ELSE		-- MULHU
				div_res 						WHEN op_f = "1000100" ELSE		-- DIV
				div_res_u					WHEN op_f = "1000101" ELSE		-- DIVU

				y 	WHEN op = "0110" ELSE	-- BZ, BNZ

				y	WHEN op = "1010" ELSE	-- JZ, JNZ, JMP, JAL

				y 										WHEN op_f = "0101000" ELSE -- MOVI
				y(7 DOWNTO 0)&x(7 DOWNTO 0)	WHEN op_f = "0101001" ELSE	-- MOVHI
				x+y;																		-- LD, ST, LDB, STB

	w <= bus_w;
	z <= '1' WHEN bus_w = x"0000" ELSE
			'0';
	-- Aqui iria la definicion del comportamiento de la ALU

END Structure;