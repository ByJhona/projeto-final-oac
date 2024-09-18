library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY CPU IS
    PORT (
        clock : IN STD_LOGIC := '0';
        reset : IN STD_LOGIC := '0';
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0') -- Connects to MEM's dataout
    );
END CPU;

architecture behavior of CPU is
        
        -- Signals for PC, MEM, and MUX connections
        signal pc_address : std_logic_vector(31 downto 0);  -- Output from PC (current PC)
        signal mem_address : std_logic_vector(11 downto 0); -- Address sent to memory
        signal mem_dataout : std_logic_vector(31 downto 0); -- Data read from memory
        signal mem_datain  : std_logic_vector(31 downto 0); -- Data to be written into memory
        signal mux_out     : std_logic_vector(31 downto 0); -- Output of the MUX IouD
        signal we, re      : std_logic;                     -- Write/Read enable for MEM
        signal ioud_sinal  : std_logic;                     -- Control signal for MUX_IouD
        signal escreve_pc, escreve_mem, le_mem : std_logic; -- Control signals from Control
        signal pc_enable : std_logic;  -- Control signal to enable writing to PC
    
    begin
        -- PC Instance
        pc_inst: entity work.PC
            port map (
                clock           => clock,
                enable          => pc_enable,
                endereco_entrada => x"00000000",   -- Input to PC initialized with hex zero
                endereco_saida   => pc_address -- Output of PC (current instruction address)
            );
    
        -- MEM Instance (Memory for instructions and data)
        mem_inst: entity work.MEM
            port map (
                clock    => clock,
                we       => escreve_mem,       -- Write enable
                re       => le_mem,            -- Read enable
                address  => mem_address,       -- Address for memory access
                datain   => mem_datain,        -- Data to be written into memory
                dataout  => mem_dataout        -- Data read from memory
            );
    
        -- MUX_IouD Instance (To select between PC or ALU output)
        mux_ioud_inst: entity work.MUX_IouD
            port map (
                IouD_sinal => ioud_sinal,
                instrucao  => pc_address,      -- Instruction address from PC
                saida_ULA  => (others => '0'), -- Placeholder for ALU output (to be connected later)
                saida      => mux_out          -- Output of the MUX
            );
    
        -- Control Unit Instance (Generates control signals)
        control_inst: entity work.CONTROL
            port map (
                clock       => clock,
                opcode      => opcode,
                EscrevePC   => pc_enable,      -- Enables writing to PC
                EscreveMem  => escreve_mem,    -- Enables writing to memory
                LeMem       => le_mem,         -- Enables reading from memory
                IouD        => ioud_sinal      -- Controls which value the MUX selects (PC or ALU)
            );
    
        -- Connect PC output (pc_address) to the memory's address input (mem_address)
        mem_address <= std_logic_vector(pc_address(11 downto 0));  -- Connect the lower 12 bits
    
    end architecture behavior;
    

