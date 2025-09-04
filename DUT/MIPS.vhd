---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;

ENTITY MIPS IS
  generic(
    WORD_GRANULARITY : boolean := G_WORD_GRANULARITY;
    MODELSIM         : integer := G_MODELSIM;
    DATA_BUS_WIDTH   : integer := 32;
    ITCM_ADDR_WIDTH  : integer := G_ADDRWIDTH;
    DTCM_ADDR_WIDTH  : integer := G_ADDRWIDTH;
    PC_WIDTH         : integer := 10;
    FUNCT_WIDTH      : integer := 6;
    DATA_WORDS_NUM   : integer := G_DATA_WORDS_NUM;
    CLK_CNT_WIDTH    : integer := 16;
    INST_CNT_WIDTH   : integer := 16
  );
  PORT(
    rst_i            : IN    STD_LOGIC;
    clk_i            : IN    STD_LOGIC;
    SW_i             : IN    STD_LOGIC_VECTOR(9 DOWNTO 0);
    Data_io          : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    IFpc_o           : OUT   STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    IDinstruction_o  : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    MemRead_o        : OUT   STD_LOGIC;
    MemWrite_o       : OUT   STD_LOGIC;
    EX_ALU_result_o  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
    MEM_ALU_result_o : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
    GIE_o            : OUT   STD_LOGIC;
    INTR_i           : IN    STD_LOGIC;
    Key_reset        : OUT   STD_LOGIC;
    INTA             : OUT   STD_LOGIC;
    break_flag_o     : OUT   STD_LOGIC
  );
END MIPS;

ARCHITECTURE structure OF MIPS IS
  -- Core datapath/control signals
  SIGNAL pc_plus4_w       : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
  SIGNAL read_data1_w     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL read_data2_w     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL sign_extend_w    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL alu_result_w     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL dtcm_data_rd_w   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL alu_src_w        : STD_LOGIC;
  SIGNAL branch_w         : STD_LOGIC;
  SIGNAL jmp_w            : STD_LOGIC;
  SIGNAL reg_dst_w        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL reg_write_w      : STD_LOGIC;
  SIGNAL zero_w           : STD_LOGIC;
  SIGNAL mem_write_w      : STD_LOGIC;
  SIGNAL MemtoReg_w       : STD_LOGIC;
  SIGNAL mem_read_w       : STD_LOGIC;
  SIGNAL alu_op_w         : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL instruction_w    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
  SIGNAL mclk_cnt_q       : STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
  SIGNAL inst_cnt_w       : STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
  SIGNAL TYPE_ctl_w       : STD_LOGIC;
  signal BPADD_ena 		  : std_logic;

  -- Control pipeline regs
  SIGNAL MemtoReg_WB, MemtoReg_MEM, MemtoReg_EX, MemtoReg_ID : STD_LOGIC;
  SIGNAL RegWrite_WB, RegWrite_MEM, RegWrite_EX, RegWrite_ID : STD_LOGIC;
  SIGNAL Jal_WB, Jal_MEM, Jal_EX, Jal_ID                     : STD_LOGIC;

  SIGNAL Zero_MEM, Zero_EX                                   : STD_LOGIC;
  SIGNAL Branch_MEM, Branch_EX, Branch_ID                    : STD_LOGIC;
  SIGNAL MemWrite_MEM, MemWrite_EX, MemWrite_ID              : STD_LOGIC;
  SIGNAL MemRead_MEM, MemRead_EX, MemRead_ID                 : STD_LOGIC;
  SIGNAL BranchBeq_MEM, BranchBeq_EX, BranchBeq_ID           : STD_LOGIC;
  SIGNAL BranchBne_MEM, BranchBne_EX, BranchBne_ID           : STD_LOGIC;
  SIGNAL Jump_MEM,  Jump_EX,  Jump_ID                        : STD_LOGIC;

  -- Forwarding (ALU) and comparator forwarding
  SIGNAL ForwardA, ForwardB                                  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL ForwardA_ID, ForwardB_ID                            : STD_LOGIC;

  -- Exec controls
  SIGNAL RegDst_EX, RegDst_ID                                : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL ALUSrc_EX, ALUSrc_ID                                : STD_LOGIC;
  SIGNAL ALUOp_EX, ALUOp_ID                                  : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -- Hazards
  SIGNAL Stall_IF, Stall_ID, Flush_EX                        : STD_LOGIC;

  -- IF/ID PCSrc
  SIGNAL PCSrc_ID                                            : STD_LOGIC_VECTOR(1 DOWNTO 0);

  -- Interrupts
  SIGNAL intr_flush_w                                        : STD_LOGIC;
  SIGNAL epc                                                 : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL EPC_EN_s                                            : STD_LOGIC;
  SIGNAL int_req_o_w                                         : STD_LOGIC;  -- was K0_0_w

  -- MCU / external bus
  SIGNAL En_CORE2BUS                                         : STD_LOGIC;
  SIGNAL Din                                                 : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -- Stage registers/signals
  -- IF
  SIGNAL PC_plus_4_IF                                        : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL IR_IF                                               : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL pc_IF                                               : STD_LOGIC_VECTOR(9 DOWNTO 0);

  -- ID
  SIGNAL PC_plus_4_ID                                        : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL IR_ID_i                                             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL read_data_1_ID, read_data_2_ID                      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Sign_extend_ID                                      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PCBranch_addr_ID_old                                : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL JumpAddr_ID_old                                     : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL IR_ID_o                                             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL pc_ID                                               : STD_LOGIC_VECTOR(9 DOWNTO 0);

  -- Correct-name versions from Idecode
  SIGNAL addr_res_ID                                         : STD_LOGIC_VECTOR(PC_WIDTH-3 DOWNTO 0); 
  SIGNAL Jump_addr_select_ID                                 : STD_LOGIC_VECTOR(PC_WIDTH-3 DOWNTO 0); 

  -- EX
  SIGNAL PC_plus_4_EX                                        : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL IR_EX                                               : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL read_data_1_EX, read_data_2_EX                      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Sign_extend_EX                                      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Wr_reg_addr_EX                                      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL write_data_EX                                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Add_Result_EX                                       : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ALU_Result_EX                                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Opcode_EX                                           : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL pc_EX                                               : STD_LOGIC_VECTOR(9 DOWNTO 0);

  -- MEM
  SIGNAL PC_plus_4_MEM                                       : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL Add_Result_MEM                                      : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ALU_Result_MEM_i                                    : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ALU_Result_MEM_o                                    : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL write_data_MEM, read_data_MEM                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Wr_reg_addr_MEM                                     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL JumpAddr_MEM                                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL IR_MEM                                              : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL pc_MEM                                              : STD_LOGIC_VECTOR(9 DOWNTO 0);

  -- WB
  SIGNAL PC_plus_4_WB                                        : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL read_data_WB                                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ALU_Result_WB                                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Wr_reg_addr_WB                                      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL write_data_WB                                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL write_data_mux_WB                                   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dtcm_data_rd_WB                                     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL IR_WB                                               : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL pc_WB                                               : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN
  -- Visibility
  IFpc_o          <= pc_IF;
  IDinstruction_o <= IR_ID_i;

  -------------- CPU <-> MCU --------------
  En_CORE2BUS <= '1' WHEN (MemWrite_MEM = '1' AND ALU_Result_MEM_i(11) = '1') ELSE '0';
  CORE2BUS: BidirPin
    generic map (width => 32)
    port map (
      Dout  => write_data_MEM,
      EN    => En_CORE2BUS,
      Din   => Din,
      IOpin => Data_io
    );

  MemRead_o        <= MemRead_MEM;
  MemWrite_o       <= MemWrite_MEM;
  EX_ALU_result_o  <= ALU_Result_EX;
  MEM_ALU_result_o <= ALU_Result_MEM_i;

  -------------------- IFETCH --------------------
  IFE : Ifetch
    generic map(
      WORD_GRANULARITY => WORD_GRANULARITY,
      DATA_BUS_WIDTH   => DATA_BUS_WIDTH,
      PC_WIDTH         => PC_WIDTH,
      ITCM_ADDR_WIDTH  => ITCM_ADDR_WIDTH,
      WORDS_NUM        => DATA_WORDS_NUM,
      INST_CNT_WIDTH   => INST_CNT_WIDTH
    )
    PORT MAP(
      clk_i            => clk_i,
      rst_i            => rst_i,
      stall_i          => Stall_IF,                        
      PCSrc_i          => PCSrc_ID,
      JUMP_addr_i      => Jump_addr_select_ID,             
      add_result_i     => addr_res_ID,                     
      instruction_o    => IR_IF,
      pc_o             => pc_IF,
      pc_plus4_o       => PC_plus_4_IF,
      inst_cnt_o       => inst_cnt_w,
      type_en          => TYPE_ctl_w,                       
      type_address     => (31 DOWNTO 8 => '0') & read_data_MEM(9 DOWNTO 2)
    );

  -------------------- IDECODE --------------------
  ID : Idecode
    generic map(
      DATA_BUS_WIDTH => DATA_BUS_WIDTH
    )
    PORT MAP(
      clk_i                 => clk_i,
      rst_i                 => rst_i,
      instruction_i         => IR_ID_i,
      dtcm_data_rd_i        => dtcm_data_rd_WB,
      ALU_Result_DM_i       => ALU_Result_WB,               
      RegWrite_ctrl_i       => RegWrite_WB,
      MemtoReg_ctrl_i       => MemtoReg_WB,
      JAL_ctrl_i            => Jal_WB,
      pc_plus4_i            => PC_plus_4_ID,
      pc_plus4_WB_i         => PC_plus_4_WB,
      stall_i               => Stall_ID,                    
      ForwardA_ID           => ForwardA_ID,
      ForwardB_ID           => ForwardB_ID,
      Branch_FW_i           => ALU_Result_MEM_o,
      write_reg_addr_i      => Wr_reg_addr_WB,              
      read_data1_MUXdata_o  => read_data_1_ID,              
      read_data2_MUXdata_o  => read_data_2_ID,              
      sign_extend_o         => Sign_extend_ID,
      Jump_addr_select_o    => Jump_addr_select_ID,         
      addr_res_o            => addr_res_ID,                 
      PCSrc_o               => PCSrc_ID,
      instruction_o         => IR_ID_o,
      int_req_o             => int_req_o_w,                 
      write_data_o          => write_data_WB
    );

  -------------------- CONTROL --------------------
  CTL : control
    PORT MAP(
      clk_i          	=> clk_i,
	  reset_tb			=> rst_i,
      opcode_i       	=> IR_ID_i(DATA_BUS_WIDTH-1 DOWNTO 26),
      instruction_i  	=> IR_ID_i,
      RegDst_ctrl_o  	=> RegDst_ID,
      ALUSrc_ctrl_o  	=> ALUSrc_ID,
      MemtoReg_ctrl_o	=> MemtoReg_ID,
      RegWrite_ctrl_o	=> RegWrite_ID,
      MemRead_ctrl_o 	=> MemRead_ID,
      MemWrite_ctrl_o	=> MemWrite_ID,
	  Branch_ctrl_o 	=> branch_w,
      BEQctrl_o      	=> BranchBeq_ID,                       
      BNEctrl_o      	=> BranchBne_ID,                       
      jumpctrl_o     	=> jmp_w,                              
      ALUOp_ctrl_o   	=> ALUOp_ID,                           
      INTA           	=> INTA,                               
      GIE            	=> GIE_o,                              
      EPC_ctl_o      	=> EPC_EN_s,                           
      flush_intr_o   	=> intr_flush_w,                       
      int_req_o      	=> int_req_o_w,                        
      INTR           	=> INTR_i,                             
      type_address   	=> Din(7 DOWNTO 0),                    
      type_en        	=> TYPE_ctl_w,                         
      Key_reset_o    	=> Key_reset
    );

  -------------------- EXECUTE --------------------
  EXE : Execute
    generic map(
      DATA_BUS_WIDTH => DATA_BUS_WIDTH,
      FUNCT_WIDTH    => FUNCT_WIDTH,
      PC_WIDTH       => PC_WIDTH
    )
    PORT MAP(
      read_data1_i      => read_data_1_EX,
      read_data2_i      => read_data_2_EX,
      funct_i           => Sign_extend_EX(5 DOWNTO 0),
      ALUOp_ctrl_i      => ALUOp_EX,
      Alusrc_i          => ALUSrc_EX,                        
      pc_plus4_i        => PC_plus_4_EX,
      instruction_i     => IR_EX,
      RegDst_ctrl_i     => RegDst_EX,
      ReadData1_MUX_i   => ForwardA,                         
      ReadData2_MUX_i   => ForwardB,                         
      alu_res_DM_i      => ALU_Result_MEM_o,                 
      RF_WriteData_WB_i => write_data_WB,                    
      sign_extend_i     => Sign_extend_EX,
      zero_o            => Zero_EX,
      alu_res_o         => ALU_Result_EX,
      WriteDataEx_o     => write_data_EX,                    
      write_reg_addr_o  => Wr_reg_addr_EX                    
    );

  -------------------- HAZARD & FORWARDING ------------------------
  HAZ : HazardAndForwarding
    PORT MAP(
      -- Forwarding sources/regs
      Rs_Reg_ID_i           => IR_ID_i(25 DOWNTO 21),        
      Rt_Reg_ID_i           => IR_ID_i(20 DOWNTO 16),        
      Rs_Reg_EX_i           => IR_EX(25 DOWNTO 21),          
      Rt_Reg_EX_i           => IR_EX(20 DOWNTO 16),          
      write_reg_addr_EX_i   => Wr_reg_addr_EX,               
      write_reg_addr_DM_i   => Wr_reg_addr_MEM,              
      write_reg_addr_WB_i   => Wr_reg_addr_WB,               
      RegWrite_EX_i         => RegWrite_EX,                  
      RegWrite_DM_i         => RegWrite_MEM,                 
      RegWrite_WB_i         => RegWrite_WB,                  

      -- ALU forwarding outputs
      ALU_A_MUX_o           => ForwardA,                     
      ALU_B_MUX_o           => ForwardB,                     

      -- Hazards
      MemtoReg_EX_i         => MemtoReg_EX,                  
      MemtoReg_DM_i         => MemtoReg_MEM,                 
      BEQ_ID_i              => BranchBeq_ID,                 
      BNE_ID_i              => BranchBne_ID,                 

      -- Stalls/flush
      Stall_IF              => Stall_IF,
      Stall_ID              => Stall_ID,
      Flush_EX              => Flush_EX,
	  ForwardA_Branch 		=> ForwardA_ID,
	  ForwardB_Branch		=> ForwardB_ID				
	);
      

  -------------------- DMEMORY --------------------
  G1:
  IF (WORD_GRANULARITY = True) GENERATE
    MEM: dmemory
      generic map(
        DATA_BUS_WIDTH  => DATA_BUS_WIDTH,
        DTCM_ADDR_WIDTH => DTCM_ADDR_WIDTH,
        WORDS_NUM       => DATA_WORDS_NUM
      )
      PORT MAP(
        clk_i           => clk_i,
        rst_i           => rst_i,
        dtcm_addr_i     => ALU_Result_MEM_i((DTCM_ADDR_WIDTH+2)-1 DOWNTO 2),
        dtcm_data_wr_i  => write_data_MEM,
        MemRead_ctrl_i  => MemRead_MEM,
        MemWrite_ctrl_i => MemWrite_MEM,
        ALU_Result_i    => ALU_Result_MEM_i,
        dtcm_data_rd_o  => read_data_MEM,
        ALU_Result_o    => ALU_Result_MEM_o,
        TYPE_addr_i     => Din(7 DOWNTO 0),
        DATA_IO         => Data_io,                       
        type_en         => TYPE_ctl_w                     
      );
  ELSIF (WORD_GRANULARITY = False) GENERATE
    MEM: dmemory
      generic map(
        DATA_BUS_WIDTH  => DATA_BUS_WIDTH,
        DTCM_ADDR_WIDTH => DTCM_ADDR_WIDTH,
        WORDS_NUM       => DATA_WORDS_NUM
      )
      PORT MAP(
        clk_i           => clk_i,
        rst_i           => rst_i,
        dtcm_addr_i     => ALU_Result_MEM_i(DTCM_ADDR_WIDTH-1 DOWNTO 2) & "00",
        dtcm_data_wr_i  => write_data_MEM,
        MemRead_ctrl_i  => MemRead_MEM,
        MemWrite_ctrl_i => MemWrite_MEM,
        dtcm_data_rd_o  => read_data_MEM,
        ALU_Result_i    => ALU_Result_MEM_i,
        ALU_Result_o    => ALU_Result_MEM_o,                  
        DATA_IO         => Data_io,                           
        type_en         => TYPE_ctl_w,                        
        TYPE_addr_i     => Din(7 DOWNTO 0)                    
      );
  END GENERATE;

  ---------------------------------------------------------------------------------------
  -- IPC / counters and pipeline registers 
  ---------------------------------------------------------------------------------------
  process (clk_i , rst_i)
  begin
    if rst_i = '1' then
      mclk_cnt_q <= (others => '0');
    elsif rising_edge(clk_i) then
      mclk_cnt_q <= mclk_cnt_q + '1';
    end if;
  end process;

  BPADD_ena    <= '1' WHEN (SW_i = pc_IF(9 downto 2)) AND (SW_i /= X"00") ELSE '0';
  break_flag_o <= BPADD_ena;

  EPC_REG: PROCESS (clk_i)
  BEGIN
    IF rising_edge(clk_i) THEN
      IF rst_i = '1' THEN
        epc <= (OTHERS => '0');
      ELSIF (PC_plus_4_EX /= 0 AND Jump_EX = '0' AND EPC_EN_s = '1') THEN
        epc <= PC_plus_4_EX;
      END IF;
    END IF;
  END PROCESS;

  PROCESS (clk_i , Stall_ID, Flush_EX)
  BEGIN
    IF clk_i'EVENT AND clk_i = '1' THEN
      -- IF -> ID
      IF Stall_ID = '0' THEN
        PC_plus_4_ID <= PC_plus_4_IF;
        IR_ID_i      <= IR_IF;
        pc_ID        <= pc_IF;
      END IF;
      IF (PCSrc_ID(0) = '1' OR PCSrc_ID(1) = '1' OR intr_flush_w = '1') THEN
        PC_plus_4_ID <= (others => '0');
        IR_ID_i      <= (others => '0');
        pc_ID        <= (others => '0');
      END IF;

      -- ID -> EX
      IF Flush_EX = '1' THEN
        -- Control Regs
        Branch_EX     <= '0';
        MemtoReg_EX   <= '0';
        RegWrite_EX   <= '0';
        MemWrite_EX   <= '0';
        MemRead_EX    <= '0';
        RegDst_EX     <= "00";
        ALUSrc_EX     <= '0';
        ALUOp_EX      <= "000";
        Opcode_EX     <= "000000";
        BranchBeq_EX  <= '0';
        BranchBne_EX  <= '0';
        Jump_EX       <= '0';
        Jal_EX        <= '0';
        -- State Regs
        PC_plus_4_EX  <= (others => '0');
        IR_EX         <= (others => '0');
        pc_EX         <= (others => '0');
        read_data_1_EX<= (others => '0');
        read_data_2_EX<= (others => '0');
        Sign_extend_EX<= (others => '0');
      ELSE
        -- Control Regs (as in 1)
        Jump_EX       <= PCSrc_ID(1);
        Branch_EX     <= Branch_ID;
        MemtoReg_EX   <= MemtoReg_ID;
        RegWrite_EX   <= RegWrite_ID;
        MemWrite_EX   <= MemWrite_ID;
        MemRead_EX    <= MemRead_ID;
        RegDst_EX     <= RegDst_ID;
        ALUSrc_EX     <= ALUSrc_ID;
        ALUOp_EX      <= ALUOp_ID;
        Opcode_EX     <= IR_ID_o(31 DOWNTO 26);
        BranchBeq_EX  <= BranchBeq_ID;
        BranchBne_EX  <= BranchBne_ID;
        Jal_EX        <= RegDst_ID(1);
        -- State Regs
        PC_plus_4_EX  <= PC_plus_4_ID;
        IR_EX         <= IR_ID_o;
        pc_EX         <= pc_ID;
        read_data_1_EX<= read_data_1_ID;
        read_data_2_EX<= read_data_2_ID;
        Sign_extend_EX<= Sign_extend_ID;
      END IF;

      -- EX -> MEM
      Branch_MEM      <= Branch_EX;
      Zero_MEM        <= Zero_EX;
      MemtoReg_MEM    <= MemtoReg_EX;
      RegWrite_MEM    <= RegWrite_EX;
      MemWrite_MEM    <= MemWrite_EX;
      MemRead_MEM     <= MemRead_EX;
      BranchBeq_MEM   <= BranchBeq_EX;
      BranchBne_MEM   <= BranchBne_EX;
      Jal_MEM         <= Jal_EX;

      IF RegDst_EX = "11" THEN
        PC_plus_4_MEM <= epc;
      ELSE
        PC_plus_4_MEM <= PC_plus_4_EX;
      END IF;
      ALU_Result_MEM_i<= ALU_Result_EX;
      write_data_MEM  <= write_data_EX;
      Wr_reg_addr_MEM <= Wr_reg_addr_EX;
      IR_MEM          <= IR_EX;
      pc_MEM          <= pc_EX;

      -------instead of WB module--------
	  -- MEM -> WB
      MemtoReg_WB     <= MemtoReg_MEM;
      RegWrite_WB     <= RegWrite_MEM;
      Jal_WB          <= Jal_MEM;

      PC_plus_4_WB    <= PC_plus_4_MEM;
      dtcm_data_rd_WB <= read_data_MEM;
      ALU_Result_WB   <= ALU_Result_MEM_o;
      Wr_reg_addr_WB  <= Wr_reg_addr_MEM;
      IR_WB           <= IR_MEM;
      pc_WB           <= pc_MEM;
    END IF;
  END PROCESS;

END structure;
