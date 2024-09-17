library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Saida_ULA is
    port (
        clk          : in std_logic;
        ULA_in        : in std_logic_vector(31 downto 0);  
        ULA_out       : out std_logic_vector(31 downto 0)  
    );
end entity Saida_ULA;

architecture behavior of Saida_ULA is
    signal saida_ULA_reg : std_logic_vector(31 downto 0) := (others => '0'); 
begin
    
    process (clk)
    begin
        if rising_edge(clk) then
            saida_ULA_reg <= ULA_in;  
        end if;
    end process;

    ULA_out <= saida_ULA_reg;

end architecture behavior;
