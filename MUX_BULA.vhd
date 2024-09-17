library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_BULA is
    port (
        --Entradas
        RegB      : in std_logic_vector(31 downto 0);  
        Imediato : in std_logic_vector(31 downto 0);  
        Const_4   : in std_logic_vector(31 downto 0);  
        OrigBULA   : in std_logic_vector(1 downto 0);   

        -- Saída
        ULA_B     : out std_logic_vector(31 downto 0)  
    );
end MUX_BULA;

architecture behavior of MUX_BULA is
begin
    -- MUX for ALU_B
    process (OrigBULA, RegB, Imediato, Const_4)
    begin
        case OrigBULA is

            when "00" => ULA_B <= RegB;

            when "01" => ULA_B <= Const_4; 

            when "10" => ULA_B <= Imediato;

            when '11' => ULA_B <= Imediato sll 1;

        end case;
    end process;
end behavior;
