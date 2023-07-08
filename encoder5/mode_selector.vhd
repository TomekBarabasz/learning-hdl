library IEEE;
use IEEE.std_logic_1164.all;

entity mode_selector is
	  port(
				rst : in std_logic;
		mode_sel : in std_logic;
		digits_1 : in std_logic_vector(11 downto 0);
		digits_2 : in std_logic_vector(11 downto 0);
		  digits : out std_logic_vector(11 downto 0);
		display_led : out std_logic_vector(7 downto 0)
	  );
end mode_selector;

architecture behavior of mode_selector is
	signal current_mode : std_logic;
begin
	process(rst,mode_sel)
	begin
		if rst = '0' then
			current_mode <= '1';
		elsif falling_edge(mode_sel) then
			current_mode <= not current_mode;
		end if;
	end process;
	digits      <=   digits_1 when (current_mode = '0') else digits_2;
	display_led <= "00000001" when (current_mode = '0') else "00000010";
end behavior;