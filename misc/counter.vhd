library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    port(
        clk,rst : in std_logic;
        max_count : in unsigned(7 downto 0); -- wire [7:0] max_count
        count : out unsigned(7 downto 0)
    );
end counter;

architecture behavior of counter is
    signal internal_count : unsigned(7 downto 0);
begin
    count <= internal_count;
    process(clk,rst)
    begin
        if rst = '1' then
            internal_count <= "00000000";
        elsif (clk 'event and clk = '1') then
            if internal_count < max_count then
                internal_count <= internal_count + 1; 
            else
                internal_count <= "00000000";
            end if;
        end if;
    end process;
end behavior;