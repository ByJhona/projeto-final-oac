LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY XREGS IS
    GENERIC (WSIZE : NATURAL := 32);
    PORT (
        clk : IN STD_LOGIC := '0';
        wren : IN STD_LOGIC := '0';
        data : IN STD_LOGIC_VECTOR(WSIZE - 1 DOWNTO 0);
        rs1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rs2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        ro1 : OUT STD_LOGIC_VECTOR(WSIZE - 1 DOWNTO 0) := (OTHERS => '0');
        ro2 : OUT STD_LOGIC_VECTOR(WSIZE - 1 DOWNTO 0) := (OTHERS => '0')
    );

END XREGS;

ARCHITECTURE arc_XREGS OF XREGS IS
    TYPE vetor IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL banco_reg : vetor := (OTHERS => (OTHERS => '1'));
    SIGNAL A_int, B_int, rd_int : INTEGER RANGE 0 TO 31;
BEGIN
    A_int <= to_integer(unsigned(rs1));
    B_int <= to_integer(unsigned(rs2));
    rd_int <= to_integer(unsigned(rd));

    LEITURA_ESCRITA : PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            ro1 <= banco_reg(A_int);
            ro2 <= banco_reg(B_int);
        END IF;

        IF (wren = '1') AND (rd_int /= 0) AND (rising_edge(clk)) THEN
            banco_reg(rd_int) <= STD_LOGIC_VECTOR(data);
        END IF;
    END PROCESS;

END arc_XREGS;