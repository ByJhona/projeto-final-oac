library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_Dado is
    port (
        clk          : in std_logic;
        dado_in        : in std_logic_vector(31 downto 0);  
        dado_out       : out std_logic_vector(31 downto 0)  
    );
end entity Reg_Dado;

architecture behavior of Reg_Dado is
    signal dado_reg : std_logic_vector(31 downto 0) := (others => '0'); 
begin
    
    process (clk)
    begin
        if rising_edge(clk) then
            dado_reg <= dado_in;  
        end if;
    end process;

    dado_out <= dado_reg;

end architecture behavior;
