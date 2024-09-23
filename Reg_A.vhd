library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_A is
    port (
        clk          : in std_logic;
        Reg_A_in        : in std_logic_vector(31 downto 0);  
        Reg_A_out       : out std_logic_vector(31 downto 0)  
    );
end entity Reg_A;

architecture behavior of Reg_A is
    signal Reg_A_current : std_logic_vector(31 downto 0) := (others => '0'); 
begin
    
    process (clk)
    begin
        if rising_edge(clk) then
            Reg_A_current <= Reg_A_in;  
        end if;
    end process;

    Reg_A_out <= Reg_A_current;

end architecture behavior;
