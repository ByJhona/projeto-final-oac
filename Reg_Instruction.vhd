LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Reg_Instruction is
    port (
        clock : in std_logic;
        EscreveIR : in std_logic;
        instruction_in : in std_logic_vector(31 downto 0) := (others => '0');
        opcode : out std_logic_vector(6 downto 0) := (others => '0');
        rs1 : out std_logic_vector(4 downto 0) := (others => '0');
        rs2 : out std_logic_vector(4 downto 0) := (others => '0');
        rd : out std_logic_vector(4 downto 0) := (others => '0');
        immediate : out std_logic_vector(31 downto 0) := (others => '0');
    );
end Reg_Instruction;

architecture behavior of Reg_Instruction is
    signal current_instruction : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
begin

    DECODE_INSTRCUTION : process (clock)
    begin
        if (rising_edge(clock) AND EscreveIR = '1') then
            current_instruction <= instruction_in;
        end if;
    end process;

    opcode <= current_instruction(6 DOWNTO 0);
    rs1 <= current_instruction(19 DOWNTO 15);
    rs2 <= current_instruction(24 DOWNTO 20);
    rd <= current_instruction(11 DOWNTO 7);
 
end behavior;