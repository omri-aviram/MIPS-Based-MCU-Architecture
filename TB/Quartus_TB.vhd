---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;


ENTITY Quartus_tb IS
	generic( 
			WORD_GRANULARITY:  				boolean 	:= G_WORD_GRANULARITY;
	        MODELSIM: 						integer 			:= G_MODELSIM;
			DATA_BUS_WIDTH: 				integer 	:= 32;
			ITCM_ADDR_WIDTH: 				integer 	:= G_ADDRWIDTH;
			DTCM_ADDR_WIDTH: 				integer 	:= G_ADDRWIDTH;
			PC_WIDTH: 						integer 			:= 10;
			FUNCT_WIDTH: 					integer 		:= 6;
			DATA_WORDS_NUM: 				integer 	:= G_DATA_WORDS_NUM;
			CLK_CNT_WIDTH:	 				integer 	:= 16;
			INST_CNT_WIDTH: 				integer 	:= 16;
			k_shifter:					  	integer 	:= 5; --log2(data_bus) ---for shifter---	
			k_fifo:						  	integer 	:= 8; --log2(data_bus) ---for shifter---	
			n: 								INTEGER := 32;
		    M:								INTEGER := 8;
		    W:								INTEGER := 25;-----------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 25 to check!!!!
		    q:								INTEGER := 8;
		    ptr_size:						INTEGER := 3;
		    Byte:							INTEGER := 8
	);
END Quartus_tb ;


ARCHITECTURE struct OF Quartus_tb IS
	-- Internal signal declarations
	signal clk_tb_i,rst_tb_i,clk_20k:			std_logic; --enable=SW8,rst=key3
	signal KEY0,KEY1,KEY2,KEY3 :				std_logic; 
	signal sw: 									std_logic_vector(9 downto 0) := "0000000000"; 
	signal PWM_out:								std_logic; 
	signal LEDS:								std_logic_vector(9 downto 0);
	signal HEX0,HEX1,HEX2,HEX3,HEX4,HEX5:		std_logic_vector(6 downto 0);
	
	signal IFpc_o,IDpc_o,EXpc_o,DMpc_o,WBpc_o	: STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); 
	signal IFIR_o,IDIR_o,EXIR_o,DMIR_o,WBIR_o	: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal CLKCNT_o								: STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0); -- Clock count 
	signal INSTCNT_o 							: STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);-- instruction counter
	signal STRIGGER_o							: STD_LOGIC;									--Breck Point Trigger
	signal STCNT_o								: STD_LOGIC_VECTOR(7 DOWNTO 0);	-- stall counter 8 bit register
	signal FHCNT_o								: STD_LOGIC_VECTOR(7 DOWNTO 0); -- flush counter   9 bit register
	signal RXbit,TXbit:							std_logic;

	
	
BEGIN

	

	
	
	
Q_PORTS : Quartus_Top generic map( 
		WORD_GRANULARITY	=> WORD_GRANULARITY	,			
        MODELSIM			=> MODELSIM			,					
		DATA_BUS_WIDTH		=> DATA_BUS_WIDTH	,				
		ITCM_ADDR_WIDTH		=> ITCM_ADDR_WIDTH	,				
		DTCM_ADDR_WIDTH		=> DTCM_ADDR_WIDTH	,				
		PC_WIDTH			=> PC_WIDTH			,					
		FUNCT_WIDTH			=> FUNCT_WIDTH		,					
		DATA_WORDS_NUM		=> DATA_WORDS_NUM	,				
		CLK_CNT_WIDTH		=>	CLK_CNT_WIDTH	, 				
		INST_CNT_WIDTH		=> INST_CNT_WIDTH	,				
		k_shifter			=>	k_shifter		,				  	
		k_fifo				=>	k_fifo			,				  		
		n					=> 	n,								
	    M					=>	M,							
	    W					=>	W,							
	    q					=>	q,							
	    ptr_size			=>	ptr_size,					
	    Byte				=>	Byte)
	PORT map (  
		CLK_IN		=> clk_tb_i,
		KEY0    	=> KEY0,
		KEY1    	=> KEY1,
		KEY2    	=> KEY2,
		KEY3    	=> KEY3,
		sw 			=> sw,
		PWM_out 	=> PWM_out,
		LEDS		=> LEDS,							
		HEX0    	=> HEX0,
		HEX1    	=> HEX1,
		HEX2    	=> HEX2,
		HEX3    	=> HEX3,
		HEX4    	=> HEX4,
		HEX5		=> HEX5,
		RXbit		=> RXbit,
		TXbit       => TXbit
		);
	
--------------------------------------------------------------------	
	gen_clk : 
	process
        begin
		  clk_tb_i <= '1';
		  wait for 20 ns;
		  clk_tb_i <= not clk_tb_i;
		  wait for 20 ns;
    end process;
	
	
	gen_rst : 
	process
        begin
		  KEY0 <= '0','1' after 200 ns;
--		  wait for 10 us;
--		  rst_KEY0 <= '1', '0' after 200 ns;
		  wait;
    end process;
	
	gen_INTR:
	process
	begin
		
		wait for 50 us;
		sw <= "0000000001";
		wait for 100 us;
		KEY1				<= '1', '0' after 1 us;
		wait for 100 us;
		KEY2				<= '1', '0' after 1 us;
		wait for 100 us;
		KEY3				<= '1', '0' after 1 us;
		wait for 100 us;
		KEY3				<= '1', '0' after 1 us;
		wait for 100 us;
		KEY2				<= '1', '0' after 1 us;
		wait for 100 us;
		KEY1				<= '1', '0' after 1 us;
		wait ;
		
	end process;
--------------------------------------------------------------------		
END struct;
