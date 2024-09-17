LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX_Mem2Reg IS
	PORT (
		-- Entradas
        Saida_ULA           : in std_logic_vector(31 downto 0); 
        Dado_Mem            : in std_logic_vector(31 downto 0); 
        Endereco_Instrucao  : in std_logic_vector(31 downto 0); 
        Mem2Reg             : in std_logic_vector(1 downto 0);  
        
        -- Saída
        Escreve_Dado : out std_logic_vector(31 downto 0)
	);
END MUX_Mem2Reg;

ARCHITECTURE behavior OF MUX_Mem2Reg IS
BEGIN
    process (Mem2Reg, Saida_ULA, Dado_Mem, Endereco_Instrucao)
    begin
        case Mem2Reg is

            when "00" => Escreve_Dado <= Saida_ULA;
                
            when "01" => Escreve_Dado <= Dado_Mem;
                
            when "10" => Escreve_Dado <= Endereco_Instrucao;
                
            when others => Escreve_Dado <= Saida_ULA;

        end case;
    end process;
END behavior;
