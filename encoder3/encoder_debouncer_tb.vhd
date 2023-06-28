library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity encoder_debouncer_tb is
end encoder_debouncer_tb;

architecture behavior of encoder_debouncer_tb is
    component encoder_debouncer is
        port(
            enc_a,enc_b : in std_logic;
            act_inc,act_dec : out std_logic
    );
    end component;

    signal enc_a,enc_b : std_logic;

    signal act_inc,act_dec : std_logic;

begin
    deb : encoder_debouncer port map(enc_a => enc_a, enc_b => enc_b, act_inc => act_inc, act_dec => act_dec);
    process
    begin
        enc_a <= '1';
        enc_b <= '1';
        wait for 10 ns;
        assert act_inc = '0' and act_dec = '0';

        enc_a <= '0';
        wait for 5 ns;
        assert act_inc = '1' and act_dec = '0';
        
        enc_b <= '0';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_a <= '1';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_b <= '1';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_b <= '0';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '1';
        
        enc_a <= '0';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_b <= '1';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_a <= '1';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';
        
        -- simulate some glitches
        enc_a <= '0';
        wait for 5 ns;
        assert act_inc = '1' and act_dec = '0';
        
        enc_a <= '1';
        wait for 1 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_a <= '0';
        wait for 1 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_b <= '0';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_b <= '1';
        wait for 1 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_b <= '0';
        wait for 1 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_a <= '1';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_a <= '0';
        wait for 1 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_a <= '1';
        wait for 1 ns;
        assert act_inc = '0' and act_dec = '0';
        
        enc_b <= '1';
        wait for 5 ns;
        assert act_inc = '0' and act_dec = '0';

        wait;
    end process;
end behavior;
