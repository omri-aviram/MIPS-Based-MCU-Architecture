-- tal adoni 31987300
-- omri aviram 312192669

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;
----------------------------------------------------------------
ENTITY Quartus_Top IS
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
	    W:								INTEGER 	:= 24; -------------!!!!!! changed for tests - 25 for internet test
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
	RXbit:								in std_logic;
	TXbit:								out std_logic	
	);
end Quartus_Top;
----------------------------------------------------------------
ARCHITECTURE struct OF Quartus_Top IS 

signal rst_KEY0,not_KEY1,not_KEY2,not_KEY3:		std_logic:='0';


--PLLs signals
signal Clk,FIRCLK_w,pll_locked,rst_tb     								: std_logic;   -- 50 MHz from PLL
signal first_lower_clock,second_lower_clock,PLL_CLK,clk_20k	: std_logic := '0';

-- divider counter: 50e6 / (2*20e3) = 1250
signal div_cnt : integer range 0 to 1249 := 0;
--verification signals
signal IFpc_o,IDpc_o,EXpc_o,DMpc_o,WBpc_o: 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
--signal IFIR_o,IDIR_o,EXIR_o,DMIR_o,WBIR_o:	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

signal CLKCNT_o:                    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0); -- Clock count 
signal INSTCNT_o:                   STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0); -- instruction counter
signal STRIGGER_o:                  STD_LOGIC; --Breck Point Trigger
signal STCNT_o:                     STD_LOGIC_VECTOR(7 DOWNTO 0); -- stall counter 8 bit register
signal FHCNT_o:                     STD_LOGIC_VECTOR(7 DOWNTO 0); -- flush counter   9 bit register

--hex signals
--signal HEX0_decoded,HEX1_decoded,HEX2_decoded: 				std_logic_vector(6 downto 0):=(others => '0');
signal HEX0_decoded,HEX1_decoded,HEX2_decoded: 				std_logic_vector(6 downto 0);

signal HEX0_undecoded,HEX1_undecoded,HEX2_undecoded: 		std_logic_vector(3 downto 0):=(others => '0');


signal HEX3_decoded,HEX4_decoded,HEX5_decoded: 				std_logic_vector(6 downto 0):=(others => '0');
signal HEX3_undecoded,HEX4_undecoded,HEX5_undecoded: 		std_logic_vector(3 downto 0):=(others => '0');



begin
------------needed it for previous use for MODELSIM TBs
rst_tb <= '0';


--HexDecoder port map (Data_IN,Data_OUT);
Hex0_Ports: HexDecoder port map (HEX0_undecoded,HEX0_decoded);
Hex1_Ports: HexDecoder port map (HEX1_undecoded,HEX1_decoded);
Hex2_Ports: HexDecoder port map (HEX2_undecoded,HEX2_decoded);
Hex3_Ports: HexDecoder port map (HEX3_undecoded,HEX3_decoded);
Hex4_Ports: HexDecoder port map (HEX4_undecoded,HEX4_decoded);
Hex5_Ports: HexDecoder port map (HEX5_undecoded,HEX5_decoded);


-------------------------- Enables  ---------------------
rst_KEY0 <=	'0' when (KEY0) = '1' and pll_locked = '1' else '1';

Key_sync:process(Clk)
		begin	
			if rising_edge(Clk) then
				not_KEY3 <= not(KEY3);
				not_KEY2 <= not(KEY2);
				not_KEY1 <=	not(KEY1);
			end if;
		end process;	
-------------------------- HEX assigning ---------------------
HEX_sync:process(Clk)
		begin	
			if rising_edge(Clk) then
			HEX0	<=	HEX0_decoded;
			HEX1	<=	HEX1_decoded;
			HEX2	<= 	HEX2_decoded;
			HEX3	<=	HEX3_decoded;
			HEX4	<=	HEX4_decoded;
			HEX5	<=	HEX5_decoded;
			end if;
		end process;
-------------------------- LEDs assigning ---------------------




MICRO: MCU generic map(
			WORD_GRANULARITY  	=> WORD_GRANULARITY,
	        MODELSIM 			=> MODELSIM,
			DATA_BUS_WIDTH 	    => DATA_BUS_WIDTH,
			ITCM_ADDR_WIDTH 	=> ITCM_ADDR_WIDTH,
			DTCM_ADDR_WIDTH 	=> DTCM_ADDR_WIDTH,
			PC_WIDTH 			=> PC_WIDTH,
			FUNCT_WIDTH 		=> FUNCT_WIDTH,
			DATA_WORDS_NUM 	    => DATA_WORDS_NUM,
			CLK_CNT_WIDTH	 	=> CLK_CNT_WIDTH,
			INST_CNT_WIDTH 	    => INST_CNT_WIDTH,
			k_shifter			=> k_shifter,
			k_fifo				=> k_fifo,
			n 					=> n,
		    M					=> M,
		    W					=> W,
		    q					=> q,
		    ptr_size			=> ptr_size,
		    Byte				=> Byte
	)
	PORT map(clk_i		=> Clk, --Clk,CLK_IN
		FIRCLK_i		=> FIRCLK_w,							
        rst_i			=> rst_tb,						
		rst_KEY0		=> rst_KEY0,							
--        BPADDR_i:                                   	
        IFpc_o			=>  IFpc_o,
		IDIR_o          =>  IDIR_o,
        --IO signals                                	   	
        SW       		=> SW,
        LEDS            => LEDS,                         		
        HEX0            => HEX0_undecoded,
		HEX1            => HEX1_undecoded,
		HEX2            => HEX2_undecoded,
		HEX3            => HEX3_undecoded,
		HEX4            => HEX4_undecoded,
		HEX5  			=> HEX5_undecoded,	
		PWM_out			=> PWM_out,
		--INTERRUPTS INPUTs
		KEY3_INTR		=> not_KEY3,
		KEY2_INTR       => not_KEY2,
		KEY1_INTR		=> not_KEY1,
		RXbit           => RXbit,
		TXbit			=> TXbit
);

--clock choose 


CLK <= CLK_IN when (G_MODELSIM = 1) else PLL_CLK;
FIRCLK_w <= clk_20k when (G_MODELSIM = 1) else second_lower_clock;

---------------PLL and in clocks---------------
PLL_Ports: PLL
port map (
	areset => '0',
	inclk0 => CLK_IN,  -- FPGA input cloc
	c0     => PLL_CLK,     -- 50 MHz out
	locked => pll_locked
);

PLL_freq_Ports1: PLL_lower_freq
port map (
	areset => '0',
	inclk0 => CLK_IN,  -- FPGA input cloc
	c0     => first_lower_clock,     -- lowering the clock to few MHz
	locked => open
);
PLL_lower_freq_Ports2: PLL_lower_freq
port map (
	areset => '0',
	inclk0 => first_lower_clock,  -- FPGA input cloc
	c0     => second_lower_clock,     -- ~44kHz out
	locked => open
);

process (CLK_IN)
begin
  if rising_edge(CLK_IN) then
    if rst_tb = '1' then
      div_cnt  <= 0;
      clk_20k  <= '0';
    elsif div_cnt = 1249 then
      div_cnt  <= 0;
      clk_20k  <= not clk_20k;
    else
      div_cnt  <= div_cnt + 1;
    end if;
  end if;
end process;

	  
END struct;