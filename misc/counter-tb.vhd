library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_tb is
end counter_tb;

architecture behavior of counter_tb is
    component counter is
        port(
            c_plus,c_minus : in std_logic;
                    rst : in std_logic;
                    set : in std_logic;
                set_value : in unsigned(3 downto 0);
                    value : out unsigned(3 downto 0);
            carry_plus,carry_minus : out std_logic
        );
    end component;
    signal rst,set : std_logic;
    signal c_plus,c_minus : std_logic;
    signal set_value : unsigned(3 downto 0);
    signal counter_value : unsigned(3 downto 0);
    signal carry_plus,carry_minus : std_logic;

begin
    c : counter port map(
        c_plus => c_plus,
        c_minus => c_minus,
        rst => rst,
        set => set,
        set_value => set_value,
        value => counter_value,
        carry_plus => carry_plus,
        carry_minus => carry_minus
    );
    process
    begin
        rst <= '0';
        set <= '0';
        c_plus <= '0';
        c_minus <= '0';
        wait for 10 ns;
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        for i in 0 to 16 loop
            c_plus <= '1';
            wait for 10 ns;
            c_plus <= '0';
            wait for 10 ns;
        end loop; 

        for i in 0 to 16 loop
            c_minus <= '1';
            wait for 10 ns;
            c_minus <= '0';
            wait for 10 ns;
        end loop;

        wait for 50 ns;
        set_value <= 4d"10";
        wait for 10 ns;
        set <= '1';
        wait for 10 ns;
        set <= '0';
        wait;
    end process;
end behavior;
