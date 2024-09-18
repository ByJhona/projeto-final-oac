LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY work;
USE work.RV32_pkg.ALL;

ENTITY CONTROL IS
	PORT (
		clock : IN STD_LOGIC;
		opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0) := (others => '0');
		
		EscrevePCCond : OUT STD_LOGIC := '0';
		EscrevePC : OUT STD_LOGIC := '0';
		IouD : OUT STD_LOGIC := '0';
		EscreveMem : OUT STD_LOGIC := '0';
		LeMem : OUT STD_LOGIC := '0';
		EscreveIR : OUT STD_LOGIC := '0';
		OrigPC : OUT STD_LOGIC := '0';
		ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
		OrigAULA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
		OrigBULA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
		EscrevePCB : OUT STD_LOGIC := '0';
		EscreveReg : OUT STD_LOGIC := '0';
		Mem2Reg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0')
	);
END CONTROL;

ARCHITECTURE arc_CONTROL OF CONTROL IS
	TYPE etapa_tipo IS (FETCH, DECODE, EXECUTE, MEMORYACCESS, WRITEBACK, UNDEFINED);
	TYPE instrucao_tipo IS (TIPOR, LOAD, STORE, BRANCH, JUMP_JAL);
	SIGNAL etapa_atual : etapa_tipo := FETCH;
	SIGNAL instrucao : instrucao_tipo;
	SIGNAL etapa_proxima : etapa_tipo;
	SIGNAL reset : STD_LOGIC := '1';
BEGIN
	DEF_INSTRUCAO : PROCESS (opcode)
	BEGIN
		IF rising_edge(clock) THEN
			CASE opcode IS
				WHEN "0110011" =>
					instrucao <= TIPOR;
				WHEN "0000011" =>
					instrucao <= LOAD;
				WHEN "0100011" =>
					instrucao <= STORE;
				WHEN "1100011" =>
					instrucao <= BRANCH;
				WHEN "1101111" =>
					instrucao <= JUMP_JAL;
				WHEN OTHERS => NULL;
			END CASE;
		END IF;
	END PROCESS;

	
	DEF_ETAPA : PROCESS (clock)
	BEGIN
		IF (rising_edge(clock)) THEN
			CASE etapa_atual IS
				WHEN FETCH =>
					LeMem <= '1';
					EscreveIR <= '1';
					IouD <= '0';
					OrigAULA <= "00";
					OrigBULA <= "01";
					ALUop <= "00";
					OrigPC <= '0';
					EscrevePC <= '1';
					EscrevePCB <= '1';
					etapa_atual <= DECODE;

				WHEN DECODE =>
					OrigAULA <= "00";
					OrigBULA <= "11";
					ALUop <= "00";

					etapa_atual <= EXECUTE;
					reset <= '0';

				WHEN EXECUTE =>

					CASE instrucao IS -- Verifica o tipo da instru��o
						WHEN TIPOR =>
							OrigAULA <= "01";
							OrigBULA <= "00";
							ALUop <= "01";
							etapa_atual <= MEMORYACCESS;
						WHEN LOAD | STORE =>
							OrigAULA <= "01";
							OrigBULA <= "10";
							ALUop <= "00";

							etapa_atual <= MEMORYACCESS;
							reset <= '0';
						WHEN BRANCH =>
							OrigAULA <= "01";
							OrigBULA <= "00";
							ALUop <= "01";
							EscrevePCCond <= '1';
							OrigPC <= '1';

							reset <= '1'; --Rever
							etapa_atual <= FETCH;
						WHEN JUMP_JAL =>
							OrigPC <= '1';
							EscrevePC <= '1';
							EscreveReg <= '1';
							Mem2Reg <= "01";
							reset <= '0';
							etapa_atual <= MEMORYACCESS;
						WHEN OTHERS => NULL;
					END CASE;

				WHEN MEMORYACCESS =>
					CASE instrucao IS
						WHEN TIPOR =>
							EscreveReg <= '1';
							Mem2Reg <= "00";

							etapa_atual <= WRITEBACK;
							reset <= '0';
						WHEN LOAD =>
							IouD <= '1';
							LeMem <= '1';
							EscreveMem <= '1';
							Mem2Reg <= "10";

							etapa_atual <= WRITEBACK;
							reset <= '0';
						WHEN STORE =>
							IouD <= '1';
							EscreveMem <= '1';

							etapa_atual <= FETCH;
							reset <= '1';
						WHEN OTHERS => NULL;

					END CASE;
					etapa_atual <= WRITEBACK;

				WHEN WRITEBACK =>
					Mem2Reg <= "01";
					EscreveReg <= '1';

					etapa_atual <= FETCH;
					reset <= '1';
				WHEN OTHERS => NULL;
			END CASE;
		END IF;
	END PROCESS;
END arc_CONTROL;