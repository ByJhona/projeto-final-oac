LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY work;


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
	type state is (FETCH, DECODE, EXECUTE, MEMORYACCESS, WRITEBACK);
    type instruction_type_t is (RTYPE, LOAD, STORE, BEQ, JAL);
    signal current_state : state := FETCH;
    signal next_state : state := FETCH;
    signal instruction_type : instruction_type_t; 
begin

	DEFINE_SEQUENCER : process (clock)
	begin
		
		if rising_edge(clock) then
			current_state <= next_state;
		end if;
		
	end process;

	DEFINE_INSTRUCTION_TYPE : process (opcode)
	begin
		
		case opcode is
			when "0110011" =>
				instruction_type <= RTYPE;
			when "0000011" =>
				instruction_type <= LOAD;
			when "0100011" =>
				instruction_type <= STORE;
			when "1100011" =>
				instruction_type <= BEQ;
			when "1101111" =>
				instruction_type <= JAL;
			when others => NULL;
		end case;
		
	end process;

	DEFINE_NEXT_STATE : process (current_state)
	begin

		case current_state is
			when FETCH =>
				next_state <= DECODE;
			when DECODE =>
				next_state <= EXECUTE;
			when EXECUTE =>
				case instruction_type is

					when LOAD | STORE | RTYPE =>
						next_state <= MEMORYACCESS;
					when BEQ | JAL =>
						next_state <= FETCH;
					when others =>
						next_state <= FETCH;

				end case;
			when MEMORYACCESS =>
			
				case instruction_type is

					when LOAD =>
						next_state <= WRITEBACK;

					when others =>
						next_state <= FETCH;

				end case;
			when WRITEBACK =>
				next_state <= FETCH;
		end case;
	end process;

	DEFINE_CONTROL_SIGNALS : process (current_state)
	begin
		
		case current_state is

			when FETCH =>
				IouD          <= '0';
				LeMem         <= '1';
				EscreveIR     <= '1';
				OrigAULA      <= "10";
				OrigBULA      <= "01";
				ALUOp         <= "00";
				OrigPC        <= '0';
				EscrevePC     <= '1';
				EscrevePCB    <= '1';
				EscrevePCCond <= '0';
				EscreveMem    <= '0';
				
			when DECODE =>
				OrigAULA <= "00";
				OrigBULA <= "11";
				ALUOp    <= "00";
				EscrevePC <= '0';

			when EXECUTE =>

				case instruction_type is 
					when RTYPE =>
						OrigAULA <= "01";
						OrigBULA <= "00";
						ALUOp    <= "01";
						
					when LOAD | STORE =>
						OrigAULA <= "01";
						OrigBULA <= "10";
						ALUop    <= "00";
				
					when BEQ =>
						OrigAULA      <= "01";
						OrigBULA      <= "00";
						ALUOp         <= "01";
						OrigPC        <= '1';
						EscrevePCCond <= '1';
						
					when JAL =>
						OrigPC     <= '1';
						EscrevePC  <= '1';
						Mem2Reg    <= "01";
						EscreveReg <= '1';
						
					when others => NULL;
				end case;

			when MEMORYACCESS =>

				case instruction_type is
					when RTYPE =>
						Mem2Reg    <= "00";
						EscreveReg <= '1';
					
					when LOAD =>
						IouD  <= '1';
						LeMem <= '1';
						
					when STORE =>
						IouD       <= '1';
						EscreveMem <= '1';
						
					when others => NULL;

				end case;

			when WRITEBACK =>
				Mem2Reg    <= "10";
				EscreveReg <= '1';
				
			when others => NULL;
		end case;
	end process;

end behavior;