library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity composite_counter is
    port(
			rst : in std_logic;
			clk : in std_logic;
			dir : in std_logic;
         digits : out std_logic_vector(11 downto 0)
        );
end composite_counter;

architecture structural of composite_counter is
    component single_digit_bcd_counter is
        port(
				  rst : in std_logic;
			 clk,dir : in std_logic;
			 counter : out unsigned(3 downto 0);
				carry : out std_logic
        );
    end component;
    signal carry1to2,carry2to3 : std_logic;
    signal digit1 : unsigned(3 downto 0);
	 signal digit2 : unsigned(3 downto 0);
    signal digit3 : unsigned(3 downto 0);

begin
	 digits <= std_logic_vector(digit3) & std_logic_vector(digit2) & std_logic_vector(digit1);
	 
    c1 : single_digit_bcd_counter port map(
        rst => rst,
        clk => clk,
        dir => dir,
        counter => digit1,
        carry => carry1to2
    );
    c2 : single_digit_bcd_counter port map(
        rst => rst,
        clk => carry1to2,
        dir => dir,
        counter => digit2,
        carry => carry2to3
    );
    c3 : single_digit_bcd_counter port map(
        rst => rst,
        clk => carry2to3,
        dir => dir,
        counter => digit3,
        carry => open
    );
end structural;
