library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity i2c_master is
    generic(
        sys_clk : integer := 1_600_000; -- module input clock in Hz
        bus_clk : integer :=   400_000  -- speed of I2C bus in Hz
    );
    port(
            clk : in std_logic;
        reset_n : in std_logic;

            ena : in std_logic;                     -- command latch signal
           addr : in std_logic_vector(6 downto 0);  -- target slave address
             rw : in std_logic;                     -- command : '0' - write,  '1' - read
        data_wr : in std_logic_vector(7 downto 0);  -- data to be written to slave
        data_rd : out std_logic_vector(7 downto 0); -- data read from  slave
           busy : out std_logic;                    -- transaction in progress
      ack_error : out std_logic;                    -- transaction error

            sda : inout std_logic;
            scl : inout std_logic
    );
end entity;

architecture behavior of i2c_master is
    signal data_clk : std_logic; -- data clock for sda
    signal data_clk_prev : std_logic; -- prev data clock [for edge detection]
    signal scl_clk  : std_logic; -- constantly running internal scl
    signal clk_stretch : std_logic; --indicates if slave is stretching scl
    signal scl_ena  : std_logic; -- enables scl_cls driving scl
    signal sda_int : std_logic; -- internal sda
    SIGNAL current_bit : integer range 0 TO 7 := 7;      --tracks bit number in transaction

    SIGNAL cmd     : std_logic_vector(7 DOWNTO 0);   --latched in address and read/write
    SIGNAL data_tx : std_logic_vector(7 DOWNTO 0);   --latched in data to write to slave
    SIGNAL data_rx : std_logic_vector(7 DOWNTO 0);   --data received from slave

    type State_Type is (READY, START, COMMAND, SLVACK1, SLVACK2, MSTACK, READ, WRITE, STOP);
    signal state : State_Type;
begin

    scl <= '0' when (scl_clk = '0' and scl_ena = '1') else 'Z';
    sda <= '0' when sda_int = '0' else 'Z';

    clk_proc : process(clk,reset_n)
        constant divider  : integer := (sys_clk / bus_clk) / 4;
        variable count    : integer range 0 to divider;
        variable clock_st : integer range 0 to 4;
    begin
        if reset_n = '0' then
            count := 0;
            clock_st := 0;
            clk_stretch <= '0';
            scl_clk  <= '0';
            data_clk <= '0';
        elsif rising_edge(clk) then
            data_clk_prev <= data_clk;
            if clk_stretch = '0' then
                count := count + 1;
                if count = divider then
                    count := 0;
                    clock_st := clock_st + 1;
                    if clock_st = 4 then
                        clock_st := 0;
                    end if;
                end if;
            end if;
            case clock_st is
                when 0 =>
                    scl_clk  <= '0';
                    data_clk <= '0';
                when 1 =>
                    scl_clk  <= '0';
                    data_clk <= '1';
                when 2 =>
                    scl_clk  <= '1';
                    data_clk <= '1';
                    -- clk_stretch <=  '1' when (scl='0') else '0';
                    if scl='0' then
                        clk_stretch <= '1';
                    else
                        clk_stretch <= '0';
                    end if;
                when 3 =>
                    scl_clk  <= '1';
                    data_clk <= '0';
                when others =>
            end case;
        end if;
    end process;

    fsm_proc : process(clk,reset_n)
        --variable state : State_Type := READY; 
    begin
        if reset_n = '0' then
            --state := READY;
            state <= READY;
            busy <= '0';
            ack_error <= '0';
            scl_ena <= '0';
            sda_int <= '1';
        elsif rising_edge(clk) then
            if data_clk = '1' and data_clk_prev = '0' then
                case state is
                    when READY =>
                        if ena = '1' then
                            busy    <= '1';
                            cmd     <= addr & rw;
                            data_tx <= data_wr;
                            current_bit <= 7;
                            --state   := START;
                            state <= START;
                        else
                            busy    <= '0';
                        end if;
                    
                    when START =>
                        sda_int <= '0';
                        --state := COMMAND;
                        --state <= COMMAND;
                    
                    when COMMAND =>
                        sda_int <= cmd(current_bit);
                        if current_bit /= 0 then
                            current_bit <= current_bit - 1;
                        else
                            current_bit <= 7;
                            --state := SLVACK1;
                            state <= SLVACK1;
                        end if;
                    when SLVACK1 =>
                    when READ =>
                    when WRITE =>
                    when SLVACK2 =>
                    when MSTACK =>
                    when STOP =>
                    when others =>
                end case;
            elsif data_clk = '0' and data_clk_prev = '1' then
                case state is
                    when START =>
                        scl_ena <= '1';
                        state <= COMMAND;
                    when others =>
                end case;
            end if;
        end if;
    end process;
end behavior;
