LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_processador IS
END tb_processador;

ARCHITECTURE arq_tb_processador OF tb_processador IS
        COMPONENT processador IS
                PORT (
                        clock : IN STD_LOGIC;
                        address : IN STD_LOGIC_VECTOR(31 DOWNTO 0));
        END COMPONENT;
        SIGNAL address : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
        signal clock : std_logic;
        CONSTANT clk_period : TIME := 20 ns;

BEGIN

        uut_processador : processador PORT MAP(
                clock,
                address
        );

        GERACAO_CLOCK : PROCESS
        BEGIN

                FOR i IN 0 TO 255 LOOP
                        clock <= '0';
                        WAIT FOR clk_period/2;
                        clock <= '1';
                        WAIT FOR clk_period/2;
                END LOOP;
        END PROCESS;
END;