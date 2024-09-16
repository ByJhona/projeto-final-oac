LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX01 IS
	PORT (
		selecao : IN STD_LOGIC := '0';
		A : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
		B : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
		saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0')
	);
END MUX01;

ARCHITECTURE arc_MUX01 OF MUX01 IS
BEGIN
	PROCESS (selecao, A, B)
	BEGIN
		CASE selecao IS
			WHEN '0' => saida <= A;
			WHEN '1' => saida <= B;
			WHEN OTHERS => saida <= x"00000000";
		END CASE;
	END PROCESS;
END arc_MUX01;