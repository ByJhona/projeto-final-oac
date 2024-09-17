LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX_IouD IS
	PORT (
		-- Entradas
		IouD_sinal : IN STD_LOGIC := '0';
		instrucao  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		saida_ULA  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		-- Saída
		saida      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MUX_IouD;

ARCHITECTURE behavior OF MUX_IouD IS
BEGIN
	PROCESS (IouD_sinal, instrucao, saida_ULA)
	BEGIN
		CASE IouD_sinal IS

			WHEN '0' => saida <= instrucao;

			WHEN '1' => saida <= saida_ULA;

			WHEN OTHERS => saida <= x"00000000";

		END CASE;
	END PROCESS;
END behavior;