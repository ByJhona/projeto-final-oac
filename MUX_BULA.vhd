library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_BULA is
    port (
        -- Entradas
        RegB      : in std_logic_vector(31 downto 0);  
        Imediato  : in std_logic_vector(31 downto 0);  
        OrigBULA  : in std_logic_vector(1 downto 0);   

        -- Saída
        ULA_B     : out std_logic_vector(31 downto 0)  
    );
end MUX_BULA;

architecture behavior of MUX_BULA is
    -- Constante para o valor 4
    constant Const_4 : std_logic_vector(31 downto 0) := x"00000004";
begin
    process (OrigBULA, RegB, Imediato)
    begin
        case OrigBULA is
            when "00" => 
                ULA_B <= RegB;
            when "01" => 
                ULA_B <= Const_4;
            when "10" => 
                ULA_B <= Imediato;
            when "11" => 
                ULA_B <= Imediato sll 1;
            when others => 
                ULA_B <= (others => '0');
        end case;
    end process;
end behavior;
