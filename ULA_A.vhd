library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_A is
    port (
        clk          : in std_logic;
        ULA_A_in        : in std_logic_vector(31 downto 0);  
        ULA_A_out       : out std_logic_vector(31 downto 0)  
    );
end entity ULA_A;

architecture behavior of ULA_A is
    signal ULA_A_reg : std_logic_vector(31 downto 0) := (others => '0'); 
begin
    
    process (clk)
    begin
        if rising_edge(clk) then
            ULA_A_reg <= ULA_A_in;  
        end if;
    end process;

    ULA_A_out <= ULA_A_reg;

end architecture behavior;
