library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sync_fifo is
    generic (
        cell_size : integer := 24;  -- !!! 25 in upper modules
        k         : integer := 8;
        ptr_size  : integer := 3
    );
    port (
        rst_i     : in  std_logic;
        FIFOCLK   : in  std_logic;
        FIFORST   : in  std_logic;
        FIFOWEN   : in  std_logic;
        FIFOREN   : in  std_logic;
        FIFOIN    : in  std_logic_vector(cell_size-1 downto 0);
        DATAOUT   : out std_logic_vector(cell_size-1 downto 0);
        FIFOFULL  : out std_logic;
        FIFOEMPTY : out std_logic
    );
end sync_fifo;

architecture rtl of sync_fifo is
    -- Memory
    type mem_type is array(0 to k-1) of std_logic_vector(cell_size-1 downto 0);
    signal mem      : mem_type := (others => (others => '0'));
    signal dout_reg : std_logic_vector(cell_size-1 downto 0) := (others => '0');

    -- Pointers / count
    signal wr_ptr : std_logic_vector(ptr_size-1 downto 0) := (others => '0');
    signal rd_ptr : std_logic_vector(ptr_size-1 downto 0) := (others => '0');
    signal count  : std_logic_vector(ptr_size downto 0)    := (others => '0');

    -- Flags (registered)
    signal full_r  : std_logic := '0';
    signal empty_r : std_logic := '1';

    -- Reset combine
    signal rst_w : std_logic := '0';

    -- Constants
    constant ZERO_VEC : std_logic_vector(ptr_size downto 0) := (others => '0');
    constant K_VEC    : std_logic_vector(ptr_size downto 0) := conv_std_logic_vector(k, ptr_size+1);
begin

    rst_w <= rst_i or FIFORST;

    -- Single-clock core (FIFOCLK)
    process(FIFOCLK, rst_w) --working with variabls for fast updates
        variable next_count : std_logic_vector(ptr_size downto 0);
        variable r_ok, w_ok : boolean;
    begin
        if rst_w = '1' then
            wr_ptr   <= (others => '0');
            rd_ptr   <= (others => '0');
            dout_reg <= (others => '0');
            count    <= (others => '0');
            full_r   <= '0';
            empty_r  <= '1';

        elsif rising_edge(FIFOCLK) then
			--Tell immidiately when empty/full
            r_ok := (FIFOREN = '1') and (count /= ZERO_VEC); 
            w_ok := (FIFOWEN = '1') and ( (count /= K_VEC) or r_ok ); --if we are full and we read data

            -- READ
            if r_ok then
                dout_reg <= mem(conv_integer(rd_ptr));
                rd_ptr   <= rd_ptr + 1;
            end if;

            -- WRITE
            if w_ok then
                mem(conv_integer(wr_ptr)) <= FIFOIN;
                wr_ptr <= wr_ptr + 1;
            end if;

            -- COUNT next-state
            next_count := count;
            if (w_ok and not r_ok) then --write and not read
                next_count := count + 1;
            elsif (r_ok and not w_ok) then --read and not write
                next_count := count - 1;
            else
                -- both or none => unchanged
                null;
            end if;

            -- Register updates
            count    <= next_count;
            if (next_count = ZERO_VEC) then
				empty_r  <= '1'; --happens immidiately
			else
				empty_r  <= '0';
			end if;
			if (next_count = K_VEC) then
				full_r   <= '1';  --happens immidiately
			else
				full_r   <= '0';
			end if;
		end if;
    end process;

    -- Outputs
    DATAOUT   <= dout_reg;
    FIFOEMPTY <= empty_r;
    FIFOFULL  <= full_r;

end rtl;
