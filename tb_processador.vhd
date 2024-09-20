LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_textio.all;

ENTITY tb_processador IS
END tb_processador;

ARCHITECTURE arq_tb_processador OF tb_processador IS
        COMPONENT processador IS
                PORT (
                        clock : IN STD_LOGIC := '0';
                        mem_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        opcode_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
                        reg_out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        reg_out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        imm_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        ula_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        );
        END COMPONENT;
        signal clock : std_logic := '0';
        signal mem_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal opcode_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
        signal reg_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal reg_out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal imm_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal ula_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
        CONSTANT clk_period : TIME := 20 ns;

BEGIN

        uut_processador : processador PORT MAP(
                clock,
                mem_out,
                opcode_out,
                reg_out1,
                reg_out2,
                imm_out,
                ula_out
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

        stim_proc : process    
        begin
                FOR i IN 0 TO 150 LOOP
                		report "---------------------------------------";
                        report "mem_out: " & to_hstring(mem_out);
                        report "opcode_out: " & to_string(opcode_out);
                        report "reg_out1: " & to_hstring(reg_out1);
                        report "reg_out2: " & to_hstring(reg_out2);
                        report "imm_out: " & to_hstring(imm_out);
                        report "ula_out: " & to_hstring(ula_out);
                        wait for clk_period;
                END LOOP;
        end process;
END;