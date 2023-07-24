library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_device is
    port(
        rst : in std_logic;
        CLK_100MHz : in std_logic;
        -- mode_sel : in std_logic;
        enc_a,enc_b : in std_logic;
        digit_select: out std_logic_vector(2 downto 0);
        display_seg : out std_logic_vector(7 downto 0);
		  ena_out : out std_logic
		  -- display_led : out std_logic_vector(7 downto 0)
    );
end top_level_device;

architecture structural of top_level_device is
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
			  enc_a,enc_b : in std_logic;
			  ena,dir: out std_logic
		 );
	 end component;
	 
	 component composite_counter is
		port(
			rst : in std_logic;
			clk : in std_logic;
			dir : in std_logic;
         digits : out std_logic_vector(11 downto 0)
        );
    end component;
	 
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
	 
    signal clk_d : std_logic; -- slow ~30Hz
    signal clk_m : std_logic; -- fast 50KHz
    signal digits : std_logic_vector(11 downto 0);
    signal one_digit : std_logic_vector(3 downto 0);
	 signal ena,dir : std_logic;
	 
begin
    g : clock_generator port map(
          clk => CLK_100MHz,
        clk_d => clk_d,
        clk_m => clk_m
    );
	 db : debouncer generic map(N => 4) port map(
			clk => clk_m,
			enc_a => enc_a,
			enc_b => enc_b,
			ena => ena,
			dir => dir
	 );
    c : composite_counter port map(
          rst => rst,
        clk => ena,
        dir => dir,
       digits => digits
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
	ena_out <= ena;
	
end structural;