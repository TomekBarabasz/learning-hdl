library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity {{testbench_name}} is
end {{testbench_name}};

architecture behavior of {{testbench_name}} is
    component i2c_master is
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
    end component;
    signal clk : std_logic;
    signal reset_n : std_logic;
    signal ena : std_logic;
    signal addr : std_logic_vector(6 downto 0);
    signal rw : std_logic;
    signal data_wr : std_logic_vector(7 downto 0);
    signal data_rd : std_logic_vector(7 downto 0);
    signal busy : std_logic;
    signal ack_error : std_logic;
    signal sda : std_logic;
    signal scl : std_logic;

begin
    i2c : i2c_master 
        generic map(
            sys_clk => {{sys_clk}}, 
            bus_clk => {{bus_clk}}
        ) 
        port map(
            clk => clk, 
            reset_n => reset_n, 
            ena => ena, 
            addr => addr, 
            rw => rw, 
            data_wr => data_wr, 
            data_rd => data_rd, 
            busy => busy, 
            ack_error => ack_error, 
            sda => sda, 
            scl => scl
        );

    process
    begin
        {{test_process}}
        wait;
    end process;
end behavior;

