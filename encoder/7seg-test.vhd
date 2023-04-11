library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- ghdl -a --std=08 7seg.vhd 7seg-test.vhd
-- ghdl -e --std=08 seven_seg_test
-- ghdl -r --std=08 seven_seg_test --wave=7seg.ghw
-- gtkwave 7seg.ghw

entity seven_seg_test is
end;

architecture sim of seven_seg_test is

component seven_seg is
    port(
        digit   : in unsigned(3 downto 0);
        display : out std_logic_vector(6 downto 0)
    );
end component;

signal digit   : unsigned(3 downto 0) := 4d"0";
signal display : std_logic_vector(6 downto 0);

begin
    dut : seven_seg port map(digit,display);
    process
    begin
        for i in 0 to 15 loop
            digit <= to_unsigned(i,4);
            wait for 10 ns;
        end loop;
        wait;
    end process;
end sim;
