LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX_AULA IS
	PORT (
        -- Entradas
		RegA         : in std_logic_vector(31 downto 0);  
        PCback       : in std_logic_vector(31 downto 0);  
        OrigAULA     : in std_logic; 

       -- Saída                      
        ULA_A        : out std_logic_vector(31 downto 0)  
	);
END MUX_AULA;

ARCHITECTURE behavior OF MUX_AULA IS
BEGIN
    process (OrigAULA, Saida_ULA, Dado_Mem, Endereco_Instrucao)
    begin
        case OrigAULA is

            when "0" => ULA_A <= PCback;
                
            when "1" => ULA_A <= RegA;
                      
        end case;
    end process;
END behavior;
