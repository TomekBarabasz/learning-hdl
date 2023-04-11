library ieee;
use ieee.std_logic_1164.all;

entity find_errors is port(
    a : in bit_vector(3 downto 0);
    b : out std_logic_vector(3 downto 0);
    c : in bit_vector(5 downto 0));
end find_errors;

architecture not_good of find_errors is
begin
    my_label : process
    begin
        if c = x"F" then
            b <= a;
        else
            b <= "0101";
        end if;
    end process;
end not_good;
