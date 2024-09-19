library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    port (

        cpu_clock : in std_logic := '0';
        cpu_in  : in std_logic_vector(31 downto 0) := (others => '0');

        cpu_out : out std_logic_vector(31 downto 0) := (others => '0');
    );
end CPU;

architecture behavior of CPU is
        
    -- Signals for PC
    signal pc_enable : std_logic := '1'; 

    -- Signals for MUX_IouD
    signal IouD_signal : std_logic := '0'; 
    signal mux_in_instruction : std_logic_vector(31 downto 0);
    signal mux_ioud_out : std_logic_vector(31 downto 0);  

    -- Signals for MEM
    signal instruction_address : std_logic_vector(11 downto 0); 
       
begin

    -- PC Instance
    pc_inst: entity work.PC
        port map (
            clock  => cpu_clock,
            enable => pc_enable,
            pc_in  => cpu_in,
            pc_out => mux_in_instruction
        );

    -- MUX_IouD Instance
    MUX_IouD_inst: entity work.MUX_IouD
    port map (
        IouD_signal  => IouD_signal,
        instruction => mux_in_instruction,
        data  => x"00000000",
        mux_out => mux_ioud_out
    );

    instruction_address <= std_logic_vector(mux_ioud_out(11 downto 0)); 

    -- MEM Instance
    MEM_inst: entity work.MEM
    port map (
        clock  => cpu_clock,
        we => '0',
        re  => '1',
        address => instruction_address,
        data_in => x"00000000",
        mem_out => cpu_out
    );

end architecture behavior;
