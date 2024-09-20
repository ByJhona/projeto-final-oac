LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PCBack IS
    PORT (
        clk : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY PCBack;

ARCHITECTURE behavior OF PCBack IS
    SIGNAL PC_reg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            PC_reg <= PC;
        END IF;
    END PROCESS;

    PC_out <= PC_reg;

END ARCHITECTURE behavior;