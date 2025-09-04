---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669

library IEEE;
use ieee.std_logic_1164.all;
USE work.cond_comilation_package.all;
USE work.FIR_package.all;

package aux_package is

component MIPS IS
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
end component;
---------------------------------------------------------	
component dmemory is
	generic(
    DATA_BUS_WIDTH  : integer := 32; 
    DTCM_ADDR_WIDTH : integer := 11;  -- 11 bits to address 0x0–0x7FF
    WORDS_NUM       : integer := 2048 -- 0x800 words
	);
  PORT(
    clk_i, rst_i           : IN  STD_LOGIC;                                          
    dtcm_addr_i            : IN  STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);       
    dtcm_data_wr_i         : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);        
    MemRead_ctrl_i         : IN  STD_LOGIC;                                          
    MemWrite_ctrl_i        : IN  STD_LOGIC;                                          
    ALU_Result_i           : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);        
    dtcm_data_rd_o         : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);        
    ALU_Result_o           : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);        
    TYPE_addr_i            : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);                       
    DATA_IO                : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);        
    type_en                : IN  STD_LOGIC                                           
  );
end component;
---------------------------------------------------------		
component  Execute IS
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
END component;
---------------------------------------------------------		
component Idecode IS
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
END component;
---------------------------------------------------------		
component Ifetch IS
	generic(
        WORD_GRANULARITY : boolean  := False;
        DATA_BUS_WIDTH    : integer := 32;
        PC_WIDTH          : integer := 10;
        NEXT_PC_WIDTH     : integer := 8; 
        ITCM_ADDR_WIDTH   : integer := 8;
        WORDS_NUM         : integer := 256;
        INST_CNT_WIDTH    : integer := 16
    );
    PORT(
        clk_i, rst_i      : IN  STD_LOGIC;
        -- renamed
        stall_i           : IN  STD_LOGIC;
        -- keep PCSrc + branch/jump targets 
        add_result_i      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); 
        JUMP_addr_i       : IN  STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
        PCSrc_i           : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);


        -- interrupt signals 
        type_en           : IN  STD_LOGIC;                                        
        type_address      : IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);      

        -- outputs
        pc_o              : OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        pc_plus4_o        : OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        instruction_o     : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        inst_cnt_o        : OUT STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0)
    );
END component;
---------------------------------------------------------
component Write_Back IS
	generic(
		DATA_BUS_WIDTH 	: integer := 32;
		PC_WIDTH 		: integer := 10
	);
	PORT( 
		ALU_Result_i, dtcm_data_rd_i: 		IN  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		PC_plus4_i: 						IN  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		MemtoReg_ctrl_i, jal_ctrl_i: 		IN  STD_LOGIC;
		write_data_mux_o: 					OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		-----Interrupt signals-----
		EPC_ctl_WB_i:						in STD_LOGIC
		);
END component;
---------------------------------------------------------
component control IS
   PORT(
      clk_i,reset_tb         : IN  STD_LOGIC;                                -- 1: rst_i
      opcode_i               : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);             -- 1: opcode_i
      instruction_i          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);            -- 1: instruction_i  (2: not present)
      RegDst_ctrl_o          : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);             -- 1: RegDst_ctrl_o
      ALUSrc_ctrl_o          : OUT STD_LOGIC;                                 -- 1: ALUSrc_ctrl_o
      MemtoReg_ctrl_o        : OUT STD_LOGIC;                                 -- 1: MemtoReg_ctrl_o
      RegWrite_ctrl_o        : OUT STD_LOGIC;                                 -- 1: RegWrite_ctrl_o
      MemRead_ctrl_o         : OUT STD_LOGIC;                                 -- 1: MemRead_ctrl_o
      MemWrite_ctrl_o        : OUT STD_LOGIC;                                 -- 1: MemWrite_ctrl_o
      Branch_ctrl_o          : OUT STD_LOGIC;                                 -- 1: Branch_ctrl_o  (2: not present)
      BNEctrl_o              : OUT STD_LOGIC;                                 -- 1: Bne_ctrl_o
      BEQctrl_o              : OUT STD_LOGIC;                                 -- 1: Beq_ctrl_o
      jumpctrl_o             : OUT STD_LOGIC;                                 -- 1: Jump_ctrl_o
      ALUOp_ctrl_o           : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);              -- 1: ALUOp_ctrl_o (3 bits)  (2: was 8)
      INTA                   : OUT STD_LOGIC;                                 -- 1: INTA_o
      GIE                    : OUT STD_LOGIC;                                 -- 1: GIE_o
      EPC_ctl_o              : OUT STD_LOGIC;                                 -- 1: EPC_EN_o
      flush_intr_o           : OUT STD_LOGIC;                                 -- 1: intr_flush_o
      int_req_o              : IN  STD_LOGIC;                                 -- 1: K0_0 (renamed per rule)
      INTR                   : IN  STD_LOGIC;                                 -- 1: INTR_i
      type_address           : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);              -- 1: TYPE_addr_i
      type_en                : OUT STD_LOGIC;                                 -- 1: TYPE_ctl_o
      Key_reset_o            : OUT STD_LOGIC                                  -- 1: Key_reset_o  (2: not present)
   );
END component;
---------------------------------------------------------
COMPONENT PLL port(
    areset		: IN STD_LOGIC  := '0';
	inclk0		: IN STD_LOGIC  := '0';
	c0     		: OUT STD_LOGIC ;
	locked		: OUT STD_LOGIC );
END COMPONENT;
---------------------------------------------------------
COMPONENT PLL_lower_freq IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END COMPONENT;	
---------------------------------------------------------	
--Shifter GENERIC map(n,k) PORT map(Y_in, X_in,op,result);

COMPONENT Shifter IS
  GENERIC (n : INTEGER := 32; k : INTEGER := 5);
  PORT (
    Y_in   : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    X_in   : IN STD_LOGIC_VECTOR (k-1 DOWNTO 0);
    op     : IN STD_LOGIC_VECTOR (k DOWNTO 0); -- 000000 => shift left, 000010 => shift right, else => invalid (out=0)
    result : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
  );
END COMPONENT;
---------------------------------------------------------
COMPONENT HazardAndForwarding IS
    PORT(
    ------------------------ Forwarding Unit  -------------------------
    Rs_Reg_ID_i, Rt_Reg_ID_i                 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    Rs_Reg_EX_i, Rt_Reg_EX_i                 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    write_reg_addr_EX_i                      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    write_reg_addr_DM_i                      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    write_reg_addr_WB_i                      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    RegWrite_EX_i, RegWrite_DM_i, RegWrite_WB_i
                                             : IN  STD_LOGIC;                    
    ALU_A_MUX_o, ALU_B_MUX_o                 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); 

    ------------------------ Hazard Unit  -----------------------------
    MemtoReg_EX_i, MemtoReg_DM_i             : IN  STD_LOGIC;                    
    BEQ_ID_i, BNE_ID_i                        : IN  STD_LOGIC;                   

    ------------------------ Stalls/Flush -----------------------
    Stall_IF                                  : OUT STD_LOGIC;                   
    Stall_ID                                  : OUT STD_LOGIC;                   
    Flush_EX                                  : OUT STD_LOGIC;                   

    ------------------------ Branch comparator fwd  --------------
    ForwardA_Branch                           : OUT STD_LOGIC;                   
    ForwardB_Branch                           : OUT STD_LOGIC                    
  );


END COMPONENT;	
---------------------------------------------------------FINAL PROJECT ADDED UNITS-------------------------------------------------
--Basic_Timer generic map(n) port map(MSCLK,BTCLR,rst_i,BTOUTMD,BTOUTEN,BTHOLD,BTCCR0,BTCCR1,BTSSEL,BTIP,PWM_out,BTIFG); 
COMPONENT Basic_Timer is 
	generic(n : integer := 32);
	port (MSCLK,BTCLR,rst_i,Counter_write				: in std_logic;
		  BTOUTMD,BTOUTEN 								: in std_logic := '0';
		  BTHOLD										: in std_logic := '1'; -- not enable in BTCNT
		  BTCCR0,BTCCR1									: in std_logic_vector(n-1 downto 0) :=(others => '0');
		  BTSSEL,BTIP									: in std_logic_vector(1 downto 0) := "00";
		  BTCNT_i										: in std_logic_vector(n-1 downto 0) :=(others => '0');
		  BTCNT_o										: out std_logic_vector(n-1 downto 0) :=(others => '0');
		  PWM_out,BTIFG 								: out std_logic
		); 
end COMPONENT;
---------------------------------------------------------
--Counter generic map(n) port map(rst,clk,enable,EQUY,Q24,Q28,Q32,BTCNT);
COMPONENT Counter is 
	generic(n 						: integer := 32);
	port (rst,clk,enable	 		: in std_logic;
		  EQUY,Counter_write		: in std_logic:= '0';	
		  Q24,Q28,Q32				: out std_logic :='0';	
		  BTCNT_i 					: in std_logic_vector (n-1 downto 0) := (others => '0'); 
		  BTCNT_o 					: out std_logic_vector (n-1 downto 0) := (others => '0')
		  );  	  
end COMPONENT;
---------------------------------------------------------
COMPONENT HexDecoder is
  port (
		Data_IN:			in STD_LOGIC_VECTOR(3 downto 0);
		Data_OUT:			out STD_LOGIC_VECTOR(6 downto 0)
  );
end COMPONENT;
---------------------------------------------------------
--DFF generic map(Dwidth)port(clk,en,rst,D,Q);

component DFF_lab is
    generic ( Dwidth : integer := 32 );
    port (clk : in  std_logic;
      rst : in  std_logic;
      D   : in  std_logic_vector(Dwidth-1 downto 0);
      Q   : out std_logic_vector(Dwidth-1 downto 0)
    );
  end component;
---------------------------------------------------------
--IO_Decoder GENERIC map(n) PORT map(MSCLK,MemWrite_DM_i,MemRead_DM_i,rst_i,address_i,SW7to0,LEDS,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,data_IO);
COMPONENT IO_Decoder is
  GENERIC (n 		: INTEGER := 32);
  PORT (rst_tb,rst_KEY0: 							in std_logic;
		MSCLK,MemWrite_DM_i,MemRead_DM_i:			in std_logic;
		address_i:									in std_logic_vector(11 downto 0); 
		--IO		
--		SW8,SW9:									in std_logic; 
		SW7to0: 									in std_logic_vector(7 downto 0); 
		LEDS:										out std_logic_vector(7 downto 0);
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5:				out std_logic_vector(3 downto 0); --needs to go to the decoder!!
		data_IO:									inout std_logic_vector(31 downto 0)
	);  
end COMPONENT;
---------------------------------------------------------
COMPONENT BidirPin is
	generic( width: integer:=32 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end COMPONENT;
---------------------------------------------------------
COMPONENT Interrupt_Controller is
  GENERIC (n:				INTEGER := 32;
		   Byte:			INTEGER := 8);
  
  PORT (MSCLK,rst_tb,rst_KEY0:									in std_logic; --rst_tb from testbench
		MemWrite_DM_i,MemRead_DM_i,GIE_i: 						in std_logic;
		address_i:												in std_logic_vector(11 downto 0); 
		DataBus_i:												inout std_logic_vector(n-1 downto 0);
		--INTERRUPTS INPUT
		FIR_IRQ_i,KEY3_IRQ_i,KEY2_IRQ_i,KEY1_IRQ_i,BT_IRQ_i:	in std_logic;
		FIFO_status_IRQ_i:										in std_logic;
		RX_IRQ,TX_IRQ,UART_status_error_irq:					in std_logic;
		INTA:													in std_logic; --interrupt acknowledge - **turns to 0 when acknowledged**
		INTR:													out std_logic
	);
  
end COMPONENT;
---------------------------------------------------------
COMPONENT FIR_Filter is
GENERIC (n: 		INTEGER := 32;
		 M:			INTEGER := 8;
		 W:			INTEGER := 25;
		 q:			INTEGER := 8;
		 k:			INTEGER := 8;
		 ptr_size:	INTEGER := 3;
		 Byte:		INTEGER := 8);
	
	  ----------change ports to sync with the  signals 
	PORT (rst_KEY0,rst_tb,FIFOCLK: 		IN std_logic; 
        FIRCLK:							IN std_logic; 
        FIFOEMPTY_IFG,FIRIFG: 			OUT std_logic; -- modules flags
		--IO data
		data_IO:						inout std_logic_vector(n-1 downto 0);
		address_i:						in std_logic_vector(11 downto 0);
		MemWrite_DM_i,MemRead_DM_i:		in std_logic 
	);
  
end COMPONENT;
---------------------------------------------------------
COMPONENT sync_fifo is
    generic (
        cell_size : integer := 25;
        k         : integer := 8;
        ptr_size  : integer := 3
    );
    port (
        rst_i		 	: in  std_logic;
		FIFOCLK   		: in  std_logic;
        FIFORST   		: in  std_logic;
        FIFOWEN   		: in  std_logic;
        FIFOREN   		: in  std_logic;
        FIFOIN    		: in  std_logic_vector(cell_size-1 downto 0);
        DATAOUT   		: out std_logic_vector(cell_size-1 downto 0);
        FIFOFULL  		: out std_logic;
        FIFOEMPTY 		: out std_logic
    );
end COMPONENT;
---------------------------------------------------------
COMPONENT half_cycle_pulse_intel is
  port (
    FIRCLK  : in  std_logic;  
    FIFOCLK : in  std_logic;  
    FIRENA  : in  std_logic;  
    PULSE   : out std_logic   
  );
end COMPONENT;
---------------------------------------------------------
COMPONENT register_config is
	GENERIC (n: 							INTEGER := 32;					
		   M:								INTEGER := 8;
		   W:								INTEGER := 24;
		   q:								INTEGER := 8;
		   k:								INTEGER := 8;
		   ptr_size:						INTEGER := 3;
		   Byte:							INTEGER := 8;
		   DTCM_ADDR_WIDTH: 				integer := G_ADDRWIDTH
		   );
	   
	PORT (clk,rst_tb,rst_KEY0,MemWrite_DM_i,MemRead_DM_i:			in std_logic;
		data_IO:													inout std_logic_vector(n-1 downto 0);
		address_i:													in std_logic_vector(11 downto 0);
		--PWM unit			
		PWM_out,BTIFG: 												out std_logic
		);
end COMPONENT;
---------------------------------------------------------
COMPONENT MCU IS
	generic( 
			WORD_GRANULARITY:  				boolean 	:= G_WORD_GRANULARITY;
	        MODELSIM: 						integer 	:= G_MODELSIM;
			DATA_BUS_WIDTH: 				integer 	:= 32;
			ITCM_ADDR_WIDTH: 				integer 	:= G_ADDRWIDTH;
			DTCM_ADDR_WIDTH: 				integer 	:= G_ADDRWIDTH;
			PC_WIDTH: 						integer 	:= 10;
			FUNCT_WIDTH: 					integer 	:= 6;
			DATA_WORDS_NUM: 				integer 	:= G_DATA_WORDS_NUM;
			CLK_CNT_WIDTH:	 				integer 	:= 16;
			INST_CNT_WIDTH: 				integer 	:= 16;
			k_shifter:					  	integer 	:= 5; --log2(data_bus) ---for shifter---	
			k_fifo:					  		integer 	:= 8; --for synchronos fifo (cells)---	
			n: 								INTEGER 	:= 32;
		    M:								INTEGER 	:= 8;
		    W:								INTEGER 	:= 25;
		    q:								INTEGER 	:= 8;
		    ptr_size:						INTEGER 	:= 3;
		    Byte:							INTEGER 	:= 8			
	);	
	PORT(clk_i,FIRCLK_i:								IN 	STD_LOGIC; 
        rst_i:											IN 	STD_LOGIC;
		rst_KEY0:										in std_logic; --rst_tb from testbench
--        BPADDR_i:                                   	IN 	STD_LOGIC_VECTOR(7 DOWNTO 0); 
        IFpc_o:								         	OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); 
        IDIR_o:         								OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        
        --IO signals                                	   	
        SW:                            		       		IN 	STD_LOGIC_VECTOR(9 DOWNTO 0); 
        LEDS:                                     		OUT	STD_LOGIC_VECTOR(9 DOWNTO 0);
        HEX0,HEX1,HEX2,HEX3,HEX4,HEX5:  				OUT	STD_LOGIC_VECTOR(3 downto 0);
		PWM_out:										out STD_LOGIC;
		--INTERRUPTS INPUTs
		KEY3_INTR,KEY2_INTR,KEY1_INTR:					in std_logic;
		--UART in/out
		RXbit:											in std_logic;
		TXbit:											out std_logic
--		
);
END COMPONENT;
---------------------------------------------------------
COMPONENT Quartus_Top IS
generic( 
		WORD_GRANULARITY:  				boolean 	:= G_WORD_GRANULARITY;
        MODELSIM: 						integer 	:= G_MODELSIM;
		DATA_BUS_WIDTH: 				integer 	:= 32;
		ITCM_ADDR_WIDTH: 				integer 	:= G_ADDRWIDTH;
		DTCM_ADDR_WIDTH: 				integer 	:= G_ADDRWIDTH;
		PC_WIDTH: 						integer 	:= 10;
		FUNCT_WIDTH: 					integer 	:= 6;
		DATA_WORDS_NUM: 				integer 	:= G_DATA_WORDS_NUM;
		CLK_CNT_WIDTH:	 				integer 	:= 16;
		INST_CNT_WIDTH: 				integer 	:= 16;
		k_shifter:					  	integer 	:= 5; --log2(data_bus) ---for shifter---
		k_fifo:					  		integer 	:= 8; --for synchronos fifo (cells)---	
		n: 								INTEGER 	:= 32;
	    M:								INTEGER 	:= 8;
	    W:								INTEGER 	:= 25;
	    q:								INTEGER 	:= 8;
	    ptr_size:						INTEGER 	:= 3;
	    Byte:							INTEGER 	:= 8			
);	
  PORT 
  (  
	CLK_IN:								in std_logic; --enable=SW8,rst=key3
	KEY0,KEY1,KEY2,KEY3:				in std_logic; 
	sw: 								in std_logic_vector(9 downto 0); 
	LEDS:								out std_logic_vector(9 downto 0);
	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5:		out std_logic_vector(6 downto 0);
	PWM_out:							out std_logic;
	IFIR_o:	  							out  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    IDIR_o:   							out  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	--UART in/out						
	RXbit:								in std_logic; --D11 GPIO
	TXbit:								out std_logic --D13 GPIO	
	);
end COMPONENT;






end aux_package;

