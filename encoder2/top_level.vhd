library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_device is
    port(
        rst : in std_logic;
        clk : in std_logic;
        mode_sel : in std_logic;
        enc_a,enc_b : in std_logic;
        display_select : out std_logic_vector(2 downto 0);
        display_seg : out unsigned(7 downto 0);
        display_led : out unsigned(7 downto 0)
    );
end top_level_device;

architecture of top_level_device is
    component seven_seg is
        port(
              digit : in unsigned(3 downto 0);
            display : out std_logic_vector(6 downto 0)
        );
    end component;
    component display_seg_ctrl is
        port(
                clk : in std_logic;
             digits : in std_logic_vector(11 downto 0);
     display_select : out std_logic_vector(2 downto 0);
          one_digit : out std_logic_vector(3 downto 0)
        );
    end component;
    component counter is
        port(
                rst : in std_logic;
        enc_a,enc_b : in std_logic;
             digits : out std_logic_vector(11 downto 0);
        );
    end component;
    component impulse_measurement is
        port(
              clk : in std_logic;
            enc_a : in std_logic;
           digits : out std_logic_vector(11 downto 0)
        );
    end component;
    component mode_selector is
        port(
         mode_sel : in std_logic;
         digits_1 : in std_logic_vector(11 downto 0);
         digits_2 : in std_logic_vector(11 downto 0);
           digits : out std_logic_vector(11 downto 0);
         display_led : out unsigned(7 downto 0)
        );
    end component;
    component clock_generator is
          clk : in std_logic;
        clk_d : in std_logic;   -- 0.05ms -> 20Hz
        clk_m : in std_logic;   -- 10us   -> 0.1MHz -> 100KHz
    end component;

    signal clk_d : in std_logic;   -- 0.05ms -> 20Hz
    signal clk_m : in std_logic;   -- 10us   -> 0.1MHz -> 100KHz
    signal counter_digits : std_logic_vector(11 downto 0);
    signal measure_digits : std_logic_vector(11 downto 0);
    signal digits : std_logic_vector(11 downto 0);
    signal one_digit : std_logic_vector(3 downto 0);

begin
    g : clock_generator port map(
        clk => clk,
        clk_d => clk_d,
        clk_m => clk_m
    );
    c : counter port map(
        rst => rst,
        enc_a => enc_a,
        enc_b => enc_b,
        digits => counter_digits
    );
    im : impulse_measurement port map(
        clk => clk_m,
        enc_a => enc_a,
        digits => measure_digits
    );
    ms : mode_selector port map(
        mode_sel => mode_sel,
        digits_1 => counter_digits,
        digits_2 => measure_digits,
          digits => digits,
         display_led => display_led
    );
    dc : display_seg_ctrl port map(
        clk => clk_d,
        digits => digits,
        display_select => display_select,
        one_digit => one_digit
    );
    enc : seven_seg port map(
        digit => one_digit,
        display => display_seg(6 downto 0);
    )
    display_seg(7) <= '0';

end top_level_device;