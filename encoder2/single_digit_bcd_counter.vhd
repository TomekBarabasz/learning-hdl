----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:20:03 07/05/2023 
-- Design Name: 
-- Module Name:    single_digit_bcd_counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity single_digit_bcd_counter is
	port(
		  rst : in std_logic;
	 clk,dir : in std_logic;
	 counter : out unsigned(3 downto 0);
		carry : out std_logic
  );
end single_digit_bcd_counter;

architecture Behavioral of single_digit_bcd_counter is
	signal tmp : unsigned(3 downto 0);
begin

	counter <= tmp;
	
	process(rst,clk,dir)
	begin
		if rst = '0' then
			tmp <= "0000";
			carry <= '0';
		elsif rising_edge(clk) then
			if dir = '0' then
				if tmp < 9 then
					tmp <= tmp + 1;
					carry <= '0';
				else
					tmp <= "0000";
					carry <= '1';
				end if;
			else
				if tmp /= 0 then
					tmp <= tmp - 1;
					carry <= '0';
				else
					tmp <= "1001";
					carry <= '1';
				end if;
			end if;
		end if;
	end process;

end Behavioral;

