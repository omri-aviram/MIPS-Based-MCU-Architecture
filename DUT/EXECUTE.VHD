---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.aux_package.all;
USE work.const_package.all;

ENTITY Execute IS
  generic(
    DATA_BUS_WIDTH : integer := 32;
    FUNCT_WIDTH    : integer := 6;
    PC_WIDTH       : integer := 10;
    k              : integer := 5   -- log2(DATA_BUS_WIDTH) for shifter
  );
  PORT(
    -- inputs
    read_data1_i                      : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    read_data2_i                      : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    funct_i                           : IN  STD_LOGIC_VECTOR(FUNCT_WIDTH-1  DOWNTO 0);
    ALUOp_ctrl_i                      : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- 3-bit 
    Alusrc_i                          : IN  STD_LOGIC;
    pc_plus4_i                        : IN  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    instruction_i                     : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    RegDst_ctrl_i                     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- forwarding + immediates
    ReadData1_MUX_i, ReadData2_MUX_i  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    alu_res_DM_i                      : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);  -- from MEM
    RF_WriteData_WB_i                 : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);  -- from WB
    sign_extend_i                     : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

    -- outputs
    zero_o                            : OUT STD_LOGIC;
    alu_res_o                         : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    WriteDataEx_o                     : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    write_reg_addr_o                  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
  );
END Execute;

ARCHITECTURE behavior OF Execute IS
  -- internal sources after forwarding
  SIGNAL srcA_w, srcB_w          : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL srcB_fwd_w              : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

  -- ALU control 
  SIGNAL alu_code_r_w            : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL alu_code_i_w            : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL alu_code_w              : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -- shifter
  SIGNAL shift_result_w          : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL do_shift                : STD_LOGIC;

  -- ALU datapath
  SIGNAL alu_out_w               : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

  -- fields
  SIGNAL rd_w, rt_w              : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
  ---------------------------------------------------------------------------
  -- Register destination select
  ---------------------------------------------------------------------------
  rd_w <= instruction_i(15 downto 11);
  rt_w <= instruction_i(20 downto 16);

  write_reg_addr_o <= "11111"     WHEN RegDst_ctrl_i = "10" ELSE  -- JAL
                      rd_w        WHEN RegDst_ctrl_i = "01" ELSE  -- R-type / MUL
                      "11011"     WHEN RegDst_ctrl_i = "11" ELSE  -- EPC
                      rt_w;                                      -- default

  ---------------------------------------------------------------------------
  -- Forwarding
  ---------------------------------------------------------------------------
  WITH ReadData1_MUX_i SELECT
    srcA_w <= read_data1_i      WHEN "00",
              RF_WriteData_WB_i WHEN "01",
              alu_res_DM_i      WHEN "10",
              X"00000000"       WHEN OTHERS;

  WITH ReadData2_MUX_i SELECT
    srcB_fwd_w <= read_data2_i      WHEN "00",
                  RF_WriteData_WB_i WHEN "01",
                  alu_res_DM_i      WHEN "10",
                  X"00000000"       WHEN OTHERS;

  -- expose forwarded B as store data
  WriteDataEx_o <= srcB_fwd_w;

  ---------------------------------------------------------------------------
  -- B input select 
  ---------------------------------------------------------------------------
  srcB_w <= srcB_fwd_w                               WHEN (Alusrc_i='0' AND funct_i /= "001000") ELSE
            (others => '0')                          WHEN (Alusrc_i='0' AND funct_i  = "001000") ELSE
            sign_extend_i;


  shifter_ports : Shifter
    GENERIC MAP (DATA_BUS_WIDTH, k)
    PORT MAP (
      srcB_fwd_w,                  -- Y_in (data to shift)
      sign_extend_i(10 downto 6),  -- X_in (shamt)
      funct_i,                     -- op   (6-bit funct)
      shift_result_w               -- result
    );

  ---------------------------------------------------------------------------
  -- ALU control generation 
  ---------------------------------------------------------------------------
  do_shift <= '1' WHEN ((funct_i = "000000") OR ((funct_i = "000010") AND (ALUOp_ctrl_i(2) = '0')))
             ELSE '0';

  -- R-type path
  alu_code_r_w(0) <= ((not do_shift) AND ((funct_i(0) OR funct_i(3)) AND ALUOp_ctrl_i(1))) OR do_shift;
  alu_code_r_w(1) <= ((not do_shift) AND ((not ALUOp_ctrl_i(1)) OR ((not funct_i(2)) AND (not ALUOp_ctrl_i(0))))) OR '0';
  alu_code_r_w(2) <= ((not do_shift) AND (((not ALUOp_ctrl_i(1)) AND ALUOp_ctrl_i(0)) OR funct_i(1))) OR do_shift;
  alu_code_r_w(3) <= ((not do_shift) AND (funct_i(1) AND ALUOp_ctrl_i(2))) OR '0';

  -- I-type path
  alu_code_i_w(0) <= ALUOp_ctrl_i(0);
  alu_code_i_w(1) <= ALUOp_ctrl_i(1);
  alu_code_i_w(2) <= ALUOp_ctrl_i(2);
  alu_code_i_w(3) <= '1';

  -- choose by immediate source control
  alu_code_w <= alu_code_i_w WHEN Alusrc_i = '1' ELSE alu_code_r_w;

  ---------------------------------------------------------------------------
  -- Flags
  ---------------------------------------------------------------------------
  zero_o <= '1' WHEN (alu_out_w = X"00000000") ELSE '0';

  ---------------------------------------------------------------------------
  -- Result mux (SLT/SLTI place sign in bit0)
  ---------------------------------------------------------------------------
  alu_res_o <= X"0000000" & B"000" & alu_out_w(31)      -- SLT / SLTI
               WHEN (alu_code_w = "0111" OR alu_code_w = "1101")
               ELSE alu_out_w;

  ---------------------------------------------------------------------------
  -- ALU proper
  ---------------------------------------------------------------------------
  PROCESS (alu_code_w, srcA_w, srcB_w, shift_result_w)
  BEGIN
    CASE alu_code_w IS
      -- R-type
      WHEN "0000" => alu_out_w <= srcA_w AND srcB_w;                        -- AND
      WHEN "0001" => alu_out_w <= srcA_w OR  srcB_w;                        -- OR
      WHEN "0010" => alu_out_w <= srcA_w +  srcB_w;                         -- ADD
      WHEN "0011" => alu_out_w <= unsigned(srcA_w) + unsigned(srcB_w);      -- ADDU
      WHEN "0100" => alu_out_w <= srcA_w xor srcB_w;                        -- XOR
      WHEN "0101" => alu_out_w <= shift_result_w;                           -- SHIFT (sll/srl)
      WHEN "0110" => alu_out_w <= srcA_w -  srcB_w;                         -- SUB / beq,bne compare
      WHEN "0111" => alu_out_w <= srcA_w -  srcB_w;                         -- SLT via subtract
      WHEN "1110" => alu_out_w <= srcA_w(15 downto 0) * srcB_w(15 downto 0);-- 16x16 MUL (if used)

      -- I-type
      WHEN "1000" => alu_out_w <= srcA_w +  srcB_w;                         -- addi / lw / sw
      WHEN "1001" => alu_out_w <= srcA_w OR  srcB_w;                        -- ori
      WHEN "1010" => alu_out_w <= srcA_w AND srcB_w;                        -- andi
      WHEN "1011" => alu_out_w <= srcA_w xor srcB_w;                        -- xori
      WHEN "1100" => alu_out_w <= srcB_w(15 downto 0) & (15 downto 0 => '0');-- lui
      WHEN "1101" => alu_out_w <= srcA_w -  srcB_w;                         -- slti via subtract

      WHEN OTHERS => alu_out_w <= X"00000000";
    END CASE;
  END PROCESS;
END behavior;
