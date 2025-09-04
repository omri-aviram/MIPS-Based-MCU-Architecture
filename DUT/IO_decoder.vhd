LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
USE work.const_package.all;
----------------------------------------------------------------
ENTITY IO_Decoder is
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
  
end IO_Decoder;
----------------------------------------------------------------
ARCHITECTURE struct OF IO_Decoder IS 
		
		
		signal zero_vec: 											std_logic_vector(n-1 downto 0);
		signal rst_w: 												std_logic;
		--Bidirpin signals
		--IO bidirpin
		signal Dout_SW,Dout_LEDS,Dout_HEX0,Dout_HEX1,Dout_HEX2,Dout_HEX3,Dout_HEX4,Dout_HEX5: 											std_logic_vector(n-1 downto 0);
		signal Din_SW,Din_LEDS,Din_HEX0,Din_HEX1,Din_HEX2,Din_HEX3,Din_HEX4,Din_HEX5: 											std_logic_vector(n-1 downto 0);
		signal DataBus_i_en: 										std_logic;
		--optimized Address Decoder
		signal CS: 													std_logic_vector(6 downto 0):= (others =>'0');
		signal decoder_address: 									std_logic_vector(3 downto 0);
		--enables for tristate					
		signal SW7to0_en: 											std_logic := '0';
		signal LEDS_en_read, HEX0_en_read, HEX1_en_read, HEX2_en_read, HEX3_en_read, HEX4_en_read, HEX5_en_read: 	std_logic := '0'; --into the Dlatch
		signal LEDS_en_write, HEX0_en_write, HEX1_en_write, HEX2_en_write, HEX3_en_write, HEX4_en_write, HEX5_en_write: 	std_logic := '0'; -- out to Data
		--IO to Tristate
		signal SW7to0_extended: 									std_logic_vector(n-1 downto 0);
		signal LEDS_w: 												std_logic_vector(n-1 downto 0);
		signal HEX0_w, HEX1_w, HEX2_w, HEX3_w, HEX4_w, HEX5_w: 		std_logic_vector(n-1 downto 0);
		
begin

rst_w <= rst_KEY0 or rst_tb;
SW7to0_extended <= x"000000" & SW7to0;
zero_vec <= (others => '0');

-----------address handler-----------
decoder_address <= address_i(11) & address_i(4 downto 2);

process(address_i)
begin
	case address_i is
		when ADDR_PORT_SW => CS <= "1000000";  -- CS(6) = 1 -> 0x810 - PORT_SW
		when ADDR_PORT_HEX0 => CS <= "0100000";  -- CS(5) = 1 -> 0x804 - HEX0
		when ADDR_PORT_HEX1 => CS <= "0100000";  -- CS(5) = 1 -> 0x805 - HEX1
		when ADDR_PORT_HEX2 => CS <= "0010000";  -- CS(4) = 1 -> 0x808 - HEX2
		when ADDR_PORT_HEX3 => CS <= "0010000";  -- CS(4) = 1 -> 0x809 - HEX3
		when ADDR_PORT_HEX4 => CS <= "0001000";  -- CS(3) = 1 -> 0x80C - HEX4
		when ADDR_PORT_HEX5 => CS <= "0001000";  -- CS(3) = 1 -> 0x80D - HEX5
		when ADDR_PORT_LEDR => CS <= "0000001";  -- CS(0) = 1 -> 0x800 - PORT_LEDR
		when others => CS <= "0000000";  -- default: none selected
	end case;
end process;

-----------enables configuration-----------
SW7to0_en <= '1' when (MemRead_DM_i = '1' and CS(6) = '1' and rst_w = '0') else '0';

-- LED configuration
LEDS_en_read <= '1' when (MemRead_DM_i = '1' and CS(0) = '1' and rst_w = '0') else '0';
LEDS_en_write <= '1' when (MemWrite_DM_i = '1' and CS(0) = '1' and rst_w = '0') else '0';

-- HEX0 - 0x804
HEX0_en_read <= '1' when (MemRead_DM_i = '1' and CS(5) = '1' and address_i(0) = '0' and rst_w = '0') else '0';
HEX0_en_write <= '1' when (MemWrite_DM_i = '1' and CS(5) = '1' and address_i(0) = '0' and rst_w = '0') else '0';

-- HEX1 - 0x805
HEX1_en_read <= '1' when (MemRead_DM_i = '1' and CS(5) = '1' and address_i(0) = '1' and rst_w = '0') else '0';
HEX1_en_write <= '1' when (MemWrite_DM_i = '1' and CS(5) = '1' and address_i(0) = '1' and rst_w = '0') else '0';

-- HEX2 - 0x808
HEX2_en_read <= '1' when (MemRead_DM_i = '1' and CS(4) = '1' and address_i(0) = '0' and rst_w = '0') else '0';
HEX2_en_write <= '1' when (MemWrite_DM_i = '1' and CS(4) = '1' and address_i(0) = '0' and rst_w = '0') else '0';

-- HEX3 - 0x809
HEX3_en_read <= '1' when (MemRead_DM_i = '1' and CS(4) = '1' and address_i(0) = '1' and rst_w = '0') else '0';
HEX3_en_write <= '1' when (MemWrite_DM_i = '1' and CS(4) = '1' and address_i(0) = '1' and rst_w = '0') else '0';

-- HEX4 - 0x80C
HEX4_en_read <= '1' when (MemRead_DM_i = '1' and CS(3) = '1' and address_i(0) = '0' and rst_w = '0') else '0';
HEX4_en_write <= '1' when (MemWrite_DM_i = '1' and CS(3) = '1' and address_i(0) = '0' and rst_w = '0') else '0';

-- HEX5 - 0x80D
HEX5_en_read <= '1' when (MemRead_DM_i = '1' and CS(3) = '1' and address_i(0) = '1' and rst_w = '0') else '0';
HEX5_en_write <= '1' when (MemWrite_DM_i = '1' and CS(3) = '1' and address_i(0) = '1' and rst_w = '0') else '0';




-----------Dout configuration-----------

--        BidirPin generic map(Dwidth) port map (Dout,en,Din,IOpin);

SW0to7_port_i: 	BidirPin generic map(n) port map (SW7to0_extended,SW7to0_en,Din_SW,data_IO);

LEDS_port_i:	BidirPin generic map(n) port map (LEDS_w,LEDS_en_read,Din_LEDS,data_IO);
		  
HEX0_port_i: 	BidirPin generic map(n) port map (HEX0_w,HEX0_en_read, Din_HEX0,data_IO);

HEX1_port_i: 	BidirPin generic map(n) port map (HEX1_w,HEX1_en_read, Din_HEX1,data_IO);

HEX2_port_i: 	BidirPin generic map(n) port map (HEX2_w,HEX2_en_read, Din_HEX2,data_IO);

HEX3_port_i: 	BidirPin generic map(n) port map (HEX3_w,HEX3_en_read, Din_HEX3,data_IO);

HEX4_port_i: 	BidirPin generic map(n) port map (HEX4_w,HEX4_en_read, Din_HEX4,data_IO);

HEX5_port_i: 	BidirPin generic map(n) port map (HEX5_w,HEX5_en_read, Din_HEX5,data_IO);


-----------Dlatch didnt work well (signals were overwritten when changed address)
---Dout of the 

PROCESS (MSCLK, rst_w)
begin
	IF rst_w = '1' THEN
      LEDS_w <= (others => '0');
      HEX0_w <= (others => '0');
      HEX1_w <= (others => '0');
      HEX2_w <= (others => '0');
      HEX3_w <= (others => '0');
      HEX4_w <= (others => '0');
      HEX5_w <= (others => '0');

    ELSIF rising_edge(MSCLK) THEN
		if LEDS_en_write = '1' then
			LEDS_w <= zero_vec(n-1 downto 8) & Din_SW(7 downto 0);
		elsif HEX0_en_write = '1' then
			HEX0_w <= zero_vec(n-1 downto 4) & Din_HEX0(3 downto 0);
		elsif HEX1_en_write = '1' then
			HEX1_w <= zero_vec(n-1 downto 4) & Din_HEX1(3 downto 0);
		elsif HEX2_en_write = '1' then
			HEX2_w <= zero_vec(n-1 downto 4) & Din_HEX2(3 downto 0);
		elsif HEX3_en_write = '1' then
			HEX3_w <= zero_vec(n-1 downto 4) & Din_HEX3(3 downto 0);
		elsif HEX4_en_write = '1' then
			HEX4_w <= zero_vec(n-1 downto 4) & Din_HEX4(3 downto 0);
		elsif HEX5_en_write = '1' then
			HEX5_w <= zero_vec(n-1 downto 4) & Din_HEX5(3 downto 0);
		end if;
	end if;
end process;
	
-----outputs assigning
LEDS 	<=	LEDS_w(7 downto 0); 										
HEX0	<=	HEX0_w(3 downto 0); 
HEX1	<=	HEX1_w(3 downto 0); 
HEX2	<=	HEX2_w(3 downto 0); 
HEX3	<=	HEX3_w(3 downto 0); 
HEX4	<=	HEX4_w(3 downto 0); 
HEX5	<=	HEX5_w(3 downto 0); 


end struct;


