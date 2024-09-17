library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_Instruc is
    port (
        clk          : in std_logic;
        escreve_ir   : in std_logic;  
        instruc_in        : in std_logic_vector(31 downto 0);  
        instruc_out       : out std_logic_vector(31 downto 0) 
    );
end entity Reg_Instruc;

architecture behavior of Reg_Instruc is
    signal instruc_reg : std_logic_vector(31 downto 0) := (others => '0');  
begin
    
    process (clk)
    begin
       
        if rising_edge(clk) then
            if escreve_ir = '1' then
                instruc_reg <= instruc_in; 
            end if;
        end if;
    end process;

    instruc_out <= instruc_reg;

end architecture behavior;
