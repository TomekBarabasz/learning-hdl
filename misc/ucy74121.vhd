library IEEE;
use IEEE.std_logic_1164.all;

entity UCY74121 is
    generic( 
        IMPULSE_TIME : time := 100 ns 
    );
    port(
        A1 : in std_logic;
        A2 : in std_logic;
         B : in std_logic;
         Q : out std_logic;
        nQ : out std_logic
    );
end UCY74121;

architecture behavior of UCY74121 is
    signal qi : std_logic := '0';
    constant delay : time := IMPULSE_TIME;
begin
    Q  <= qi;
    nQ <= not qi;

    process
    begin
        wait until (rising_edge(B) and A1 = '0' and A2 = '0') 
                    or (B='1' and (falling_edge(A1) or falling_edge(A2)));
        qi <= '1';
        wait for delay;
        qi <= '0';
    end process;
end behavior;

