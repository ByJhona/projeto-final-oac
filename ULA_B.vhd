library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_B is
    port (
        clk          : in std_logic;
        ULA_B_in        : in std_logic_vector(31 downto 0);  
        ULA_B_out       : out std_logic_vector(31 downto 0)  
    );
end entity ULA_B;

architecture behavior of ULA_A is
    signal ULA_B_reg : std_logic_vector(31 downto 0) := (others => '0'); 
begin
    
    process (clk)
    begin
        if rising_edge(clk) then
            ULA_B_reg <= ULA_B_in;  
        end if;
    end process;

    ULA_B_out <= ULA_B_reg;

end architecture behavior;
