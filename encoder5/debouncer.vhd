library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity debouncer is
    generic(
        N : integer := 4
    );
    port(
        clk : in std_logic;
        we : in std_logic;
        wy : out std_logic
    );
end debouncer;

architecture behavior of debouncer is
    signal history : std_logic_vector(N-1 downto 0);   
begin
    --wy <= '0' when (unsigned(history) = resize("0", N)) else
    --      '1' when (unsigned(history) = resize("1", N));

    process(clk)
    begin
        if rising_edge(clk) then
            history <= history(N-2 downto 0) & we;
            if unsigned(history) = resize("0", N) then
                wy <= '0';
            elsif unsigned(history) = resize("1", N) then
                wy <= '1';
            end if;
        end if;
    end process;
end behavior;
