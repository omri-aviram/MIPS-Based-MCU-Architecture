library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-----------------------------------------------------------------
entity DFF_lab is
	generic ( Dwidth : integer := 32 );
    port (clk : in  std_logic;
      rst : in  std_logic;
      D   : in  std_logic_vector(Dwidth-1 downto 0);
      Q   : out std_logic_vector(Dwidth-1 downto 0)
    );
end DFF_lab;

architecture sync of DFF_lab is

begin 
	process(clk, rst)
	begin
		if (rst ='1') then
			Q <= (others =>'0');
		elsif (rising_edge(clk)) then
			Q <= D;
		end if;
	end process;
	
end sync;

