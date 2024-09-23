library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCback is
    port (
        clk       : in std_logic;  
        we        : in std_logic;  
        pcback_in : in std_logic_vector(31 downto 0);  
        pcback_out : out std_logic_vector(31 downto 0) 
    );
end entity PCback;

architecture behavior of PCback is
    signal pcback_current : std_logic_vector(31 downto 0) := (others => '0');  
begin
   
    process (clk)
    begin
       
        if rising_edge(clk) then
            if we = '1' then
                pcback_current <= pcback_in;  
            end if;
        end if;
    end process;

    pcback_out <= pcback_current;

end architecture behavior;
