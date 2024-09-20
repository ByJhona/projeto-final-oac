library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_Instruction is
    port (

        clk                 : in std_logic;
        write_instruction   : in std_logic;  
        reg_in        : in std_logic_vector(31 downto 0);  

        reg_out       : out std_logic_vector(31 downto 0) 
    );
end entity Reg_Instruction;

architecture behavior of Reg_Instruction is
    signal instruc_reg : std_logic_vector(31 downto 0) := (others => '0');  
begin
    
    process (clk)
    begin
       
        if rising_edge(clk) then
            if write_instruction = '1' then
                instruc_reg <= reg_in; 
            end if;
        end if;
        
    end process;

    reg_out <= instruc_reg;

end architecture behavior;
