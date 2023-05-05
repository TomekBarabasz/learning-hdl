library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity single_digit_bcd_counter is
    port(
            rst : in std_logic;
    enc_a,enc_b : in std_logic;
          digit : buffer unsigned(3 downto 0);
        enc_a_out,enc_b_out : out std_logic
    );
end single_digit_bcd_counter;

architecture behavior of single_digit_bcd_counter is
begin
    process(rst,enc_a,enc_b)
        enc_a_out <= '1';
        enc_b_out <= '1';
        if rst = '1' then
            digit <= (others => '0');
        elsif falling_edge(enc_a) then
            if enc_b =  '1' then
                if digit = "1001" then 
                    digit <= "0000";
                    enc_a_out <= '0';
                else
                    digit <= digit + 1;
                end if;
            end if;            
        elsif falling_edge(enc_b) then
            if enc_a = '1' then
                if digit = "0000" then
                    digit <= "1001";
                    enc_b_out <= '0'; 
                else
                    digit <= digit - 1;
                end if;
            end if;
        end if;
    end process;
end behavior;
