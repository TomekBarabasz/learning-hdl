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
    type State_Type is (IDLE, START, STOP, COMMAND, SLVACK1, SLVACK2, MSTACK, READ, WRITE);
    signal CurrentState : State_Type := IDLE; 
    signal data_clk : std_logic; -- data clock for sda
    signal scl_clk  : std_logic; -- constantly running internal scl
    signal clk_stretch : std_logic;

begin

    clk_proc : process(reset_n, clk)
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
                when others =>
                    scl_clk  <= '1';
                    data_clk <= '0';
            end case;
        end if;
    end process;
end behavior;
