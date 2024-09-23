LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX_AULA IS
	PORT (

		RegA         : in std_logic_vector(31 downto 0);  
        PCback       : in std_logic_vector(31 downto 0);  
        PC           : in std_logic_vector(31 downto 0); 
        OrigAULA     : in std_logic_vector(1 downto 0); 
                     
        ULA_A        : out std_logic_vector(31 downto 0)  
        
	);
END MUX_AULA;

ARCHITECTURE behavior OF MUX_AULA IS
BEGIN
    process (OrigAULA)
    begin
        case OrigAULA is

            when "00" => ULA_A <= PCback;
                
            when "01" => ULA_A <= RegA;

            when "10" => ULA_A <= PC;

            when others => ULA_A <= PC;     -- para fins de teste
                      
        end case;
    end process;
END behavior;
