library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    PORT (

        clock : in STD_LOGIC := '0';
        enable : in STD_LOGIC := '0';
        pc_in : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
        
        pc_out : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
    );
end PC;

architecture behavior of PC is
begin

    process (clock)
    begin

        if (rising_edge(clock) AND enable = '1') then
            pc_out <= pc_in;
        end if;

    end process;

end behavior;