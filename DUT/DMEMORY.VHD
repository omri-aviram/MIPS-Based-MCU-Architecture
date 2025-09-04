---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
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
END dmemory;

ARCHITECTURE behavior OF dmemory IS
  SIGNAL wrclk_w       : STD_LOGIC;
  SIGNAL WR_en         : STD_LOGIC;
  SIGNAL address_mux   : STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
  SIGNAL data_IO2CPU_en    : STD_LOGIC;
  SIGNAL read_data_mem : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
  
  
  data_IO2CPU_en <= '1' WHEN (MemRead_ctrl_i = '1' AND ALU_Result_i(11) = '1') ELSE '0'; --reading from IO devices
  dtcm_data_rd_o <= DATA_IO WHEN data_IO2CPU_en = '1' ELSE read_data_mem;
  ALU_Result_o <= DATA_IO WHEN data_IO2CPU_en = '1' ELSE ALU_Result_i;
  address_mux <= dtcm_addr_i WHEN type_en = '0' ELSE ("00" & TYPE_addr_i(7 DOWNTO 2));  -- type length = 8-bit
  WR_en <= '1' WHEN (ALU_Result_i(11) = '0' AND MemWrite_ctrl_i = '1') ELSE '0';--writing to IO devices


  data_memory : altsyncram
    GENERIC MAP (
      operation_mode         => "SINGLE_PORT",
      width_a                => DATA_BUS_WIDTH,
      widthad_a              => DTCM_ADDR_WIDTH,
      numwords_a             => WORDS_NUM,
      lpm_hint               => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = DTCM",
      lpm_type               => "altsyncram",
      outdata_reg_a          => "UNREGISTERED",
      init_file              => "C:\Users\talad\OneDrive\CPU Architecture lab\Final Project CPU\sub\DTCM.hex",
      intended_device_family => "Cyclone"
    )
    PORT MAP (
      wren_a    => WR_en,
      clock0    => wrclk_w,
      address_a => address_mux,
      data_a    => dtcm_data_wr_i,
      q_a       => read_data_mem
    );
--writing in falling edge	
  wrclk_w <= NOT clk_i;

END behavior;
