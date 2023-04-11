library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity time_measure is
    port(
        enc   : in std_logic;
        clk   : in std_logic;
        count : out unsigned(11 downto 0)
    );
end time_measure;

architecture behavior of time_measure is
    signal internal_counter : 
end behavior;