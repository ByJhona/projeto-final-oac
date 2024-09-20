LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX_AULA IS
    PORT (
        -- Entradas
        OrigAULA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        PCback : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        RegA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- Saída                      
        ULA_A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END MUX_AULA;

ARCHITECTURE behavior OF MUX_AULA IS
BEGIN
    PROCESS (OrigAULA, PCback, RegA, PC)
    BEGIN
        CASE OrigAULA IS

            WHEN "00" => ULA_A <= PCback;

            WHEN "01" => ULA_A <= PC;
            WHEN "10" => ULA_A <= RegA;
            WHEN OTHERS => NULL;

        END CASE;
    END PROCESS;
END behavior;