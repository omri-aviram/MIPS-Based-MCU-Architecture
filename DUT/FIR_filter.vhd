---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.const_package.all;
USE work.aux_package.all;
USE work.FIR_package.all;

ENTITY FIR_Filter is
    GENERIC (n:         INTEGER := 32;
             M:         INTEGER := 8;
             W:         INTEGER := 24; -- only for check 25
             q:         INTEGER := 8;
             k:         INTEGER := 8;
             ptr_size:  INTEGER := 3;
             Byte:      INTEGER := 8);
    PORT (rst_KEY0,rst_tb,FIFOCLK: IN  std_logic;
          FIRCLK:                   IN  std_logic;
          FIFOEMPTY_IFG,FIRIFG:     OUT std_logic;
          data_IO:                  inout std_logic_vector(n-1 downto 0);
          address_i:                in  std_logic_vector(11 downto 0);
          MemWrite_DM_i,MemRead_DM_i: in std_logic);
end FIR_Filter;

ARCHITECTURE struct OF FIR_Filter IS
    signal Zero_vec:            std_logic_vector(n-1 downto 0) := (others => '0');
    signal dataIO_en_read:     std_logic := '0';
    signal Dout,Din:            std_logic_vector(n-1 downto 0):= (others => '0');

    signal FIROUT,FIRIN:        std_logic_vector(n-1 downto 0) := (others => '0');
    signal COEFs:               vector_array_q(M-1 downto 0)(q-1 downto 0):= (others =>(others => '0'));

    signal FIRCTL:              std_logic_vector(Byte-1 downto 0):="UU010010";
    alias FIFOWEN   : std_logic is FIRCTL(5);
    alias FIFORST   : std_logic is FIRCTL(4);
    alias FIFOFULL  : std_logic is FIRCTL(3);
    alias FIFOEMPTY : std_logic is FIRCTL(2);
    alias FIRRST    : std_logic is FIRCTL(1);
    alias FIRENA    : std_logic is FIRCTL(0);

    signal DATAOUT:  std_logic_vector(W-1 downto 0);
    signal FIFOREN:  std_logic := '0';
    signal FIFOIN:   std_logic_vector(W-1 downto 0) := (others => '0');

    signal xn:       vector_array_w(M-1 downto 0)(W-1 downto 0):= (others =>(others => '0'));
    signal c_mul:    vector_array_wq(M-1 downto 0)(W+q-1 downto 0):= (others =>(others => '0'));
    signal c_add:    vector_array_wq(M-1 downto 1)(W+q-1 downto 0):= (others =>(others => '0'));
    signal yn:       std_logic_vector(W+q-1 downto 0):= (others => '0');

    signal rst_w,FIFOEMPTY_w: std_logic := '0';

    -- FIR
    signal fir_tog : std_logic := '0';
    signal fir_tog_curr, fir_tog_prev : std_logic := '0';
    signal fiforen_pulse : std_logic := '0';
	signal RST_forFIR:	std_logic := '0';
    -- FIRIFG pulse 
    signal fir_first_done       : std_logic := '0';
    signal firifg_pulse_firclk  : std_logic := '0';
    signal ifg_tog_fir          : std_logic := '0';
    signal ifg_curr, ifg_prev       : std_logic := '0';
    signal firifg_pulse_fifoclk : std_logic := '0';

    --immediate one-shot for FIFOWEN on FIRCTL write
    signal wr_firctl     : std_logic;
    signal wr_firctl_prev   : std_logic := '0';
    signal FIFOWEN_pulse : std_logic := '0';
	
begin
    rst_w <= rst_tb or rst_KEY0;
    Zero_vec <= (others => '0');

    ----------------- IO tristate -----------------
    dataIO_en_read <= '1' when ((address_i = ADDR_FIRCTL or address_i = ADDR_FIRIN or address_i = ADDR_FIROUT or address_i = ADDR_COEF3_0 or address_i = ADDR_COEF7_4)
              and (MemRead_DM_i = '1'))
        else '0';

    data_IO_tristate_read: BidirPin
        generic map(n)
        port map (
		Dout => Dout,
		en => dataIO_en_read,
		Din => Din,
		IOpin => data_IO
		);

    Dout <= Zero_vec(n-1 downto Byte) & FIRCTL when (address_i = ADDR_FIRCTL) else
            FIRIN when (address_i = ADDR_FIRIN)  else
            FIROUT when (address_i = ADDR_FIROUT) else
            COEFs(3) & COEFs(2) & COEFs(1) & COEFs(0) when address_i = ADDR_COEF3_0 else
            COEFs(7) & COEFs(6) & COEFs(5) & COEFs(4) when address_i = ADDR_COEF7_4 else
            (others => 'Z');

    ----------------- Data_IO write-----------------
    wr_firctl <= '1' when (MemWrite_DM_i = '1' and address_i = ADDR_FIRCTL) else '0';

    process (FIFOCLK, rst_w)
    begin
      if rst_w = '1' then
        FIRCTL(4) <= '0';                 -- FIFORST
        FIRCTL(1 downto 0) <= (others => '0');  -- FIRRST,FIRENA
        COEFs <= (others => (others => '0'));
        wr_firctl_prev <= '0';
		FIRIN <= (others => '0');
      elsif rising_edge(FIFOCLK) then
        -- capture write edge to compare last cycle to current
        wr_firctl_prev <= wr_firctl;
        if wr_firctl = '1' then
			---FIFOWEN is treated elsewhere - because it need to be changed  by HW
            FIRCTL(4) <= Din(4);          -- FIFORST
            FIRCTL(1 downto 0) <= Din(1 downto 0); -- FIRRST,FIRENA
        end if;

        -- FIRIN / COEFs writes unchanged
        if (MemWrite_DM_i = '1') and (address_i = ADDR_FIRIN) then
            FIRIN <= Din;
        elsif (MemWrite_DM_i = '1') and (address_i = ADDR_COEF3_0) then
            COEFs(0) <= Din(7  downto 0);
            COEFs(1) <= Din(15 downto 8);
            COEFs(2) <= Din(23 downto 16);
            COEFs(3) <= Din(31 downto 24);
        elsif (MemWrite_DM_i = '1') and (address_i = ADDR_COEF7_4) then
            COEFs(4) <= Din(7  downto 0);
            COEFs(5) <= Din(15 downto 8);
            COEFs(6) <= Din(23 downto 16);
            COEFs(7) <= Din(31 downto 24);
        end if;
      end if;
    end process;
---------------creating FIFOWEN pulse for 1-cycle-----------------------
    --we first load the FIRCTL so we wont change the state of the FIR - if FIRENA = 1 it will stay 1 and vice versa (was 0 => stays 0)
	FIFOWEN_pulse <= '1' when (wr_firctl = '1' and wr_firctl_prev = '0' and Din(5) = '1') else '0'; 
    FIFOWEN <= FIFOWEN_pulse; 

    ---------------------------- FIFO unit ------------------------------
    FIFOEMPTY     <= FIFOEMPTY_w and FIRENA;
    FIFOEMPTY_IFG <= FIFOEMPTY_w and FIRENA and not(rst_w);

    FIFOIN <= FIRIN(W-1 downto 0);

    synchronus_FIFO: sync_fifo
        generic map(
            cell_size => W,
            k         => k,
            ptr_size  => ptr_size
        )
        port map(
            rst_i     => rst_w,
            FIFOCLK   => FIFOCLK,
            FIFORST   => FIFORST,
            FIFOWEN   => FIFOWEN,     -- one-shot pulse this same cycle
            FIFOREN   => FIFOREN,
            FIFOIN    => FIFOIN,
            DATAOUT   => DATAOUT,
            FIFOFULL  => FIFOFULL,    -- FULL updates same cycle with next_count in FIFO
            FIFOEMPTY => FIFOEMPTY_w
        );

    ---------------------------- FIFOREN generation toggle sync ------------------------------
    --FIFOREN needs to rise FOR 1-FIFOCLK Cycle if (rising_edge(FIRCLK) and FIRENA = '1') *when* rising_edge(FIFOCLK)

--processes of FIRCLK	
	process(FIRCLK, rst_w)
    begin
      if rst_w = '1' then
        fir_tog <= '0';
      elsif rising_edge(FIRCLK) then
        if FIRENA = '1' then
            fir_tog <= not fir_tog; --toggle every rising FIRCLK *if* FIRENA = '1'
        end if;
      end if;
    end process;

--processes of FIRCLK 
    process(FIFOCLK, rst_w)
    begin
      if rst_w = '1' then
        fir_tog_curr <= '0';
        fir_tog_prev <= '0';
      elsif rising_edge(FIFOCLK) then --updating every FIFOCLK
        fir_tog_curr <= fir_tog; --updating currnt toggle 
        fir_tog_prev <= fir_tog_curr; --updating previous toggle 
      end if;
    end process;

    process(FIFOCLK, rst_w)
    begin
      if rst_w = '1' then
        fiforen_pulse <= '0';
      elsif rising_edge(FIFOCLK) then
        fiforen_pulse <= fir_tog_curr xor fir_tog_prev;
      end if;
    end process;

    FIFOREN <= fiforen_pulse;
    ---------------------------- FIR datapath ------------------------------
    RST_forFIR <= FIRRST or rst_w;
	xn(0) <= DATAOUT;

    coef_DFF: for i in 0 to M-2 generate
      DFFs_port: DFF_lab
        generic map (Dwidth => W)
        port map (clk => FIRCLK, rst => RST_forFIR, D => xn(i), Q => xn(i+1));
    end generate;

    coef_MUL: for i in 0 to M-1 generate
        c_mul(i) <= COEFs(i) * xn(i);
    end generate;

    c_add(1) <= c_mul(0) + c_mul(1);

    coef_ADD: for i in 2 to M-1 generate
        c_add(i) <= c_add(i-1) +  c_mul(i);
    end generate;

    yn_DFF: DFF_lab generic map(Dwidth => W+q)
            port map(clk => FIRCLK, rst => FIRRST, D => c_add(M-1), Q => yn);

    process(FIRCLK,rst_w,FIRRST)
    begin
        if (RST_forFIR ='1') then
            FIROUT <= (others => '0');
        elsif rising_edge(FIRCLK) then
            FIROUT <= Zero_vec(7 downto 0) & yn(n-1 downto 8);
        end if;
    end process;


    ----------------------------FIRIFG - skip first to prevent first cycle zeros------------------------------
	
	--same Logic as FIFOREN
    process(FIRCLK, RST_forFIR)
    begin
      if RST_forFIR = '1' then
        fir_first_done      <= '0';
        firifg_pulse_firclk <= '0';
      elsif rising_edge(FIRCLK) then
        firifg_pulse_firclk <= '0';
        if FIRENA = '1' then
            if fir_first_done = '1' then --make sure that we'll skip the firs FIROUT so we wont get 0 in memory
                firifg_pulse_firclk <= '1'; --only change from FIFOREN
            end if;
            fir_first_done <= '1';
        end if;
      end if;
    end process;
    process(FIRCLK, RST_forFIR)
    begin
      if RST_forFIR = '1' then
        ifg_tog_fir <= '0';
      elsif rising_edge(FIRCLK) then
        if (firifg_pulse_firclk = '1') then
            ifg_tog_fir <= not ifg_tog_fir;
        end if;
      end if;
    end process;

    process(FIFOCLK, RST_forFIR)
    begin
      if RST_forFIR = '1' then
        ifg_curr <= '0';
        ifg_prev <= '0';
      elsif rising_edge(FIFOCLK) then
        ifg_curr <= ifg_tog_fir;
        ifg_prev <= ifg_curr;
      end if;
    end process;

    process(FIFOCLK, RST_forFIR)
    begin
      if RST_forFIR = '1' then
        firifg_pulse_fifoclk <= '0';
      elsif rising_edge(FIFOCLK) then
        firifg_pulse_fifoclk <= ifg_curr xor ifg_prev;
      end if;
    end process;

    FIRIFG <= firifg_pulse_fifoclk;
end struct;
