LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY MEM IS
    PORT (
        clock : IN STD_LOGIC := '0';
        we : IN STD_LOGIC := '0';
        re : IN STD_LOGIC := '1';
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );

END MEM;

ARCHITECTURE arc_MEM OF MEM IS
    TYPE ram_type IS ARRAY (0 TO (2 ** address'length) - 1) OF STD_LOGIC_VECTOR(datain'RANGE);

    IMPURE FUNCTION init_ram RETURN ram_type IS
        FILE text_file : text OPEN read_mode IS "instruction.txt";
        VARIABLE text_line : line;
        VARIABLE ram_content : ram_type;
        VARIABLE read_value : STD_LOGIC_VECTOR(datain'RANGE); -- Variável auxiliar
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
    SIGNAL read_address : STD_LOGIC_VECTOR(address'RANGE);
BEGIN

    LEITURA_ESCRITA : PROCESS (clock)
    BEGIN
        -- Escrita
        IF (we = '1' AND rising_edge(clock)) THEN
            mem(to_integer(unsigned(address))) <= datain;

        ELSIF (re = '1') THEN
            dataout <= mem(to_integer(unsigned(address)));
        END IF;
    END PROCESS;

END arc_MEM;