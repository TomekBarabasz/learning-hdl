library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity encoder_debouncer is
    port(
    enc_a,enc_b : in std_logic;
    act_inc,act_dec : out std_logic
    );
end encoder_debouncer;

architecture behavior of encoder_debouncer is
begin

process(enc_a,enc_b)
    variable state : std_logic_vector(2 downto 0) := "000";
begin
    case state is
        when "000" =>
            if enc_a='0' then
                state := "001";
                act_inc <= '1';
            elsif enc_b='0' then
                state := "101";
                act_dec <= '1';
            else
                act_inc <= '0';
                act_dec <= '0';
            end if;
        --- rotate right (increase)
        when "001" =>
            state := "010" when enc_b='0' else "001";
            act_inc <= '0';
            act_dec <= '0';
        when "010" =>
            state := "011" when enc_a='1' else "010";
        when "011" =>
            state := "000" when enc_b='1' else "011";
        --- roate left (decrease)
        when "101" =>
            state := "110" when enc_a='0' else "101";
            act_inc <= '0';
            act_dec <= '0';
        when "110" =>
            state := "111" when enc_b='1' else "110";
        when "111" =>
            state := "000" when enc_a='1' else "111";
        when others => state := "000";
    end case;
end process;

end behavior;