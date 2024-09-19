LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity MUX_IouD is
	port (
		
		IouD_signal  : in std_logic := '0';
		instruction  : in std_logic_vector(31 downto 0);
		data         : in std_logic_vector(31 downto 0);

		mux_out      : out std_logic_vector(31 downto 0)
	);
end MUX_IouD;

architecture behavior of MUX_IouD is
begin
	process (IouD_signal, instruction, data)
	begin
		case IouD_signal is

			when '0' => mux_out <= instruction;

			when '1' => mux_out <= data;

			when others => mux_out <= x"00000000";

		end case;
	end process;
end behavior;