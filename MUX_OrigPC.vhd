LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX_OrigPC IS
	PORT (
		
		A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		OrigPC : IN STD_LOGIC;

		mux_origpc_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

	);
END MUX_OrigPC;

ARCHITECTURE behavior OF MUX_OrigPC IS
BEGIN
	PROCESS (OrigPC, A, B)
	BEGIN
		CASE OrigPC IS

			WHEN '0' => mux_origpc_out <= A;

			WHEN '1' => mux_origpc_out <= B;

			WHEN OTHERS => mux_origpc_out <= x"00000000";

		END CASE;
	END PROCESS;
END behavior;