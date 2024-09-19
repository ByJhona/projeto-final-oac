LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;

entity MEM is
    port (

        clock : in std_logic := '0';
        we : in std_logic := '0';
        re : in std_logic := '1';
        address : in std_logic_vector(11 downto 0) := (others => '0');
        data_in : in std_logic_vector(31 downto 0) := (others => '0');

        mem_out : out std_logic_vector(31 downto 0) := (others => '0')
    );

end MEM;

architecture behavior of MEM is

    type ram_type is array (0 to (2 ** address'length) - 1) of std_logic_vector(data_in'RANGE);

    IMPURE FUNCTION init_ram RETURN ram_type IS
        FILE text_file : text OPEN read_mode IS "instruction.txt";
        VARIABLE text_line : line;
        VARIABLE ram_content : ram_type;
        VARIABLE read_value : std_logic_vector(data_in'RANGE); -- Variável auxiliar
    BEGIN
        FOR i IN 0 TO (2 ** address'length - 1) LOOP

            IF (NOT endfile(text_file)) THEN
                readline(text_file, text_line);
                hread(text_line, read_value); -- Ler hexadecimal para read_value
                ram_content(i) := read_value; -- Atribuir valor lido à RAM
            ELSE
                EXIT;
            END IF;

        END LOOP;
        RETURN ram_content;
    END FUNCTION;

    SIGNAL mem : ram_type := init_ram;
    SIGNAL read_address : std_logic_vector(address'RANGE);

BEGIN

    read_write : process (clock)
    begin
        -- Escrita
        if (we = '1' and rising_edge(clock)) then
            mem(to_integer(unsigned(address))) <= data_in;

        elsif (re = '1') then
            mem_out <= mem(to_integer(unsigned(address)));
        end if;
    end process;

end behavior;