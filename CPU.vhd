library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    port (

        cpu_clock : in std_logic := '0';
        cpu_in    : in std_logic_vector(31 downto 0) := (others => '0');

        cpu_out : out std_logic_vector(31 downto 0) := (others => '0');
        opcode  : out std_logic_vector(6 downto 0) := (others => '0');
    );
end CPU;

architecture behavior of CPU is

    -- Signals for CONTROL
    signal EscrevePCCond :  std_logic;
    signal EscrevePC     :  std_logic;
    signal IouD          :  std_logic;
    signal EscreveMem    :  std_logic;
    signal LeMem         :  std_logic;
    signal EscreveIR     :  std_logic;
    signal OrigPC        :  std_logic;
    signal EscrevePCB    :  std_logic;
    signal EscreveReg    :  std_logic;
    signal ALUOp         :  std_logic_vector(1 downto 0);
    signal OrigAULA      :  std_logic_vector(1 downto 0);
    signal OrigBULA      :  std_logic_vector(1 downto 0);
    signal Mem2Reg       :  std_logic_vector(1 downto 0);
        
    -- Signals for PC
    signal pc_enable : std_logic := '1'; 

    -- Signals for MUX_IouD
    signal mux_in_instruction : std_logic_vector(31 downto 0);
    signal mux_ioud_out       : std_logic_vector(31 downto 0);  

    -- Signals for MEM
    signal instruction_address : std_logic_vector(11 downto 0); 
    signal mem_out             : std_logic_vector(31 downto 0);
    
begin

    -- colocar aqui depois a logica de pc cond ou escreve pc...

    -- PC Instance
    control_inst: entity work.CONTROL
    port map (
        clock         => cpu_clock,
		opcode        => opcode,
		EscrevePCCond => EscrevePCCond,
		EscrevePC     => EscrevePC, 
		IouD          => IouD,  
		EscreveMem    => EscreveMem,
		LeMem         => LeMem,
		EscreveIR     => EscreveIR,
		OrigPC        => OrigPC,
		EscrevePCB    => EscrevePCB,
		EscreveReg    => EscreveReg,
		ALUOp         => ALUOp,
		OrigAULA      => OrigAULA,
		OrigBULA      => OrigBULA,
		Mem2Reg       => Mem2Reg,
    );

    -- PC Instance
    pc_inst: entity work.PC
    port map (
        clock  => cpu_clock,
        enable => EscrevePC,
        pc_in  => cpu_in,
        pc_out => mux_in_instruction
    );

    -- MUX_IouD Instance
    MUX_IouD_inst: entity work.MUX_IouD
    port map (
        IouD_signal => IouD,
        instruction => mux_in_instruction,
        data        => x"00000000",
        mux_out     => mux_ioud_out
    );

    instruction_address <= std_logic_vector(mux_ioud_out(11 downto 0)); 

    -- MEM Instance
    MEM_inst: entity work.MEM
    port map (
        clock   => cpu_clock,
        we      => EscreveMem,
        re      => LeMem,
        address => instruction_address,
        data_in => x"00000000",
        mem_out => mem_out
    );

    -- Reg_Instruction Instance
    reg_instruction_inst: entity work.Reg_Instruction
    port map (
        clk               => cpu_clock,
        write_instruction => EscreveIR,
        reg_in            => mem_out,
        reg_out           => cpu_out
    );

    opcode <= std_logic_vector(cpu_out(6 downto 0));

end architecture behavior;
