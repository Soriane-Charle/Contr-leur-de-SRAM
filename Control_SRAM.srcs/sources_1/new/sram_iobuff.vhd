library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram_ctrl3 is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;

        -- Command interface
        wr_en   : in  std_logic;
        rd_en   : in  std_logic;
        addr_i  : in  std_logic_vector(18 downto 0);
        wdata_i : in  std_logic_vector(35 downto 0);
        rdata_o : out std_logic_vector(35 downto 0);
        ready   : out std_logic;

        -- SRAM interface
        DQ      : inout std_logic_vector(35 downto 0);
        Addr    : out std_logic_vector(18 downto 0);
        nCKE    : out std_logic;
        nADVLD  : out std_logic;
        nRW     : out std_logic;
        nOE     : out std_logic;
        nCE     : out std_logic;
        nCE2    : out std_logic;
        CE2     : out std_logic
    );
end entity;

architecture rtl of sram_ctrl3 is

    ------------------------------------------------------------------
    -- FSM
    ------------------------------------------------------------------
    type state_t is (IDLE, WRITE, READ, TURN);
    signal state, next_state : state_t := IDLE;

    ------------------------------------------------------------------
    -- Data bus control
    ------------------------------------------------------------------
    signal dq_out  : std_logic_vector(35 downto 0);
    signal dq_oe   : std_logic;

    ------------------------------------------------------------------
    -- Registered read data
    ------------------------------------------------------------------
    signal rdata_reg : std_logic_vector(35 downto 0);

begin

    ------------------------------------------------------------------
    -- Bidirectional data bus
    ------------------------------------------------------------------
    DQ <= dq_out when dq_oe = '1' else (others => 'Z');
    rdata_o <= rdata_reg;

    ------------------------------------------------------------------
    -- Constant SRAM control (always enabled)
    ------------------------------------------------------------------
    nCKE   <= '0';
    nADVLD <= '0';
    nCE    <= '0';
    nCE2   <= '0';
    CE2    <= '1';

    ------------------------------------------------------------------
    -- State register
    ------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            state     <= IDLE;
            rdata_reg <= (others => '0');
        elsif rising_edge(clk) then
            state <= next_state;

            -- Register read data ONE cycle later
            if state = READ then
                rdata_reg <= DQ;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Next-state logic
    ------------------------------------------------------------------
    process(state, wr_en, rd_en)
    begin
        next_state <= state;

        case state is
            when IDLE =>
                if wr_en = '1' then
                    next_state <= WRITE;
                elsif rd_en = '1' then
                    next_state <= READ;
                end if;

            when WRITE =>
                if rd_en = '1' then
                    next_state <= TURN;   -- WRITE ? READ
                elsif wr_en = '0' then
                    next_state <= IDLE;
                end if;

            when READ =>
                if wr_en = '1' then
                    next_state <= TURN;   -- READ ? WRITE
                elsif rd_en = '0' then
                    next_state <= IDLE;
                end if;

            when TURN =>
                if wr_en = '1' then
                    next_state <= WRITE;
                elsif rd_en = '1' then
                    next_state <= READ;
                else
                    next_state <= IDLE;
                end if;
        end case;
    end process;

    ------------------------------------------------------------------
    -- Output logic
    ------------------------------------------------------------------
    process(state, addr_i, wdata_i)
    begin
        -- defaults
        Addr  <= addr_i;
        dq_out <= wdata_i;
        dq_oe <= '0';
        nRW   <= '1';
        nOE   <= '1';
        ready <= '0';

        case state is
            when IDLE =>
                ready <= '1';

            when WRITE =>
                dq_oe <= '1';
                nRW   <= '0';

            when READ =>
                dq_oe <= '0';
                nOE   <= '0';

            when TURN =>
                -- full Hi-Z cycle (bus turnaround)
                dq_oe <= '0';
                nRW   <= '1';
                nOE   <= '1';
        end case;
    end process;

end architecture;
