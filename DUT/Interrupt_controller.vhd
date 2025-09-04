LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
USE work.const_package.all;

----------------------------------------------------------------
ENTITY Interrupt_Controller is
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
  
end Interrupt_Controller;
----------------------------------------------------------------
ARCHITECTURE struct OF Interrupt_Controller IS 
	--Bidirpin signals
	signal DataBus_i_en:						std_logic := '0';
	signal Din,Dout:							std_logic_vector(n-1 downto 0) ;
	
	signal zero_vec,HighZ_vec:					std_logic_vector(n-1 downto 0) ;
	signal CS:									std_logic_vector(2 downto 0):= (others => '0');
	signal reset_IFG_o,reset_w,clr_reset:		std_logic := '0';
	signal Intrrupt_req_w:						std_logic;
	signal Type_r,Type_o:						std_logic_vector(Byte-1 downto 0):= (others => '0'); 
	
	signal clr_w:								std_logic_vector(Byte downto 0):= (others => '0');--- size 9 (status + INTR without rst)
	--clear bit vector			
	alias FIR_clr_w:							std_logic is clr_w(6);
	alias KEY3_clr_w:							std_logic is clr_w(5);
	alias KEY2_clr_w:							std_logic is clr_w(4);
	alias KEY1_clr_w:							std_logic is clr_w(3);
	alias BT_clr_w:								std_logic is clr_w(2);
	alias TX_clr_w:								std_logic is clr_w(1);
	alias RX_clr_w:								std_logic is clr_w(0);
	alias UART_status_error_clr_w:				std_logic is clr_w(7);
	alias FIFO_status_clr_w:					std_logic is clr_w(8);
				
	signal irq_w:								std_logic_vector(Byte downto 0):= (others => '0'); -- size 9 (status + INTR without rst)
	--irq vector			
	alias FIR_irq_w:							std_logic is irq_w(6);
	alias KEY3_irq_w:							std_logic is irq_w(5);
	alias KEY2_irq_w:							std_logic is irq_w(4);
	alias KEY1_irq_w:							std_logic is irq_w(3);
	alias BT_irq_w:								std_logic is irq_w(2);
	alias TX_irq_w:								std_logic is irq_w(1);
	alias RX_irq_w:								std_logic is irq_w(0);
	alias UART_status_error_irq_w:				std_logic is irq_w(7);
	alias FIFO_status_irq_w:					std_logic is irq_w(8);
				
---------------------- IE registers ----------------------				
	signal IE_r : std_logic_vector(Byte downto 0) := (others => '1');
	
	alias FIRIE_r                : std_logic is IE_r(6);
	alias KEY3IE_r               : std_logic is IE_r(5);
	alias KEY2IE_r               : std_logic is IE_r(4);
	alias KEY1IE_r               : std_logic is IE_r(3);
	alias BTIE_r                 : std_logic is IE_r(2);
	alias TXIE_r                 : std_logic is IE_r(1);
	alias RXIE_r                 : std_logic is IE_r(0);
	alias UART_status_error_IE_r : std_logic is IE_r(7);
	alias FIFO_status_IE_r       : std_logic is IE_r(8);
	
	signal IE_o : std_logic_vector(Byte downto 0) := (others => '1');
	
	alias FIRIE_o                : std_logic is IE_o(6);
	alias KEY3IE_o               : std_logic is IE_o(5);
	alias KEY2IE_o               : std_logic is IE_o(4);
	alias KEY1IE_o               : std_logic is IE_o(3);
	alias BTIE_o                 : std_logic is IE_o(2);
	alias TXIE_o                 : std_logic is IE_o(1);
	alias RXIE_o                 : std_logic is IE_o(0);
	alias UART_status_error_IE_o : std_logic is IE_o(7);
	alias FIFO_status_IE_o       : std_logic is IE_o(8);
---------------------- IFG registers ----------------------				
	signal IFG_r: std_logic_vector(Byte downto 0) := (others => '0');	
	
	alias FIRIFG_r               : std_logic is IFG_r(6); -- status / FIROUT
	alias KEY3IFG_r              : std_logic is IFG_r(5);
	alias KEY2IFG_r              : std_logic is IFG_r(4);
	alias KEY1IFG_r              : std_logic is IFG_r(3);
	alias BTIFG_r                : std_logic is IFG_r(2);
	alias TXIFG_r                : std_logic is IFG_r(1);
	alias RXIFG_r                : std_logic is IFG_r(0);
	alias UART_status_error_IFG_r: std_logic is IFG_r(7);
	alias FIFO_status_IFG_r      : std_logic is IFG_r(8);
	
	signal IFG_o : std_logic_vector(Byte downto 0) := (others => '0');	
	
	alias FIRIFG_o               : std_logic is IFG_o(6); -- status / FIROUT
	alias KEY3IFG_o              : std_logic is IFG_o(5);
	alias KEY2IFG_o              : std_logic is IFG_o(4);
	alias KEY1IFG_o              : std_logic is IFG_o(3);
	alias BTIFG_o                : std_logic is IFG_o(2);
	alias TXIFG_o                : std_logic is IFG_o(1);
	alias RXIFG_o                : std_logic is IFG_o(0);
	alias UART_status_error_IFG_o: std_logic is IFG_o(7);
	alias FIFO_status_IFG_o      : std_logic is IFG_o(8);
	
begin

zero_vec <= (others => '0');
HighZ_vec <= (others => 'Z');

--------------- synchronic output implementation-----------------
--IE Reg
process(rst_tb,MSCLK)
	begin
		if (rst_tb = '1') then 
			IE_r <= (others => '1');
		elsif (rising_edge(MSCLK)) then 
			if (CS(0) = '1' and MemWrite_DM_i ='1') then --seperated because of Quartus error
				 FIRIE_r                <= Din(6); 
				 KEY3IE_r               <= Din(5);
				 KEY2IE_r               <= Din(4);
				 KEY1IE_r               <= Din(3);
				 BTIE_r                 <= Din(2);
				 TXIE_r                 <= Din(1);
				 RXIE_r                 <= Din(0);
				 UART_status_error_IE_r <= Din(0);
				 FIFO_status_IE_r       <= Din(6);
			end if;
			IE_o <= IE_r;
		end if;
	end process;
				
--reset update
process(MSCLK)
	begin
		if (rising_edge(MSCLK)) then
			reset_IFG_o <= reset_w; -- updating at rising edge the reset so the process would be sychronic
		end if;
	end process;


-------IFG config

IFG_r(7) <= '1' WHEN (UART_status_error_irq_w = '1' AND UART_status_error_IE_o = '1') ELSE '0';
IFG_r(0) <= '1' WHEN (RX_irq_w = '1' 				AND RXIE_o = '1') ELSE '0';		       
IFG_r(1) <= '1' WHEN (TX_irq_w = '1' 				AND TXIE_o = '1') ELSE '0';               
IFG_r(2) <= '1' WHEN (BT_irq_w = '1' 				AND BTIE_o = '1') ELSE '0';               
IFG_r(3) <= '1' WHEN (KEY1_irq_w = '1' 				AND KEY1IE_o = '1') ELSE '0';           
IFG_r(4) <= '1' WHEN (KEY2_irq_w = '1' 				AND KEY2IE_o = '1') ELSE '0';           
IFG_r(5) <= '1' WHEN (KEY3_irq_w = '1' 				AND KEY3IE_o = '1') ELSE '0';           
IFG_r(6) <= '1' when (FIR_irq_w = '1' 				and FIRIE_o = '1') else '0';             
IFG_r(8) <= '1' when (FIFO_status_irq_w = '1' 		and FIFO_status_IE_o = '1') else '0';          

process(rst_tb, MSCLK)
begin
    if (rst_tb = '1') then 
        IFG_o <= (others => '0');
    elsif (rising_edge(MSCLK)) then
        if (CS(1) = '1' and MemWrite_DM_i ='1') then 
            IFG_o <= Din(Byte downto 0);
        else
            IFG_o <= IFG_r; 
        end if;
    end if;
end process;



------------------------------------------------------------------------------------------
--TYPE Reg asynchronic update
--Type according to assignment -> goes according to priority!!
Type_r <= x"00" when reset_IFG_o	= '1' else 
		  x"04" when UART_status_error_IFG_o = '1' else --UART status error =>RXIFG
		  x"08" when RXIFG_o 	= '1' else 						 --UART RX =>RXIFG
		  x"0C" when TXIFG_o 	= '1' else --UART TX
		  x"10" when BTIFG_o 	= '1' else --BT
		  x"14" when KEY1IFG_o 	= '1' else --KEY1
		  x"18" when KEY2IFG_o 	= '1' else --KEY2
		  x"1C" when KEY3IFG_o 	= '1' else --KEY3
		  x"20" when FIFO_status_IFG_o = '1' else --FIFO Status => FIRIFG
		  x"24" when FIRIFG_o 	= '1' else 		  --FIROUT	=> FIRIFG
		  x"00";

process(rst_tb,MSCLK)
	begin
		if (rst_tb = '1') then 
			TYPE_o <= (others => '0');
		elsif (CS(2) = '1' and MemWrite_DM_i ='1') then 
			TYPE_o <= Din(Byte-1 downto 0);
		elsif (rising_edge(MSCLK)) then
			TYPE_o <= Type_r;
		end if;
	end process;
			
-------------------------------------bidirpin inputs implementation-------------------------------------
--CS implementation
with address_i select
CS <= 	"001" when ADDR_IE,
		"010" when ADDR_IFG,
		"100" when ADDR_TYPE,
		"000" when others;
		
--writing/reading data from interrupt controller
	
Dout <= zero_vec(n-1 downto 8) & Type_o when (INTA = '0' or (CS(2) = '1' and MemRead_DM_i = '1')) else -- acknowledged last intrrupt or CPU asks to read TYPE
		zero_vec(n-1 downto 9) & IFG_o when (CS(1) = '1' and MemRead_DM_i ='1') else -- CPU asks to read IFG
		zero_vec(n-1 downto 9) & IE_o when (CS(0) = '1' and MemRead_DM_i ='1') else -- CPU asks to read IE
		HighZ_vec;

--enable conditions
DataBus_i_en <= '1' when (MemRead_DM_i = '1' and (CS(0) = '1' or CS(1) = '1' or CS(2) = '1')) or (INTA = '0') else '0';


--        BidirPin generic map(Dwidth) port map (Dout,en,Din,IOpin);
DataBus_i_tristate:	BidirPin generic map(n) port map (Dout => Dout,en => DataBus_i_en,Din => Din,IOpin => DataBus_i);
------------------------------------------------------------------------------------------------------------------------


---------------INTR from several sources ARCHITECTURE----------------
INTR <= (GIE_i and Intrrupt_req_w) or reset_IFG_o;

Intrrupt_req_w <= FIRIFG_o or KEY3IFG_o or KEY2IFG_o or KEY1IFG_o or BTIFG_o or TXIFG_o or RXIFG_o;



/*
at the begginings i had process which followed the priority but it missed when two INTR 
happened toghether so the IFG registrer is updated by priority

process (irq_w,rst_tb,rst_KEY0,FIR_IRQ,KEY3_IRQ,KEY2_IRQ,KEY1_IRQ,BT_IRQ,
		FIRIE,KEY3IE,KEY2IE,KEY1IE,BTIE,TXIE,RXIE)
*/


		--rst INTR
process (rst_KEY0, rst_tb, clr_reset)
begin 
		if (rst_tb = '1' or clr_reset ='1') then
			reset_w 	<= '0';
		elsif (rising_edge(rst_KEY0)) then -- HW reset
			reset_w <= '1';
		end if;
end process;


--UART PART - BONUS 

		--UART status error INTR
process(rst_tb,UART_status_error_irq,UART_status_error_clr_w)
begin
		if (rst_tb = '1' or UART_status_error_clr_w = '1') then
			UART_status_error_irq_w <= '0';
		elsif (rising_edge(UART_status_error_irq)) then
			UART_status_error_irq_w <= '1';
		end if;
end process;		

		--RX INTR
process(rst_tb,RX_IRQ,RX_clr_w)
begin
		if (rst_tb = '1' or RX_clr_w = '1') then
			RX_irq_w <= '0';
		elsif (rising_edge(RX_IRQ)) then
			RX_irq_w <= '1';
		end if;
end process;		
			
		--TX INTR
process(rst_tb,TX_IRQ,TX_clr_w)
begin
		if (rst_tb = '1' or TX_clr_w = '1') then
			TX_irq_w <= '0';
		elsif (rising_edge(TX_IRQ)) then
			TX_irq_w <= '1';
		end if;
end process;				


		--BT INTR
process(rst_tb,BT_IRQ_i,BT_clr_w)
begin
		if (rst_tb = '1' or BT_clr_w = '1') then
			BT_irq_w <= '0';
		elsif (rising_edge(BT_IRQ_i)) then
			BT_irq_w <= '1';
		end if;
end process;					
			
		--KEY1 INTR
process(rst_tb,KEY1_IRQ_i,KEY1_clr_w)
begin
		if (rst_tb = '1' or KEY1_clr_w = '1') then
			KEY1_irq_w <= '0';
		elsif (rising_edge(KEY1_IRQ_i)) then
			KEY1_irq_w <= '1';
		end if;
end process;		

		--KEY2 INTR
process(rst_tb,KEY2_IRQ_i,KEY2_clr_w)
begin
		if (rst_tb = '1' or KEY2_clr_w = '1') then
			KEY2_irq_w <= '0';
		elsif (rising_edge(KEY2_IRQ_i)) then
			KEY2_irq_w <= '1';
		end if;
end process;	
			
		--KEY3 INTR
process(rst_tb,KEY3_IRQ_i,KEY3_clr_w)
begin
		if (rst_tb = '1' or KEY3_clr_w = '1') then
			KEY3_irq_w <= '0';
		elsif (rising_edge(KEY3_IRQ_i)) then
			KEY3_irq_w <= '1';
		end if;
end process;		

		--FIFO status INTR
process(rst_tb,FIFO_status_IRQ_i,FIFO_status_clr_w)
begin
		if (rst_tb = '1' or FIFO_status_clr_w = '1') then
			FIFO_status_irq_w <= '0';
		elsif (rising_edge(FIFO_status_IRQ_i)) then
			FIFO_status_irq_w <= '1';
		end if;
end process;	

		--FIFO status INTR
process(rst_tb,FIR_IRQ_i,FIR_clr_w)
begin
		if (rst_tb = '1' or FIR_clr_w = '1') then
			FIR_irq_w <= '0';
		elsif (rising_edge(FIR_IRQ_i)) then
			FIR_irq_w <= '1';
		end if;
end process;


--clear config
clr_reset					<= '1' when (INTA = '0' AND Type_o = x"00") else '0';
UART_status_error_clr_w		<= '1' when (INTA = '0' AND Type_o = x"04") else '0';
RX_clr_w 					<= '1' when (INTA = '0' AND Type_o = x"08") else '0';
TX_clr_w 					<= '1' when (INTA = '0' AND Type_o = x"0C") else '0';
BT_clr_w 					<= '1' when (INTA = '0' AND Type_o = x"10") else '0';
KEY1_clr_w 					<= '1' when (INTA = '0' AND Type_o = x"14") else '0';	
KEY2_clr_w 					<= '1' when (INTA = '0' AND Type_o = x"18") else '0';	
KEY3_clr_w 					<= '1' when (INTA = '0' AND Type_o = x"1C") else '0';	
FIFO_status_clr_w 			<= '1' when (INTA = '0' AND Type_o = x"20") else '0';
FIR_clr_w 					<= '1' when (INTA = '0' AND Type_o = x"24") else '0';

end struct;