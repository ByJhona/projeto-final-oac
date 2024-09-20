LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY work;
USE work.RV32_pkg.ALL;

entity CONTROL is
	port (

		clock : in std_logic;
		opcode : in std_logic_vector(6 downto 0) := (others => '0');
		
		EscrevePCCond : out std_logic := '0';
		EscrevePC     : out std_logic := '0';
		IouD          : out std_logic := '0';
		EscreveMem    : out std_logic := '0';
		LeMem         : out std_logic := '0';
		EscreveIR     : out std_logic := '0';
		OrigPC        : out std_logic := '0';
		EscrevePCB    : out std_logic := '0';
		EscreveReg    : out std_logic := '0';
		ALUOp         : out std_logic_vector(1 downto 0) := (others => '0');
		OrigAULA      : out std_logic_vector(1 downto 0) := (others => '0');
		OrigBULA      : out std_logic_vector(1 downto 0) := (others => '0');
		Mem2Reg       : out std_logic_vector(1 downto 0) := (others => '0')

	);
end CONTROL;

architecture behavior of CONTROL is
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

					CASE instrucao IS -- Verifica o tipo da instrucao
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
end behavior;