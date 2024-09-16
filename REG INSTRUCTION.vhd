LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY REG_INSTRUCTION IS
    PORT (
        clock : IN STD_LOGIC := '0';
        EscreveIR : IN STD_LOGIC := '0';
        instrucao : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
        rs1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        rs2 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        rd : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        imediato : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        controle_ULA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0') -- rever
    );
END REG_INSTRUCTION;

ARCHITECTURE arc_REG_INSTRUCTION OF REG_INSTRUCTION IS
    SIGNAL dado : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
            dado <= instrucao;

    LEITURA_ESCRITA : PROCESS (clock)
    BEGIN
        IF (rising_edge(clock) AND EscreveIR = '1') THEN
            opcode <= dado(6 DOWNTO 0);
            rs1 <= dado(19 DOWNTO 15);
            rs2 <= dado(24 DOWNTO 20);
            rd <= dado(11 DOWNTO 7);
            imediato <= dado;
        END IF;
    END PROCESS;
END arc_REG_INSTRUCTION;