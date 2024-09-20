LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_processador IS
END tb_processador;

ARCHITECTURE arq_tb_processador OF tb_processador IS
        COMPONENT processador IS
                PORT (
                        clock : IN STD_LOGIC := '0'
                        );
        END COMPONENT;
        signal clock : std_logic := '0';
        CONSTANT clk_period : TIME := 20 ns;

BEGIN

        uut_processador : processador PORT MAP(
                clock
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