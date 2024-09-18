LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PC IS
    PORT (
        clock : IN STD_LOGIC := '0';
        enable : IN STD_LOGIC := '0';
        endereco_entrada : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        endereco_saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
END PC;

ARCHITECTURE arc_PC OF PC IS
BEGIN
    PROCESS (clock)
    BEGIN
        IF (rising_edge(clock) AND enable = '1') THEN
            endereco_saida <= endereco_entrada;
        END IF;
    END PROCESS;
END arc_PC;