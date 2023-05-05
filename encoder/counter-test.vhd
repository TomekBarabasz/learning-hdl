library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_tb is
end counter_tb;

architecture behavior of counter_tb is
    component encoder_counter is
        port(
            rst : in std_logic;
            enc_a,enc_b : in std_logic;
            count : out unsigned(3 downto 0);
            enc_a_out,enc_b_out : out std_logic
        );
    end component;
    signal rst : std_logic;
    signal enc_a,enc_b : std_logic;
    signal count1 : unsigned(3 downto 0);
    signal count2 : unsigned(3 downto 0);
    signal enc_a_out1,enc_b_out1 : std_logic;
    signal enc_a_out2,enc_b_out2 : std_logic;

begin
    counter1 : encoder_counter port map(
        rst => rst,
        enc_a => enc_a,
        enc_b => enc_b,
        count => count1,
        enc_a_out => enc_a_out1,
        enc_b_out => enc_b_out1
    );
    counter2 : encoder_counter port map(
        rst => rst,
        enc_a => enc_a_out1,
        enc_b => enc_b_out1,
        count => count2,
        enc_a_out => enc_a_out2,
        enc_b_out => enc_b_out2
    );
    process
    begin
        enc_a <= '1';
        enc_b <= '1';
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        rst <= '1';
       
        for i in 0 to 25 loop
            wait for 10 ns;
            enc_a <= '0';
            wait for 10 ns;
            enc_b <= '0';
            wait for 10 ns;
            enc_a <= '1';
            wait for 10 ns;
            enc_b <= '1';
        end loop;

        for i in 0 to 25 loop
            wait for 10 ns;
            enc_b <= '0';
            wait for 10 ns;
            enc_a <= '0';
            wait for 10 ns;
            enc_b <= '1';
            wait for 10 ns;
            enc_a <= '1';
        end loop;

        wait;
    end process;
end behavior;

-- enc_a_out = '1' if count1 & count2 & count3 = 12d"0" else enc_a;