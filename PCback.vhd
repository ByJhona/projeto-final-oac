library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCback is
    port (
        clk          : in std_logic;  -- System clock
        write_enable : in std_logic;  -- Signal to enable writing to PCback
        pc_in        : in std_logic_vector(31 downto 0);  -- Input PC value to store
        pc_out       : out std_logic_vector(31 downto 0)  -- Output stored PCback value
    );
end entity PCback;

architecture behavior of PCback is
    signal pcback_reg : std_logic_vector(31 downto 0) := (others => '0');  -- PCback register
begin
    -- Process to handle PCback register
    process (clk)
    begin
       
        if rising_edge(clk) then
            if write_enable = '1' then
                pcback_reg <= pc_in;  -- Write current PC to PCback
            end if;
        end if;
    end process;

    -- Output the stored PCback value
    pc_out <= pcback_reg;

end architecture behavior;
