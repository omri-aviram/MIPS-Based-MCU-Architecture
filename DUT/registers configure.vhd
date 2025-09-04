LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
USE work.cond_comilation_package.all;
USE work.FIR_package.all;
USE work.const_package.all;

----------------------------------------------------------------
ENTITY register_config is
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
  
end register_config;
----------------------------------------------------------------
ARCHITECTURE struct OF register_config IS 
		
		
		
	signal Zero_vec:								std_logic_vector(n-1 downto 0) := (others => '0'); 
	signal rst_w:									std_logic := '0';	
	---------Tristate signals---------			
	signal DataBus_en_read:							std_logic := '0';
	signal DataIO_read:								std_logic_vector(n-1 downto 0):= (others => '0') ;
---------------------------------------נasic timer unit---------------------------------------
	signal BTCCR0,BTCCR1: 							std_logic_vector(n-1 downto 0) :=(others => '0');
	
	
	signal BTCTL:									std_logic_vector(Byte-1 downto 0) := (others => '0');
	alias BTOUTMD:									std_logic is BTCTL(7);
	alias BTOUTEN:									std_logic is BTCTL(6);
	alias BTHOLD:					    			std_logic is BTCTL(5);
	alias BTSSEL:									std_logic_vector is BTCTL(4 downto 3);
	alias BTCLR:									std_logic is BTCTL(2);
	alias BTIP:										std_logic_vector is BTCTL(1 downto 0);
	
	signal BTCTL_r:									std_logic_vector(Byte-1 downto 0) := (others => '0');
	alias BTOUTMD_r:								std_logic is BTCTL_r(7);
	alias BTOUTEN_r:								std_logic is BTCTL_r(6);
	alias BTHOLD_r:					    			std_logic is BTCTL_r(5);
	alias BTSSELx_r:								std_logic_vector is BTCTL_r(4 downto 3);
	alias BTCLR_r:									std_logic is BTCTL_r(2);
	alias BTIPx_r:									std_logic_vector is BTCTL_r(1 downto 0);
		
	signal BTCNT_i,BTCNT_read,BTCCR0_r,BTCCR1_r:	std_logic_vector(n-1 downto 0) := (others => '0');
	signal Counter_write_w,Counter_write:			std_logic := '0';
	
---------------------------------------FIR unit---------------------------------------
--	signal FIROUT: 						std_logic_vector(n-1 downto 0) := (others => '0');
--	signal COEFs_r: 					vector_array_q(M-1 downto 0)(q-1 downto 0):= (others =>(others => '0')); -- coefficients Q0.q
--	signal FIRIN_r:						std_logic_vector(n-1 downto 0):= (others => '0');
--	
--	signal FIRCTL_r:					std_logic_vector(Byte-1 downto 0):="UU010010";
--	-- FIRCTL register
--	alias FIFOWEN_r:					std_logic is FIRCTL_r(5);
--	alias FIFORST_r:					std_logic is FIRCTL_r(4);--start from rst
--	alias FIFOFULL_r:					std_logic is FIRCTL_r(3);
--	alias FIFOEMPTY_r:					std_logic is FIRCTL_r(2);
--	alias FIRRST_r:						std_logic is FIRCTL_r(1);--start from rst
--	alias FIRENA_r:						std_logic is FIRCTL_r(0);
		
begin

rst_w <= rst_tb or rst_KEY0;



-------------------------tristate architecture-----------------

DataBus_en_read <= '1' when (--(address_i = ADDR_FIRCTL  or address_i = ADDR_FIRIN  or address_i = ADDR_FIROUT  or address_i = ADDR_COEF3_0 or address_i = ADDR_COEF7_4 or 
							(address_i = ADDR_BTCTL or address_i = ADDR_BTCNT or address_i = ADDR_BTCCR0 or address_i = ADDR_BTCCR1) 
							and (MemRead_DM_i = '1')) else '0'; --Basic Timer 
						
								      
data_IO_tristate_read:	BidirPin generic map(n) port map (Dout => DataIO_read,en => DataBus_en_read,Din => open ,IOpin => data_IO);
								    
---------------------------------------READ/WRITE CONFIGURATION---------------------------------------

-------write----
--process(clk)
--begin
--    if falling_edge(clk) then
--        if (MemWrite_DM_i = '1') and (address_i = ADDR_FIRCTL) then
--            FIFOWEN_r <= data_IO(5);
--        else
--            FIFOWEN_r <= '0';
--        end if;
--    end if;
--end process;


process(clk,MemWrite_DM_i)
begin
	if (MemWrite_DM_i = '1') and rising_edge(clk) then 
		case address_i is --writing  to BT on falling edge
			--BT UNIT
			when ADDR_BTCTL 	=> BTCTL_r <= data_IO(Byte-1 downto 0);
			when ADDR_BTCNT 	=> BTCNT_i <= data_IO;
			when ADDR_BTCCR0 	=> BTCCR0_r <= data_IO;
			when ADDR_BTCCR1 	=> BTCCR1_r <= data_IO;
			--FIR UNIT
--			when ADDR_FIRCTL => 
--				FIRCTL_r(4) <= data_IO(4); --FIFOWEN is configured outside
--				FIRCTL_r(1 downto 0)    <= data_IO(1 downto 0);
--			when ADDR_FIRIN => FIRIN_r <= data_IO;
--			when ADDR_COEF3_0 => --COEFs(3) & COEFs(2) & COEFs(1) & COEFs(0) <= data_IO;
--				COEFs_r(0) <= data_IO(7 downto 0);
--				COEFs_r(1) <= data_IO(15 downto 8);
--				COEFs_r(2) <= data_IO(23 downto 16);
--				COEFs_r(3) <= data_IO(31 downto 24);
--			when ADDR_COEF7_4 => --COEFs(7) & COEFs(6) & COEFs(5) & COEFs(4) <= data_IO;
--				COEFs_r(4) <= data_IO(7 downto 0);
--				COEFs_r(5) <= data_IO(15 downto 8);
--				COEFs_r(6) <= data_IO(23 downto 16);
--				COEFs_r(7) <= data_IO(31 downto 24);
			when others => null;--unaffected when others;
		end case;
	end if;
end process;


-----read----
process(address_i)
begin
	case address_i is 
--		--FIR unit
--		when ADDR_FIRCTL 	=> DataIO_read <= Zero_vec( n-1 downto Byte) & FIRCTL_r;
--		 when ADDR_FIRIN 	=> DataIO_read <= FIRIN_r;
--		 when ADDR_FIROUT 	=> DataIO_read <= FIROUT;
--		 when ADDR_COEF3_0 	=> DataIO_read <= COEFs_r(3) & COEFs_r(2) & COEFs_r(1) & COEFs_r(0);
--		 when ADDR_COEF7_4 	=> DataIO_read <= COEFs_r(7) & COEFs_r(6) & COEFs_r(5) & COEFs_r(4);
 		--PWM unit
		when ADDR_BTCTL	=> DataIO_read <= Zero_vec(n-1 downto Byte) & BTCTL_r;
		 when ADDR_BTCNT    => DataIO_read <= BTCNT_read;  --820;
		 when ADDR_BTCCR0   => DataIO_read <= BTCCR0_r;
		 when ADDR_BTCCR1   => DataIO_read <= BTCCR1_r;
		 when others => DataIO_read <=(others => 'Z');
	end case; 
end process;

---------------------------------------CONNECTING UNITS---------------------------------------

Basic_timer_unit : Basic_Timer 
				generic map(
					n => n
				)
				port map(
					MSCLK         => clk,             
					BTCLR         => BTCLR,           
					rst_i         => rst_w,           
					Counter_write => Counter_write,   
					BTOUTMD       => BTOUTMD,         
					BTOUTEN       => BTOUTEN,
					BTHOLD        => BTHOLD,
					BTCCR0        => BTCCR0,
					BTCCR1        => BTCCR1,
					BTSSEL        => BTSSEL,
					BTIP          => BTIP,
					BTCNT_i       => BTCNT_i,         
					BTCNT_o       => BTCNT_read,         
					PWM_out       => PWM_out,         
					BTIFG         => BTIFG
				);
 

--FIR_UNIT: FIR_Filter 
--		GENERIC map(n		=> n,
--			M		    => M,
--			W		    => W,
--			q		    => q,
--			k		    => k,
--			ptr_size	=> ptr_size,
--			Byte		=> Byte
--			)	
--		PORT map(rst_KEY0	=> rst_KEY0,
--			rst_tb			=> rst_tb,
--			FIFORST	        => FIRCTL_r(4),
--			FIFOCLK	        => clk,				
--			FIFOWEN 		=> FIRCTL_r(5),          
--			FIRCLK	        => FIRCLK_i,                   
--			FIRRST	        => FIRCTL_r(1),                
--			FIRENA    		=> FIRCTL_r(0),                
--			COEFs       	=> COEFs_r,                    
--			FIRIN       	=> FIRIN_r,
--			FIFOFULL	    => FIRCTL_r(3),
--			FIFOEMPTY   	=> FIRCTL_r(2),
--			FIRIFG      	=> FIRIFG,
--			FIROUT      	=> FIROUT
--		);
-- FIFOEMPTY <= FIRCTL_r(2); --output flag!!
 
-----------read data from Data_IO to BT------------------
process(clk)
begin 
	if rising_edge(clk) then
		if (MemWrite_DM_i = '1') and (address_i = ADDR_BTCNT) then
			Counter_write_w <= '1';
		else 
			Counter_write_w <= '0';
		end if;
	end if;
end process;

process(clk)
begin 
	if falling_edge(clk) then
		-------basic timer unit------------
		BTCCR0			<= BTCCR0_r;
		BTCCR1			<= BTCCR1_r;
		BTOUTMD			<= BTOUTMD_r;
		BTOUTEN			<= BTOUTEN_r;
		BTHOLD	        <= BTHOLD_r;	
		BTSSEL			<= BTSSELx_r;
		BTCLR			<= BTCLR_r;	
	    BTIP			<= BTIPx_r;	
		Counter_write	<= Counter_write_w;
	end if;
end process;






end struct;



