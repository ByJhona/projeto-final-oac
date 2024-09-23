library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    port (

        cpu_clock : in std_logic := '0';
        cpu_in    : in std_logic_vector(31 downto 0) := (others => '0');
        cpu_out : out std_logic_vector(31 downto 0) := (others => '0');
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
    signal pc_enable : std_logic; 

    -- Signals for MUX_IouD
    signal mux_in_instruction : std_logic_vector(31 downto 0);
    signal mux_ioud_out       : std_logic_vector(31 downto 0);  

    -- Signals for MEM
    signal instruction_address : std_logic_vector(11 downto 0); 
    signal mem_out             : std_logic_vector(31 downto 0);

    -- Signals for Reg Instruction
    signal opcode    : std_logic_vector(6 downto 0) := (others => '0');
    signal rs1       : std_logic_vector(4 downto 0) := (others => '0');
    signal rs2       : std_logic_vector(4 downto 0) := (others => '0');
    signal rd        : std_logic_vector(4 downto 0) := (others => '0');
    signal immediate : std_logic_vector(31 downto 0) := (others => '0');

    -- Signals for MUX_AULA
	signal RegA         : std_logic_vector(31 downto 0) := (others => '0');  
    signal PCback       : std_logic_vector(31 downto 0);                       
    signal mux_aula_out : std_logic_vector(31 downto 0);

    -- Signals for MUX_BULA
    signal RegB         : std_logic_vector(31 downto 0) := (others => '0');  
    signal Imediato     : std_logic_vector(31 downto 0) := (others => '0');     
    signal mux_bula_out : std_logic_vector(31 downto 0) := (others => '0');

    -- Signals for ULA
    signal funct3   : std_logic_vector(2 downto 0);
    signal funct7   : std_logic_vector(6 downto 0);
    signal ula_out  : std_logic_vector(31 downto 0);
    signal cond     : std_logic;

    -- Signals for MUX_OrigPC
    signal mux_origpc_out : std_logic_vector(31 downto 0) := (others => '0');

begin

    pc_enable <= (EscrevePC) OR (EscrevePCCond AND cond);
    
    -- CONTROL Instance
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
		Mem2Reg       => Mem2Reg
    );

    -- PC Instance
    pc_inst: entity work.PC
    port map (
        clock  => cpu_clock,
        enable => pc_enable,
        pc_in  => mux_origpc_out,
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

    instruction_address <= std_logic_vector(mux_ioud_out(13 downto 2)); 

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
        clock     => cpu_clock,
        EscreveIR => EscreveIR,
        instruction_in => mem_out,
        opcode => opcode,
        rs1 => rs1,
        rs2 => rs2,
        rd => rd,
        immediate => immediate
    );

    -- MUX_AULA Instance
    mux_aula_inst: entity work.MUX_AULA
    port map (
		RegA     => RegA,  
        PC       => mux_in_instruction,
        PCback   => mux_in_instruction,    
        OrigAULA => OrigAULA,                       
        ULA_A    => mux_aula_out       
    );

    -- MUX_BULA Instance
    mux_bula_inst: entity work.MUX_BULA
    port map (
        RegB     => RegB,
        Imediato => immediate,
        OrigBULA => OrigBULA,   
        ULA_B    => mux_bula_out
    );

    -- ULA Instance
    ula_inst: entity work.ULA
    port map (
        ALUOp  => ALUOp,
        funct3 => funct3,
        funct7 => funct7,
        A      => mux_aula_out,
        B      => mux_bula_out,
        Z      => ula_out,
        cond   => cond
    );

    -- MUX_OrigPC Instance
    mux_origpc_inst: entity work.MUX_OrigPC
    port map (
        A => ula_out, 
		B => ula_out, -- apenas para fins de teste (o correto seria a saida de "saida_ula")
		OrigPC => OrigPC,
		mux_origpc_out => mux_origpc_out
    );

end architecture behavior;
