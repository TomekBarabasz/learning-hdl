library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    port(
        c_plus,c_minus : in std_logic;
                   rst : in std_logic;
                   set : in std_logic;
             set_value : in unsigned(3 downto 0);
                 value : out unsigned(3 downto 0);
        carry_plus,carry_minus : out std_logic
    );
end counter;

architecture behavior of counter is
    -- signal tmp : unsigned(4 downto 0); -- := (others => '0');
begin
    process(c_plus,c_minus,rst,set)
        variable tmp : unsigned(4 downto 0) := (others => '0');
    begin
        carry_plus <= '0';
        carry_minus <= '0';
        if rst = '1' then
            value <= (others => '0');
            carry_plus <= '0';
            carry_minus <= '0';
        elsif set = '1' then
            value <= set_value;
        elsif rising_edge(c_plus) then
            tmp := '0'&value + 1;
            value <= tmp(3 downto 0);
            carry_plus <= tmp(4);
        elsif rising_edge(c_minus) then
            tmp := '0'&value - 1;
            value <= tmp(3 downto 0);
            carry_minus <= tmp(4);
        end if;
    end process;
end behavior;
