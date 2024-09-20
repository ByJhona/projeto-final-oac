LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY processador IS
        PORT (
                clock : IN STD_LOGIC := '0';
                mem_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                opcode_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
                reg_out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                reg_out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                imm_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                ula_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        );

END processador;

ARCHITECTURE behavior OF processador IS

        COMPONENT PC
                PORT (
                        clock : IN STD_LOGIC;
                        enable : IN STD_LOGIC;
                        endereco_entrada : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        endereco_saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'));
        END COMPONENT;

        COMPONENT MUX01
                PORT (
                        selecao : IN STD_LOGIC := '0';
                        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'));
        END COMPONENT;

        COMPONENT CONTROL
                PORT (
                        clock : IN STD_LOGIC;
                        opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
                        EscrevePCCond : OUT STD_LOGIC;
                        EscrevePC : OUT STD_LOGIC;
                        IouD : OUT STD_LOGIC;
                        EscreveMem : OUT STD_LOGIC;
                        LeMem : OUT STD_LOGIC;
                        EscreveIR : OUT STD_LOGIC;
                        OrigPC : OUT STD_LOGIC;
                        ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        OrigAULA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        OrigBULA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        EscrevePCB : OUT STD_LOGIC;
                        EscreveReg : OUT STD_LOGIC;
                        Mem2Reg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
                );
        END COMPONENT;

        COMPONENT MEM
                PORT (
                        clock : IN STD_LOGIC;
                        we : IN STD_LOGIC;
                        re : IN STD_LOGIC;
                        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
                        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
        END COMPONENT;

        COMPONENT REG_INSTRUCTION
                PORT (
                        clock : IN STD_LOGIC;
                        EscreveIR : IN STD_LOGIC;
                        instrucao : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
                        rs1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
                        rs2 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
                        rd : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
                        imediato : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        controle_ULA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- rever
        END COMPONENT;

        COMPONENT XREGS
                PORT (
                        clk : IN STD_LOGIC := '0';
                        wren : IN STD_LOGIC := '0';
                        data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        rs1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
                        rs2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
                        rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
                        ro1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        ro2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'));
        END COMPONENT;

        COMPONENT MUX_AULA
                PORT (
                        OrigAULA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
                        PCback : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        RegA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        -- Saída                      
                        ULA_A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
        END COMPONENT;

        COMPONENT MUX_BULA
                PORT (
                        OrigBULA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
                        RegB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        Const_4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        Imediato : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        -- Saída                      
                        ULA_B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
        END COMPONENT;

        COMPONENT PCBack
                PORT (
                        clk : IN STD_LOGIC;
                        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        PC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
                );
        END COMPONENT;

        COMPONENT ULA_A
                PORT (
                        clk : IN STD_LOGIC;
                        ULA_A_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        ULA_A_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
        END COMPONENT;

        COMPONENT ULA_B
                PORT (
                        clk : IN STD_LOGIC;
                        ULA_B_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        ULA_B_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
        END COMPONENT;

        COMPONENT GENIMM32
                PORT (
                        instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        imm32 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
                );
        END COMPONENT;

        COMPONENT ULA
                PORT (
                        ALUOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
                        funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
                        funct7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
                        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        cond : OUT STD_LOGIC
                );
        END COMPONENT;

        -- Configuração ULA
        SIGNAL funct3 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        SIGNAL funct7 : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
        SIGNAL saida_Z_ULA : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL zero : STD_LOGIC;

        -- Configuração Gerador de Imediato
        SIGNAL saida_gerador_imm : STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- Configuração Controle

        SIGNAL endereco_entrada : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

        SIGNAL EscrevePCCond : STD_LOGIC := '0';
        SIGNAL EscrevePC : STD_LOGIC := '0';
        SIGNAL IouD : STD_LOGIC := '0';
        SIGNAL EscreveMem : STD_LOGIC := '0';
        SIGNAL proc_LeMem : STD_LOGIC := '0';
        SIGNAL EscreveIR : STD_LOGIC := '0';
        SIGNAL OrigPC : STD_LOGIC := '0';
        SIGNAL ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
        SIGNAL OrigAULA : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
        SIGNAL OrigBULA : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
        SIGNAL EscrevePCB : STD_LOGIC := '0';
        SIGNAL EscreveReg : STD_LOGIC := '0';
        SIGNAL Mem2Reg : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');

        -- Configurção REG Instruction
        SIGNAL entrada_REG_INSTRUCTION : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL opcode : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
        SIGNAL rs1 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        SIGNAL rs2 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        SIGNAL rd : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        SIGNAL saida_REG_INSTRUCTION_IMM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL controle_ULA : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'); -- rever

        -- Configuração PC
        SIGNAL enable_PC : STD_LOGIC := '0';
        SIGNAL saida_PC : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        -- Configuração PCBack
        SIGNAL saida_PCBack : STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- Configuração MUX01
        SIGNAL saida_MUX01 : STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- Configuração MEM
        SIGNAL endereco_MEM : STD_LOGIC_VECTOR(11 DOWNTO 0);
        SIGNAL entrada_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL saida_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

        -- Configuração banco de registradores
        SIGNAL saida_A_XREGS, saida_B_XREGS : STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- Configuração MUX AULA
        SIGNAL saida_MUX_AULA : STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- Configuração MUX_BULA
        SIGNAL saida_MUX_BULA : STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- Configuração reg A e B
        SIGNAL saida_A_REG, saida_B_REG : STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- Configuração GERAL
        SIGNAL address : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
        enable_PC <= (EscrevePC) OR (EscrevePCCond AND zero);

        funct7 <= saida_REG_INSTRUCTION_IMM(31 DOWNTO 25);
        funct3 <= saida_REG_INSTRUCTION_IMM(14 DOWNTO 12);

        uut_ULA : ULA PORT MAP(
                ALUOp,
                funct3,
                funct7,
                saida_MUX_AULA,
                saida_MUX_BULA,
                saida_Z_ULA,
                zero
        );

        ula_out <= saida_Z_ULA;

        uut_PC : PC PORT MAP(
                clock,
                enable_PC,
                address,
                saida_PC
        );

        uut_MUX01 : MUX01 PORT MAP(
                IouD,
                saida_PC,
                x"00000000",
                saida_MUX01
        );
        endereco_MEM <= saida_MUX01(13 DOWNTO 2);

        uut_MEM : MEM PORT MAP(
                clock,
                EscreveMem,
                proc_LeMem,
                saida_PC(13 DOWNTO 2),
                entrada_MEM,
                saida_MEM
        );

        mem_out <= saida_MEM;

        uut_GENIMM32 : GENIMM32 PORT MAP(-- Editar para outras instrucoes
                saida_REG_INSTRUCTION_IMM,
                saida_gerador_imm
        );

        imm_out <= saida_gerador_imm;

        uut_CONTROL : CONTROL PORT MAP(
                clock,
                opcode,
                EscrevePCCond => EscrevePCCond,
                EscrevePC => EscrevePC,
                IouD => IouD,
                EscreveMem => EscreveMem,
                LeMem => proc_LeMem,
                EscreveIR => EscreveIR,
                OrigPC => OrigPC,
                ALUOp => ALUOp,
                OrigAULA => OrigAULA,
                OrigBULA => OrigBULA,
                EscrevePCB => EscrevePCB,
                EscreveReg => EscreveReg,
                Mem2Reg => Mem2Reg
        );

        uut_REG_INSTRUCTION : REG_INSTRUCTION PORT MAP(
                clock,
                EscreveIR,
                saida_MEM,
                opcode,
                rs1,
                rs2,
                rd,
                saida_REG_INSTRUCTION_IMM,
                controle_ULA -- rever
        );

        opcode_out <= opcode;

        uut_XREGS : XREGS PORT MAP(
                clock,
                EscreveReg,
                x"00000000", -- DADO saida mux Mem2Reg
                rs1,
                rs2,
                rd,
                saida_A_XREGS,
                saida_B_XREGS
        );

        reg_out1 <= saida_A_XREGS;
        reg_out2 <= saida_B_XREGS;

        uut_ULA_A : ULA_A PORT MAP(
                clock,
                saida_A_XREGS,
                saida_A_REG
        );
        uut_ULA_B : ULA_B PORT MAP(
                clock,
                saida_B_XREGS,
                saida_B_REG
        );

        uut_PCBack : PCBack PORT MAP(
                clock,
                saida_PC,
                saida_PCBack
        );

        address <= saida_Z_ULA;

        uut_MUX_AULA : MUX_AULA PORT MAP(
                OrigAULA,
                saida_PCBack,
                saida_A_REG,
                saida_PC,
                -- Saída                      
                saida_MUX_AULA
        );
        uut_MUX_BULA : MUX_BULA PORT MAP(
                OrigBULA,
                saida_B_REG,
                x"00000004",
                saida_gerador_imm,
                -- Saída                      
                saida_MUX_BULA
        );

END;