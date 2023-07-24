library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_generator is
	port(
		 clk : in std_logic;
	  clk_d : out std_logic;  -- 23.8 Hz
	  clk_m : out std_logic   -- 10us   -> 0.1MHz -> 100KHz
	  );
end clock_generator;

architecture behavior of clock_generator is
	signal divisor : unsigned(15 downto 0);
	
begin
	clk_d <= divisor(15);
	clk_m <= divisor(10);
	process(clk)
	begin
		if rising_edge(clk) then
			divisor <= divisor + 1;
		end if;
	end process;
end behavior;