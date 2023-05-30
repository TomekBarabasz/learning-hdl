library IEEE;
use IEEE.std_logic_1164.all;

entity UCY74121_tb is
end UCY74121_tb;

architecture test_bench of UCY74121_tb is
    component UCY74121 is
        generic ( IMPULSE_TIME : time);
        port(
            A1 : in std_logic;
            A2 : in std_logic;
             B : in std_logic;
             Q : out std_logic;
            nQ : out std_logic
        );
    end component;
    signal A1,A2,B,Q,nQ : std_logic;
begin
    ic : UCY74121 generic map (IMPULSE_TIME => 50 ns) port map (
        A1 => A1,
        A2 => A2,
        B => B,
        Q => Q,
        nQ => nQ
    );

    process
    begin
        A1 <= '0';
        A2 <= '0';
        B  <= '0';

        wait for 10 ns;
        B  <= '1';
        wait for 100 ns;

        A1 <= '1';
        wait for 10 ns;
        A1 <= '0';
        wait for 100 ns;
        wait;
    end process;
end test_bench;
