library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
------------------------------------------------------------------ 
entity Counter is 
	generic(n 						: integer := 32);
	port (rst,clk,enable	 		: in std_logic;
		  EQUY,Counter_write		: in std_logic:= '0';	
		  Q24,Q28,Q32				: out std_logic :='0';	
		  BTCNT_i 					: in std_logic_vector (n-1 downto 0) := (others => '0'); 
		  BTCNT_o 					: out std_logic_vector (n-1 downto 0) := (others => '0')
		  ); 
		  
end Counter;
------------------------------------------------------------------ 

architecture rtl of Counter is
    
begin
    process (clk, rst,EQUY) 
	variable zeros_Vec	 						: std_logic_vector (n-1 downto 0):= (others => '0');
	variable BTCNT_w  							: std_logic_vector (n-1 downto 0):= (others => '0');
    begin
        if ((rst = '1') or (EQUY = '1'))and BTCNT_w /= zeros_Vec then
				BTCNT_w := (others => '0');
		elsif((enable = '0') and (rising_edge(clk))) then
			if (Counter_write = '1') then 
				BTCNT_w := BTCNT_i;
			else 
				BTCNT_w := BTCNT_w + 1; -- rising edge and enable = '0'
				
			end if;
	    end if;
		Q24 <= BTCNT_w(23);
		Q28 <= BTCNT_w(27);
		Q32 <= BTCNT_w(31);
		BTCNT_o <= BTCNT_w;
    end process;
end rtl;
