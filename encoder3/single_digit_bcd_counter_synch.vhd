library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity single_digit_bcd_counter is
    port(
            clk : in std_logic;
            rst : in std_logic;
    enc_a,enc_b : in std_logic;
          digit : buffer unsigned(3 downto 0);
        enc_a_out,enc_b_out : out std_logic
    );
end single_digit_bcd_counter;

architecture behavior of single_digit_bcd_counter is
begin

process(clk)

end behavior;