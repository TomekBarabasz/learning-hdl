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
begin
    process(c_plus,c_minus,rst,set)
    begin
        carry_plus  <= '0';
        carry_minus <= '0';
        if rst = '1' then
            value <= "0000";
        elsif set = '1' then
            value <= set_value;
        elsif rising_edge(c_plus) then
            if value < 15 then
                value <= value + 1;
            else
                value <= 4d"0";
                carry_plus <= '1';
            end if;
        elsif rising_edge(c_minus) then
            if value > 0 then
                value <= value - 1;
            else
                value <= 4d"15";
                carry_minus <= '1';
            end if;
        end if;
    end process;
end behavior;
