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
    function unary_or(input : std_logic_vector) return std_logic is
		variable result : std_logic := '0';
	begin
		for i in input'range loop
			result := result or input(i);
		end loop;
		return result;
	end function;

    signal clk_stretch : std_logic; --indicates if slave is stretching scl
    signal scl_ena  : std_logic; -- enables scl_cls driving scl
    signal sda_int : std_logic; -- internal sda

    SIGNAL cmd     : std_logic_vector(7 DOWNTO 0);   --latched in address and read/write
    SIGNAL data_tx : std_logic_vector(7 DOWNTO 0);   --latched in data to write to slave
    SIGNAL data_rx : std_logic_vector(7 DOWNTO 0);   --data received from slave

    type State_Type is (mREADY, mSTART, mCOMMAND, mSLVACK1, mSLVACK2, mREAD, mWRITE, mSTOP);
    signal master_state : State_Type;
    
    type BitCmd_Type is (bcIDLE, bcSTART, bcRSTART, bcWRITE, bcREAD, bcSTOP);
    signal bcmd_curr, bcmd_next : BitCmd_Type;
    signal bit_cmd_c : std_logic_vector(4 downto 0);
    signal bit_cmd_d : std_logic_vector(4 downto 0);
    --signal bit_ctrl_state : unsigned(2 downto 0); --integer range 0 to 4;

    signal scl_i : std_logic;
    signal scl_d : std_logic;
begin
    -- scl <= '0' when (scl_clk = '0' and scl_ena = '1') else 'Z';
    sda <= '0' when sda_int = '0' else 'Z';
   
    master_ctrl_p : process(clk,reset_n)
    begin
        if reset_n = '0' then
            master_state <= mREADY;
            bcmd_next <= bcIDLE;
            clk_stretch <= '0';
        else
            if rising_edge(clk) then
                case master_state is
                    when mREADY =>
                        if ena = '1' and bit_ctrl_state = 0 then
                            cmd <= addr & rw;
                            data_tx <= data_wr;
                            bcmd_next <= bcSTART;
                            master_state <= mSTART;
                        end if;
                    when mSTART =>
                    when mCOMMAND =>
                    when mSLVACK1 =>
                    when mSLVACK2 =>
                    when mREAD =>
                    when mWRITE => 
                    when mSTOP =>
                    when others =>
                        master_state <= mREADY;
                end case;
            end if;
        end if;
    end process;

    bit_ctrl_p : process(clk,reset_n)
        constant divider  : integer := (sys_clk / bus_clk) / 4;
        variable count    : integer range 0 to divider;
        signal bit_idx    : integer range 0 to 3;
        -- signal bit_ctrl_state : unsigned(1 downto 0);
    begin
        if reset_n = '0' then
            count := 0;
            bit_idx <= 3;
        elsif rising_edge(clk) then
            if bcmd_curr = bcIDLE and bcmd_next /= bcIDLE then
                bit_cmd_c <= (others => '0');
                bit_cmd_d <= (others => '0');
            end if;
            if bcmd_curr /= bcIDLE then
            --if clk_stretch = '0' then
                count := count + 1;
                if count = divider then
                    count := 0;
                    scl_i <= bit_cmd_c(bit_idx);
                    scl_d <= bit_cmd_d(bit_idx);
                    if bit_idx /= 0 then
                        bit_idx <= bit_idx - 1;
                    else
                        case bcmd_next is
                            when bcIDLE =>
                            when bcSTART =>
                        end case;
                    end if;
                end if;
            --end if;
        end if;
    end process;
end behavior;
