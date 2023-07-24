library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lut is
    generic(
        func : unsigned(7 downto 0)
    );
    port(
        a,b,c : in std_logic;
            y : out std_logic
    );
end lut;

architecture behavior of lut is
begin
    process(a,b,c)
        variable index : unsigned 0 to 7;
    begin
        index := to_unsigned(a & b & c);
        y <= func(index);
    end process:
end behavior;


entity top_level is
    port(
        a,b,c : in std_logic;
        y : out std_Logic;
    )
end top_level;
architecture top_level

lut1 : lut generic map(func => x"10010101") port map (a=>a,b=>b,c=>c,y=>y);
c8 : encoder_counter generic map(N=>8) port map(....)
c16 : encoder_counter generic map(N=>16) port map(....)
end top_level;