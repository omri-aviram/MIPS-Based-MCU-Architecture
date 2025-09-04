---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
  generic(
    DATA_BUS_WIDTH : integer := 32;                             
    PC_WIDTH       : integer := 10                              
  );
  PORT(
    clk_i, rst_i                      : IN  STD_LOGIC;                                             
    instruction_i                     : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);           
    dtcm_data_rd_i                    : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);           
    ALU_Result_DM_i                   : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);           
    RegWrite_ctrl_i                   : IN  STD_LOGIC;                                             
    MemtoReg_ctrl_i                   : IN  STD_LOGIC;                                             
    JAL_ctrl_i                        : IN  STD_LOGIC;                                             
    pc_plus4_i                        : IN  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);                 
    pc_plus4_WB_i                     : IN  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);                 
    stall_i                           : IN  STD_LOGIC;                                             
    ForwardA_ID                       : IN  STD_LOGIC;                                             
    ForwardB_ID                       : IN  STD_LOGIC;                                             
    Branch_FW_i                       : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);           
    write_reg_addr_i                  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);                          

    read_data1_MUXdata_o              : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);           
    read_data2_MUXdata_o              : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);           
    sign_extend_o                     : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);           
    Jump_addr_select_o                : OUT STD_LOGIC_VECTOR(PC_WIDTH-3 DOWNTO 0);                 
    addr_res_o                        : OUT STD_LOGIC_VECTOR(PC_WIDTH-3 DOWNTO 0);                 
    PCSrc_o                           : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);                          
    instruction_o                     : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);           
    int_req_o                         : OUT STD_LOGIC;                                             
    write_data_o                      : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)            
  );
END Idecode;

ARCHITECTURE behavior OF Idecode IS
  TYPE register_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL RF_q              : register_file;
  SIGNAL write_reg_addr_w  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL write_reg_data_w  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL rs_register_w     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL rt_register_w     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL rd_register_w     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL imm_value_w       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL Sign_extend_w     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL read_data1_w      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL read_data2_w      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Opcode_w          : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL Jump_addr_w       : STD_LOGIC_VECTOR(PC_WIDTH-3 DOWNTO 0);  -- generalized from 8 bits
  SIGNAL PCBranch_addr_w   : STD_LOGIC_VECTOR(PC_WIDTH-3 DOWNTO 0);  -- generalized from 8 bits
BEGIN
  --------------------------------------------------------------------
  -- Field decode
  --------------------------------------------------------------------
  rs_register_w   <= instruction_i(25 DOWNTO 21);
  rt_register_w   <= instruction_i(20 DOWNTO 16);
  rd_register_w   <= instruction_i(15 DOWNTO 11);
  imm_value_w     <= instruction_i(15 DOWNTO 0);
  Opcode_w        <= instruction_i(31 DOWNTO 26);
  instruction_o   <= instruction_i;

  --------------------------------------------------------------------
  -- Register reads with simple branch-forwarding selects 
  --------------------------------------------------------------------
  read_data1_w <= RF_q(CONV_INTEGER(rs_register_w)) WHEN ForwardA_ID = '0' ELSE Branch_FW_i;
  read_data2_w <= RF_q(CONV_INTEGER(rt_register_w)) WHEN ForwardB_ID = '0' ELSE Branch_FW_i;

  read_data1_MUXdata_o <= read_data1_w;  
  read_data2_MUXdata_o <= read_data2_w;  

  --------------------------------------------------------------------
  -- Write-back select with WB mux
  --------------------------------------------------------------------
  write_reg_addr_w <= write_reg_addr_i; 

  write_reg_data_w <= X"000000" & pc_plus4_WB_i(PC_WIDTH-1 DOWNTO 2) WHEN JAL_ctrl_i = '1' ELSE
                      ALU_Result_DM_i(DATA_BUS_WIDTH-1 DOWNTO 0)     WHEN (MemtoReg_ctrl_i = '0') ELSE
                      dtcm_data_rd_i;

  write_data_o <= write_reg_data_w; 

  --------------------------------------------------------------------
  -- Sign extend immediate
  --------------------------------------------------------------------
  Sign_extend_w <= X"0000" & imm_value_w WHEN imm_value_w(15) = '0' ELSE X"FFFF" & imm_value_w;
  sign_extend_o <= Sign_extend_w;

  --------------------------------------------------------------------
  -- Branch & Jump address calc 
  --------------------------------------------------------------------
  PCBranch_addr_w <= pc_plus4_i(PC_WIDTH-1 DOWNTO 2) + Sign_extend_w(PC_WIDTH-3 DOWNTO 0);
  Jump_addr_w     <= Sign_extend_w(PC_WIDTH-3 DOWNTO 0) WHEN Opcode_w(1 DOWNTO 0) = "10" OR Opcode_w(1 DOWNTO 0) = "11"
                     ELSE read_data1_w(PC_WIDTH-3 DOWNTO 0); -- JR

  addr_res_o         <= PCBranch_addr_w; 
  Jump_addr_select_o <= Jump_addr_w;     

 int_req_o <= RF_q(26)(0); -- Global interrupt enable - 0 when we have reset and turns to 1 at the next cycle

  --------------------------------------------------------------------
  -- PCSrc 
  --------------------------------------------------------------------
  PCSrc_o(1) <= '1' WHEN instruction_i(31 DOWNTO 26) = "000010" OR  -- JMP
                        instruction_i(31 DOWNTO 26) = "000011" OR  -- JAL
                        (instruction_i(31 DOWNTO 26) = "000000" AND instruction_i(5 DOWNTO 0) = "001000")  -- JR
                ELSE '0';

  PCSrc_o(0) <= '1' WHEN (((read_data1_w = read_data2_w) AND stall_i = '0') AND instruction_i(31 DOWNTO 26) = "000100") OR -- BEQ
                        (((read_data1_w /= read_data2_w) AND stall_i = '0') AND instruction_i(31 DOWNTO 26) = "000101")    -- BNE
                ELSE '0';

  --------------------------------------------------------------------
  -- Register file write on falling edge
  --------------------------------------------------------------------
  process(clk_i, rst_i)
  begin
    if (rst_i = '1') then
      for i in 0 to 31 loop
        RF_q(i) <= CONV_STD_LOGIC_VECTOR(0, 32);
      end loop;
    elsif (clk_i'event and clk_i = '0') then
      if (RegWrite_ctrl_i = '1' AND write_reg_addr_w /= 0) then
        RF_q(CONV_INTEGER(write_reg_addr_w)) <= write_reg_data_w;
      end if;
    end if;
  end process;
END behavior;
