LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ULA IS
    PORT (
        ALUOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
        funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        funct7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        cond : OUT STD_LOGIC
    );
END ULA;

ARCHITECTURE arc_ULA OF ULA IS
    TYPE OPERACAO IS (ADD_oper, SUB_oper, AND_oper, OR_oper, XOR_oper, SLL_oper, SRL_oper, SRA_oper, SLT_oper, SLTU_oper, SGE_oper, SGEU_oper, SEQ_oper, SNE_oper, UNDEFINED);
    SIGNAL oper : OPERACAO;
BEGIN

    DEF_OP : PROCESS (ALUOp, funct3, funct7) IS
    BEGIN
        CASE (ALUOp) IS
            WHEN "00" => oper <= ADD_oper;
            WHEN "01" => oper <= SUB_oper;
            WHEN "10" => oper <= AND_oper; -- Realizar outra operações

            WHEN OTHERS => oper <= UNDEFINED;
        END CASE;
    END PROCESS;

    MAIN : PROCESS (A, B, oper) IS
    BEGIN
        cond <= '0';

        CASE(oper) IS
            WHEN ADD_oper => Z <= STD_LOGIC_VECTOR(signed(A) + signed(B));
            WHEN SUB_oper => Z <= STD_LOGIC_VECTOR(signed(A) - signed(B));
            when others => Z <= x"00000000";
        END CASE;
    END PROCESS;

END arc_ULA;