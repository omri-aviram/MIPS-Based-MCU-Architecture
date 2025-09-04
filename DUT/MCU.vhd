LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;




ENTITY MCU IS
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
		    W:								INTEGER 	:= 24;
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
		
END MCU;



ARCHITECTURE MICRO OF MCU IS

	signal 	ALU_Result_DM_w:										STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0):= (others => '0');	
	signal	DATA_IO_W:                        						STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0):= (others => '0');
	signal	MemWrite_DM_w,MemRead_DM_w:           					STD_LOGIC:='0';	--CONTROL SIGNAL
					
	signal	address_i:												std_logic_vector(11 downto 0):= (others => '0');
	signal	BTCLR,BTOUTMD,BTOUTEN: 									std_logic := '0';
	signal	BTHOLD: 												std_logic := '1'; -- not enable in BTCNT
	signal	BTCCR0,BTCCR1: 											std_logic_vector(n-1 downto 0) :=(others => '0');
	signal	BTSSEL,BTIP: 											std_logic_vector(1 downto 0):= (others => '0');
	signal	BTIFG_w: 												std_logic;
	signal	BTCNT_o:												std_logic_vector (n-1 downto 0):= (others => '0');
--Interrupt_Controller signals				
	signal	GIE_i_w: 												std_logic:='0';
--INTERRUPTS signals
	signal Key_reset_s:												std_logic:='0'; 
	signal INTA:													std_logic:='0'; --interrupt acknowledge - **turns to 0 when acknowledged**
	signal INTR:													std_logic:='0';											
	signal FIRIFG_w:												std_logic:='0';
	signal FIFO_status_INTR:								 		std_logic:='0';
	signal RXIFG,TXIFG:												std_logic:='0';
	signal INTRsrc: 												STD_LOGIC_VECTOR(8 DOWNTO 0);
	
	signal EX_ALU_result:											STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal ICaddress,GPIOaddress:									STD_LOGIC_VECTOR(7 DOWNTO 0 );
	signal Status_IFG,RX_IFG,TX_IFG:								STD_LOGIC:='0';
	
	
	
	
	SIGNAL HEX0_w					     	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL HEX1_w						    : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL HEX2_w						    : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL HEX3_w						    : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL HEX4_w						    : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL HEX5_w						    : STD_LOGIC_VECTOR( 7 DOWNTO 0 );

BEGIN


address_i <= ALU_Result_DM_w(11 downto 0);


---------------------------------------------
/*
HEX0 <= HEX0_w(3 downto 0);
HEX1 <= HEX1_w(3 downto 0);
HEX2 <= HEX2_w(3 downto 0);
HEX3 <= HEX3_w(3 downto 0);
HEX4 <= HEX4_w(3 downto 0);
HEX5 <= HEX5_w(3 downto 0);
*/
---------------------------------------------
CORE : MIPS 
	PORT MAP (
				rst_i 							=> rst_KEY0,
				SW_i							=> SW,
				clk_i 							=> clk_i,
				IFpc_o	 						=> IFpc_o,
				IDinstruction_o 				=> IDIR_o,
				MemRead_o						=> MemRead_DM_w,
				MemWrite_o						=> MemWrite_DM_w,
				Data_io					    	=> DATA_IO_W,
				EX_ALU_result_o  				=> EX_ALU_result,	
				MEM_ALU_result_o  				=> ALU_Result_DM_w,	
				GIE_o							=> GIE_i_w,
				Key_reset 				        => Key_reset_s,
				INTA							=> INTA,
				INTR_i							=> INTR
				);                               


IO_port : IO_Decoder
    generic map(
        n => n
    )
    port map(
        MSCLK      		=> clk_i,
        MemWrite_DM_i 	=> MemWrite_DM_w,
        MemRead_DM_i  	=> MemRead_DM_w,
        rst_tb			=> rst_i,
		rst_KEY0      	=> rst_KEY0, 
        address_i     	=> address_i,
        SW7to0        	=> SW(7 DOWNTO 0),
        LEDS          	=> LEDS(7 DOWNTO 0),
        HEX0          	=> HEX0,
        HEX1          	=> HEX1,
        HEX2          	=> HEX2,
        HEX3          	=> HEX3,
        HEX4          	=> HEX4,
        HEX5          	=> HEX5,
        data_IO       	=> DATA_IO_W
    );

Reg_config : register_config
    generic map(
        n               => n,
        M               => M,
        W               => W,
        q               => q,
        k               => k_fifo,
        ptr_size        => ptr_size,
        Byte            => Byte,
        DTCM_ADDR_WIDTH => DTCM_ADDR_WIDTH
    )
    port map(
        clk             => clk_i,
        rst_tb			=> rst_i,
		rst_KEY0		=> rst_KEY0,
        MemWrite_DM_i   => MemWrite_DM_w,
        MemRead_DM_i    => MemRead_DM_w,
        data_IO         => DATA_IO_W,
        address_i       => address_i,           
        -- PWM unit
        PWM_out         => PWM_out,
        BTIFG           => BTIFG_w
    );


FIR: FIR_Filter 
	GENERIC map(n => n,
				M => M,	
				W => W,	
				q => q,	
				k => k_fifo,	
				ptr_size => ptr_size,	
				Byte => Byte
				)
	PORT map(rst_KEY0 => rst_KEY0,
			rst_tb => rst_i,
			FIFOCLK => clk_i,
			FIRCLK => FIRCLK_i,
			FIFOEMPTY_IFG => FIFO_status_INTR,
			FIRIFG => FIRIFG_w,
			--IO data
			data_IO => DATA_IO_W,
			address_i => address_i,
			MemWrite_DM_i => MemWrite_DM_w,
			MemRead_DM_i => MemRead_DM_w
			);


INTRsrc(3)	   <= (KEY1_INTR);
INTRsrc(4)	   <= (KEY2_INTR);
INTRsrc(5) 	   <= (KEY3_INTR);
INTRsrc(6)     <= FIFO_status_INTR;
INTRsrc(7)     <= Status_IFG;
INTRsrc(8)     <= FIRIFG_w;

IC: Interrupt_Controller 
  GENERIC map(n		=> n,
		   Byte     => Byte)
  PORT map(MSCLK					=> clk_i,
		rst_tb	                => rst_i,
		rst_KEY0	            => rst_KEY0,
		MemWrite_DM_i	        => MemWrite_DM_w,
		MemRead_DM_i	        => MemRead_DM_w,
		GIE_i	                => GIE_i_w,
		address_i	            => address_i,
		DataBus_i	            => DATA_IO_W,
		--INTERRUPTS INPUT	    => 
		FIR_IRQ_i	            => FIRIFG_w,
		KEY3_IRQ_i	            => KEY3_INTR,
		KEY2_IRQ_i	            => KEY2_INTR,
		KEY1_IRQ_i	            => KEY1_INTR,
		BT_IRQ_i	            => BTIFG_w,
		FIFO_status_IRQ_i	    => Status_IFG,
		RX_IRQ	                => '0',
		TX_IRQ	                => '0',
		UART_status_error_irq   => '0',
		INTA					=> INTA,
		INTR                    => INTR
	);




END MICRO;
