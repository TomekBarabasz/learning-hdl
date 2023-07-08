library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_device is
    port(
        rst : in std_logic;
        CLK_100MHz : in std_logic;
        mode_sel : in std_logic;
        enc_a,enc_b : in std_logic;
        digit_select: out std_logic_vector(2 downto 0);
        display_seg : out std_logic_vector(7 downto 0);
        display_led : out std_logic_vector(7 downto 0)
    );
	-- attribute buffer_type : string;
	-- attribute buffer_type of enc_a : signal is "BUFG";
	-- attribute buffer_type of enc_b : signal is "BUFG";
end top_level_device;

architecture structural of top_level_device is
    component seven_seg is
        port(
              digit :  in std_logic_vector(3 downto 0);
            display : out std_logic_vector(6 downto 0)
        );
    end component;
    component display_seg_ctrl is
        port(
					 rst : in std_logic;
                clk : in std_logic;
         all_digits : in std_logic_vector(11 downto 0);
       digit_select : out std_logic_vector(2 downto 0);
				  digit : out std_logic_vector(3 downto 0)
        );
    end component;
    component counter is
        port(
                rst : in std_logic;
        enc_a,enc_b : in std_logic;
             digits : out std_logic_vector(11 downto 0)
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
				  rst : in std_logic;
         mode_sel : in std_logic;
         digits_1 : in std_logic_vector(11 downto 0);
         digits_2 : in std_logic_vector(11 downto 0);
           digits : out std_logic_vector(11 downto 0);
         display_led : out std_logic_vector(7 downto 0)
        );
    end component;
    component clock_generator is
		port(
          clk : in std_logic;
        clk_d : out std_logic;   -- 0.05s -> 20Hz
        clk_m : out std_logic   -- 10us   -> 0.1MHz -> 100KHz
		  );
    end component;
	 component debouncer is
		 generic(N:integer);
		 port(
			  clk : in std_logic;
			  we : in std_logic;
			  wy : out std_logic
		 );
	 end component;
	 
    signal clk_d : std_logic;   -- 0.05ms -> 20Hz
    signal clk_m : std_logic;   -- 10us   -> 0.1MHz -> 100KHz
    signal counter_digits : std_logic_vector(11 downto 0);
    signal measure_digits : std_logic_vector(11 downto 0);
    signal digits : std_logic_vector(11 downto 0);
    signal one_digit : std_logic_vector(3 downto 0);
	 signal enc_a_db : std_logic;
	 signal enc_b_db : std_logic;
	 
begin
    g : clock_generator port map(
          clk => CLK_100MHz,
        clk_d => clk_d,
        clk_m => clk_m
    );
    c : counter port map(
          rst => rst,
        enc_a => enc_a_db,
        enc_b => enc_b_db,
       digits => counter_digits
    );
	 dba : debouncer generic map(N => 16) port map(
			clk => clk_m,
			 we => enc_a,
			 wy => enc_a_db
	 );
	 dbb : debouncer generic map(N => 16) port map(
			clk => clk_m,
			 we => enc_b,
			 wy => enc_b_db
	 );
    --im : impulse_measurement port map(
    --      clk => clk_m,
    --    enc_a => enc_a,
    --   digits => measure_digits
    --);
    ms : mode_selector port map(
			    rst => rst,
        mode_sel => mode_sel,
        digits_1 => counter_digits,
        digits_2 => measure_digits,
          digits => digits,
     display_led => display_led
    );
    dc : display_seg_ctrl port map(
					 rst => rst,
				    clk => clk_d,
		   all_digits => digits,
       digit_select => digit_select,
				  digit => one_digit
    );
    enc : seven_seg port map(
        digit => one_digit,
      display => display_seg(7 downto 1)
    );
    display_seg(0) <= '1';

end structural;