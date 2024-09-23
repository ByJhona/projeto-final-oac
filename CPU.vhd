library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    port (

        cpu_clock   : in std_logic := '0';
        instruction_p : out std_logic_vector(31 downto 0) := (others => '0');
        instruction_address_p : out std_logic_vector(31 downto 0) := (others => '0');
        ula_out_p : out std_logic_vector(31 downto 0) := (others => '0');
        OrigAULA_p: out std_logic_vector(1 downto 0);
        OrigBULA_p   : out std_logic_vector(1 downto 0);
        OrigPC_p   : out std_logic;

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
    signal pc_out : std_logic_vector(31 downto 0);
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

    -- Signals for Reg_File
    signal reg_out1 : std_logic_vector(31 downto 0);
    signal reg_out2 : std_logic_vector(31 downto 0);

    -- Signals for PCback
    signal pcback_out : std_logic_vector(31 downto 0);

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

    OrigPC_p <= OrigPC;

    -- PC Instance
    pc_inst: entity work.PC
    port map (
        clock  => cpu_clock,
        enable => pc_enable,
        pc_in  => mux_origpc_out,
        pc_out => pc_out
    );

    -- MUX_IouD Instance
    MUX_IouD_inst: entity work.MUX_IouD
    port map (
        IouD_signal => IouD,
        instruc_addr => pc_out,
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

    instruction_p <= mem_out;

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

    -- Reg_File Instance
    reg_file_inst: entity work.Reg_File
    port map (
        clk  => cpu_clock,
        wren => EscreveReg,
        rs1  => rs1,
        rs2  => rs2,
        rd   => rd,
        data => x"00000000",
        ro1  => reg_out1,
        ro2  => reg_out2
    );

    OrigAULA_p <= OrigAULA;
    OrigBULA_p <= OrigBULA;

    -- PCback Instance
    pcback_inst: entity work.PCback
    port map (
		clk       => cpu_clock, 
        we        => EscrevePCB, 
        pcback_in => pc_out, 
        pcback_out => pcback_out       
    );

    -- MUX_AULA Instance
    mux_aula_inst: entity work.MUX_AULA
    port map (
		RegA     => RegA,  
        PC       => pc_out,
        PCback   => pcback_out,    
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

    funct7 <= immediate(31 DOWNTO 25);
    funct3 <= immediate(14 DOWNTO 12);

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

    ula_out_p <= ula_out;

    -- MUX_OrigPC Instance
    mux_origpc_inst: entity work.MUX_OrigPC
    port map (
        A => ula_out, 
		B => ula_out, -- apenas para fins de teste (o correto seria a saida de "saida_ula")
		OrigPC => OrigPC,
		mux_origpc_out => mux_origpc_out
    );

    instruction_address_p <= mux_origpc_out;

end architecture behavior;
