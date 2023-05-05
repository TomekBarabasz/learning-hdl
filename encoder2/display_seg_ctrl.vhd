library IEEE;
use IEEE.std_logic_1164.all;

entity display_seg_ctrl is
    port (
                    rst : in std_logic;
                    clk : in std_logic;
            all_digits : in std_logic_vector(11 downto 0);
        digit_select : buffer std_logic_vector(2 downto 0);
                digit : out std_logic_vector(3 downto 0)
    );
end display_seg_ctrl;

architecture Behavioral of display_seg_ctrl is
begin
    process(rst,clk)
    begin
        if rst = '1' then
            digit_select <= "110";
        elsif rising_edge(clk) then
            digit_select <= digit_select(1 downto 0) & digit_select(2);            
        end if;
    end process;
    digit <= all_digits(3 downto 0) when (digit_select ="110") else
             all_digits(7 downto 4) when (digit_select ="101") else
             all_digits(11 downto 8);
end Behavioral;
