LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MUX_BULA IS
    PORT (
        --Entradas
        OrigBULA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        RegB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Const_4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Imediato : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- Saída
        ULA_B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END MUX_BULA;

ARCHITECTURE behavior OF MUX_BULA IS
BEGIN
    PROCESS (OrigBULA, RegB, Imediato, Const_4)
    BEGIN
        CASE OrigBULA IS

            WHEN "00" => ULA_B <= RegB;

            WHEN "01" => ULA_B <= Const_4;

            WHEN "10" => ULA_B <= Imediato;

            WHEN OTHERS => ULA_B <= x"00000000";

                -- when '11' => ULA_B <= Imediato sll 1;

        END CASE;
    END PROCESS;
END behavior;