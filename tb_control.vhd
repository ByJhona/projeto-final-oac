LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_control IS
END tb_control;

ARCHITECTURE arq_tb_control OF tb_control IS
        -- Component Declaration for the Unit Under Test (UUT)
        COMPONENT CONTROL
                PORT (
                        clock : IN STD_LOGIC;
                        opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
                        EscrevePCCond : OUT STD_LOGIC;
                        EscrevePC : OUT STD_LOGIC;
                        IouD : OUT STD_LOGIC;
                        EscreveMem : OUT STD_LOGIC;
                        LeMem : OUT STD_LOGIC;
                        EscreveIR : OUT STD_LOGIC;
                        OrigPC : OUT STD_LOGIC;
                        ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        OrigAULA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        OrigBULA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        EscrevePCB : OUT STD_LOGIC;
                        EscreveReg : OUT STD_LOGIC;
                        Mem2Reg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
                );
        END COMPONENT;

        -- Signals for the UUT
        SIGNAL clock : STD_LOGIC := '0';
        SIGNAL opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
        SIGNAL EscrevePCCond : STD_LOGIC;
        SIGNAL EscrevePC : STD_LOGIC;
        SIGNAL IouD : STD_LOGIC;
        SIGNAL EscreveMem : STD_LOGIC;
        SIGNAL LeMem : STD_LOGIC;
        SIGNAL EscreveIR : STD_LOGIC;
        SIGNAL OrigPC : STD_LOGIC;
        SIGNAL ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL OrigAULA : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL OrigBULA : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL EscrevePCB : STD_LOGIC;
        SIGNAL EscreveReg : STD_LOGIC;
        SIGNAL Mem2Reg : STD_LOGIC_VECTOR(1 DOWNTO 0);

        -- Clock period definition
        CONSTANT clk_period : TIME := 10 ns;

BEGIN
        -- Instantiate the Unit Under Test (UUT)
        uut : CONTROL PORT MAP(
                clock => clock,
                opcode => opcode,
                EscrevePCCond => EscrevePCCond,
                EscrevePC => EscrevePC,
                IouD => IouD,
                EscreveMem => EscreveMem,
                LeMem => LeMem,
                EscreveIR => EscreveIR,
                OrigPC => OrigPC,
                ALUOp => ALUOp,
                OrigAULA => OrigAULA,
                OrigBULA => OrigBULA,
                EscrevePCB => EscrevePCB,
                EscreveReg => EscreveReg,
                Mem2Reg => Mem2Reg
        );

        -- Test Stimulus process
        stim_proc : PROCESS
        BEGIN
                -- Initialize Inputs
                clock <= '1';
                opcode <= "0110011"; -- TIPOR instruction
                WAIT FOR 100 ns;

                -- Check FETCH stage
                ASSERT (LeMem = '1' AND EscreveIR = '1' AND EscrevePC = '1')
                REPORT "FETCH stage failed TIPOR" SEVERITY error;
                clock <= '0';

                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;

                -- Check DECODE stage
                ASSERT (OrigAULA = "00" AND OrigBULA = "11")
                REPORT "DECODE stage failed TIPOR" SEVERITY error;
                clock <= '0';
                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;
                -- Check EXECUTE stage for TIPOR
                ASSERT (ALUOp = "01" AND OrigAULA = "01" AND OrigBULA = "00")
                REPORT "EXECUTE stage failed for TIPOR" SEVERITY error;
                clock <= '0';
                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;

                -- Check MEMORYACCESS stage for TIPOR
                ASSERT (EscreveReg = '1' AND Mem2Reg = "00")
                REPORT "MEMORYACCESS stage failed for TIPOR" SEVERITY error;
                clock <= '0';
                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;
                -- Check WRITEBACK stage
                ASSERT (Mem2Reg = "01" AND EscreveReg = '1')
                REPORT "WRITEBACK stage failed tipor" SEVERITY error;

                clock <= '0';

                -- Finish the simulation
                WAIT FOR 100 ns;

                clock <= '1';
                opcode <= "1100011";

                WAIT FOR 100 ns;
                -- Check FETCH stage
                ASSERT (LeMem = '1' AND EscreveIR = '1' AND EscrevePC = '1')
                REPORT "FETCH stage failed Store BEQ" SEVERITY error;
                clock <= '0';

                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;

                -- Check DECODE stage
                -- (Ajustar OrigAULA e OrigBULA conforme a instru��o BEQ)
                ASSERT (OrigAULA = "00" AND OrigBULA = "11") -- Exemplo, verificar se os operandos v�m dos registradores corretos
                REPORT "DECODE stage failed BEQ" SEVERITY error;
                clock <= '0';
                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;

                -- Check EXECUTE stage for BEQ
                -- (Ajustar ALUOp, OrigAULA e OrigBULA conforme a instru��o BEQ)
                ASSERT (ALUOp = "01" AND OrigAULA = "01" AND OrigBULA = "00") -- Exemplo, verificar se a ALU realiza a compara��o dos registradores
                -- Verificar o sinal de controle de desvio (Branch)
                REPORT "Execute stage failed BEQ" SEVERITY error;

                clock <= '0';



                -- Finish the simulation
                WAIT FOR 100 ns;
                -- Initialize Inputs
                opcode <= "0000011"; -- LOAD instruction
                clock <= '1';
                WAIT FOR 100 ns;
                -- Check FETCH stage
                ASSERT (LeMem = '1' AND EscreveIR = '1' AND EscrevePC = '1')
                REPORT "FETCH stage failed load" SEVERITY error;
                clock <= '0';

                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;

                -- Check DECODE stage
                -- (Ajustar OrigAULA e OrigBULA conforme a instru��o LOAD)
                ASSERT (OrigAULA = "00" AND OrigBULA = "11") -- Exemplo, verificar se os operandos v�m dos registradores corretos
                REPORT "DECODE stage failed load" SEVERITY error;
                clock <= '0';
                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;

                -- Check EXECUTE stage for LOAD
                -- (Ajustar ALUOp, OrigAULA e OrigBULA conforme a instru��o LOAD)
                ASSERT (ALUOp = "00" AND OrigAULA = "01" AND OrigBULA = "10") -- Exemplo, verificar se a ALU realiza a soma para calcular o endere�o de mem�ria
                REPORT "EXECUTE stage failed for LOAD" SEVERITY error;
                clock <= '0';
                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;

                -- Check MEMORYACCESS stage for LOAD
                ASSERT (LeMem = '1' AND Mem2Reg = "10") -- Verificar se a mem�ria � lida e o dado ser� escrito no registrador
                REPORT "MEMORYACCESS stage failed for LOAD" SEVERITY error;
                clock <= '0';
                WAIT FOR 100 ns;
                clock <= '1';
                WAIT FOR 100 ns;

                -- Check WRITEBACK stage
                ASSERT (Mem2Reg = "01" AND EscreveReg = '1')
                REPORT "WRITEBACK stage failed load" SEVERITY error;

                clock <= '0';

                -- Finish the simulation
                WAIT FOR 100 ns;
                REPORT "End of simulation";
                WAIT;
        END PROCESS;

END;