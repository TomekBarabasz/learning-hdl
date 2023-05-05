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
    signal digit1 : std_logic_vector(3 downto 0) := (others => '0');
    signal digit2 : std_logic_vector(3 downto 0) := (others => '0');
    signal digit3 : std_logic_vector(3 downto 0) := (others => '0');
    signal    ena : std_logic := '0';
begin
    count <= digit3 & digit2 & digit1;

    encoder : process(enc)
    begin
        if falling_edge(enc) then
            ena <= '1';
            digit3 & digit2 & digit1 <= (others => '0');
        elsif rising_edge(enc) then
            ena <= '0';
        end if;
    end process;

    measurement : process(clk)
    begin
        if rising_edge(clk) then
            if ena = '1' then;
                if digit1 < 9 then
                    digit1 <= digit1 + 1;
                elsif
                    digit1 <= "0000";
                    if digit2 < 9 then
                        digit2 <= digit2 + 1;
                    elsif
                        digit2 <= "0000";
                        if digit3 < 9 then
                            digit3 <= digit3 + 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

end behavior;