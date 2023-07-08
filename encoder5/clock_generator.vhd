library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_generator is
	port(
		 clk : in std_logic;
	  clk_d : out std_logic;   -- 0.05s -> 20Hz
	  clk_m : out std_logic   -- 10us   -> 0.1MHz -> 100KHz
	  );
end clock_generator;

architecture behavior of clock_generator is
	signal divisor_m : unsigned(8 downto 0);
	signal divisor_d : unsigned(7 downto 0);
	signal clk_d_int : std_logic;
	signal clk_m_int : std_logic;
begin
	clk_d <= clk_d_int;
	clk_m <= clk_m_int;
	process(clk)
	begin
		if rising_edge(clk) then
			divisor_m <= divisor_m + 1;
			if divisor_m > 500 then
				clk_m_int <= not clk_m_int;
				divisor_m <= (others => '0');	-- to_unsigned(0,divisor_m'length);
				divisor_d <= divisor_d + 1;
			end if;
			if divisor_d > 250 then
				clk_d_int <= not clk_d_int;
				divisor_d <= (others => '0');
			end if;
		end if;
	end process;
end behavior;