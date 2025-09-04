library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
USE work.aux_package.all;
------------------------------------------------------------------ 
entity Basic_Timer is 
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
end Basic_Timer;
------------------------------------------------------------------
architecture rtl of Basic_Timer is
    signal counter_out									: std_logic_vector (n-1 downto 0);
    signal CNT_w										: std_logic_vector (3 downto 0):=(others => '0');
	signal HEU0,clk,Q24,Q28,Q32							: std_logic;
	signal Clear_clk									: std_logic;
	signal PWM_SetReset,PWM_ResetSet					: std_logic := '0'; --Output signals
begin

Clear_clk <= BTCLR or rst_i;
BTCNT_o <= counter_out;


--Counter generic map(n) port map(rst,clk,enable,EQUY,Q24,Q28,Q32,BTCNT);
Counter_Ports: Counter generic map(n) 
					   port map (rst => Clear_clk,clk => clk,enable => BTHOLD,EQUY => HEU0,Counter_write => Counter_write,
								Q24 => Q24,Q28 => Q28,Q32 => Q32,BTCNT_i => BTCNT_i, BTCNT_o => counter_out
								); 

process (MSCLK) --clk divide select
	begin
		if rising_edge(MSCLK) then
			CNT_w <= CNT_w + 1; -- unsigned counter
--			case BTSSEL is 
--				when "00" => clk <= MSCLK;
--				when "01" => clk <= CNT_w(0); --division by 2
--				when "10" => clk <= CNT_w(1); --division by 4
--				when "11" => clk <= CNT_w(2); --division by 8
--				when others => clk <= '0';
--			end case;
		end if;
end process;



clk <= MSCLK when BTSSEL = "00" else
		CNT_w(0) when BTSSEL = "01" else
		CNT_w(1) when BTSSEL = "10" else
		CNT_w(2) when BTSSEL = "11";

process (clk)
begin -- we had toggle option in lab 4
    if (rising_edge(clk)) then
		if ((BTCCR1 > BTCCR0) or BTOUTEN = '0' or rst_i ='1') then
			PWM_SetReset <= '0';
			PWM_ResetSet <= '0';
			HEU0 <= '1'; 
		elsif(counter_out >= BTCCR0)then
			PWM_SetReset <= '0';
			PWM_ResetSet <= '1';
			HEU0 <= '1' ;
		elsif (BTCCR1 > counter_out+1) then
			PWM_SetReset <= '0';
			PWM_ResetSet <= '1';
			HEU0 <= '0';
		elsif (BTCCR1 <= counter_out+1) then
			PWM_SetReset <= '1';
			PWM_ResetSet <= '0';
			HEU0 <= '0';
		end if;
	end if;
end process;
	
with BTOUTMD select --select Output PWM
		PWM_out <= PWM_SetReset when '0',
				   PWM_ResetSet when '1',
				   '0' when others;
				   
BTIFG <= '0'  when (rst_i = '1' or BTOUTEN = '0' or BTCCR0 = 0) else
		 HEU0 when BTIP = "00"  else 
		 Q24  when BTIP = "01" else
		 Q28  when BTIP = "10" else 
		 Q32  when BTIP = "11" else
		 '0';			   

end rtl;
