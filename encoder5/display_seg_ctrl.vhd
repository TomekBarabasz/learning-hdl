library IEEE;
use IEEE.std_logic_1164.all;

entity display_seg_ctrl is
    port (
				  rst : in std_logic;
				  clk : in std_logic;
		 all_digits : in std_logic_vector(11 downto 0);
     digit_select : out std_logic_vector(2 downto 0);
			   digit : out std_logic_vector(3 downto 0)
    );
end display_seg_ctrl;

architecture Behavioral of display_seg_ctrl is
	signal digit_select_int : std_logic_vector(2 downto 0);
begin
	 digit_select <= digit_select_int;
    process(rst,clk)
    begin
        if rst = '0' then
            digit_select_int <= "110";
        elsif rising_edge(clk) then
            digit_select_int <= digit_select_int(1 downto 0) & digit_select_int(2);            
        end if;
    end process;
    digit <= all_digits(3 downto 0) when (digit_select_int ="110") else
             all_digits(7 downto 4) when (digit_select_int ="101") else
             all_digits(11 downto 8);
end Behavioral;
