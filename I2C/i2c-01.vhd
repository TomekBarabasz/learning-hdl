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
    scl_ena <= '1';
    
    clk_proc : process(clk,reset_n)
        constant divider  : integer := (sys_clk / bus_clk) / 4;
        variable count    : integer range 0 to divider;
    begin
        if reset_n = '0' then
            count := 0;
            scl_clk  <= '0';
            data_clk <= '0';
            --scl_ena <= '1';
        elsif rising_edge(clk) then
            data_clk_prev <= data_clk;
            data_clk <= scl_clk;
            if clk_stretch = '0' then
                count := count + 1;
                if count = divider then
                    count := 0;
                    scl_clk <= not scl_clk;
                end if;
            end if;
            
        end if;
    end process;

    clk_stretch_p : process(scl_clk,scl,reset_n)
    begin
        if reset_n = '0' then
            clk_stretch <= '0';
        else
            if scl_clk = '1' and scl = '0' then
                clk_stretch <= '1';
            else
                clk_stretch <= '0';
            end if;
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
            --scl_ena <= '0';
            sda_int <= '1';
        elsif rising_edge(clk) then
            if data_clk = '1' and data_clk_prev = '0' then
                sda_int <= '1';
            elsif data_clk = '0' and data_clk_prev = '1' then
                sda_int <= '0';
            end if;
        end if;
    end process;
end behavior;
