---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
    generic(
        WORD_GRANULARITY : boolean  := False;
        DATA_BUS_WIDTH    : integer := 32;
        PC_WIDTH          : integer := 10;
        NEXT_PC_WIDTH     : integer := 8; -- NEXT_PC_WIDTH = PC_WIDTH-2
        ITCM_ADDR_WIDTH   : integer := 8;
        WORDS_NUM         : integer := 256;
        INST_CNT_WIDTH    : integer := 16
    );
    PORT(
        clk_i, rst_i      : IN  STD_LOGIC;
        -- renamed
        stall_i           : IN  STD_LOGIC;
        -- keep PCSrc + branch/jump targets per names in 2
        add_result_i      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- was PCBranch_addr_i
        JUMP_addr_i       : IN  STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0); -- was Jump_addr_i
        PCSrc_i           : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);


        -- interrupt signals per 2 (map to 1’s ISR/TYPEx)
        type_en           : IN  STD_LOGIC;                                        -- was TYPE_ctl_i
        type_address      : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);      -- was ISR_address_i (widened)

        -- outputs
        pc_o              : OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        pc_plus4_o        : OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        instruction_o     : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        inst_cnt_o        : OUT STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0)
    );
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
    SIGNAL pc_q           : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    SIGNAL pc_plus4_r     : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    SIGNAL itcm_addr_w    : STD_LOGIC_VECTOR(ITCM_ADDR_WIDTH-1 DOWNTO 0);
    SIGNAL next_pc_w      : STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
    SIGNAL branch_addr    : STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
    SIGNAL jump_addr      : STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
    SIGNAL rst_flag_q     : STD_LOGIC;
    SIGNAL inst_cnt_q     : STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
    SIGNAL pc_prev_q      : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
BEGIN

    -- ROM for Instruction Memory (same behavior as 1)
    inst_memory: altsyncram
        GENERIC MAP (
            operation_mode          => "ROM",
            width_a                 => DATA_BUS_WIDTH,
            widthad_a               => ITCM_ADDR_WIDTH,
            numwords_a              => WORDS_NUM,
            lpm_hint                => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = ITCM",
            lpm_type                => "altsyncram",
            outdata_reg_a           => "UNREGISTERED",
            init_file               =>"C:\Users\talad\OneDrive\CPU Architecture lab\Final Project CPU\sub\ITCM.hex",
            intended_device_family  => "Cyclone"
        )
        PORT MAP (
            clock0    => clk_i,
            address_a => itcm_addr_w,
            q_a       => instruction_o
        );

    -- word-aligned PC
    pc_q(1 DOWNTO 0) <= "00";

    -- address to instruction memory 
    G1:
    IF (WORD_GRANULARITY = True) GENERATE
        -- each WORD has unique address
        itcm_addr_w <= pc_q(9 DOWNTO 2) WHEN stall_i = '1' ELSE
                        next_pc_w;
    ELSIF (WORD_GRANULARITY = False) GENERATE
        -- each BYTE has unique address
        itcm_addr_w <= pc_q WHEN stall_i = '1' ELSE
                        next_pc_w & "00";
    END GENERATE;

    -- PC + 4
    pc_plus4_r(1 DOWNTO 0)               <= "00";
    pc_plus4_r(PC_WIDTH-1 DOWNTO 2)      <= pc_q(PC_WIDTH-1 DOWNTO 2) + 1;

    -- Next PC mux 
    next_pc_w <=   X"00"                                  WHEN rst_flag_q = '1' ELSE
                   type_address(NEXT_PC_WIDTH-1 DOWNTO 0) WHEN type_en    = '1' ELSE
                   add_result_i                           WHEN PCSrc_i    = "01" ELSE   -- branch
                   JUMP_addr_i                            WHEN PCSrc_i    = "10" ELSE   -- jump
                   pc_plus4_r(PC_WIDTH-1 DOWNTO 2);

    -- rst flag FF 
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            rst_flag_q <= rst_i;
        end if;
    end process;

    -- PC register
    PROCESS (clk_i, rst_i)
    BEGIN
        IF rst_i = '1' THEN
            pc_q(PC_WIDTH-1 DOWNTO 2) <= (OTHERS => '0');
        ELSIF rising_edge(clk_i) AND (stall_i = '0') THEN -- if we dont have stall PC_next <= PC+4
            pc_q(PC_WIDTH-1 DOWNTO 2) <= next_pc_w;
        END IF;
    END PROCESS;

    -- IPC helper FF 
    process (clk_i, rst_i)
    begin
        if rst_i = '1' then
            pc_prev_q <= (others => '0');
        elsif falling_edge(clk_i) then
            pc_prev_q <= pc_q;
        end if;
    end process;

    -- instruction counter 
    process (clk_i, rst_i)
    begin
        if rst_i = '1' then
            inst_cnt_q <= (others => '0');
        elsif rising_edge(clk_i) then
            if pc_prev_q = pc_q then
                inst_cnt_q <= inst_cnt_q + '1';
            end if;
        end if;
    end process;

    -- outputs 
    pc_o         <= pc_q;
    pc_plus4_o   <= pc_plus4_r;
    inst_cnt_o   <= inst_cnt_q;

END behavior;
