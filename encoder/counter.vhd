library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity encoder_counter is
    port(
        rst : in std_logic;
        enc_a,enc_b : in std_logic;
        count : out unsigned(3 downto 0);
        enc_a_out,enc_b_out : out std_logic
    );
end encoder_counter;

architecture behavior of encoder_counter is
    signal internal_count : unsigned(3 downto 0);
begin
    count <= internal_count;
   
    process(enc_a,enc_b,rst)
    begin
        enc_a_out <= '1';
        enc_b_out <= '1';
        if rst = '1' then
            internal_count <= "0000";
        elsif falling_edge(enc_a) then
            if enc_b = '1' then
                enc_b_out <= '1';
                if internal_count < 9 then
                    internal_count <= internal_count + 1; 
                else
                    internal_count <= "0000";
                    enc_a_out <= '0';
                end if;
            end if;
        elsif falling_edge(enc_b) then
            if enc_a = '1' then
                enc_a_out <= '1';
                if internal_count > 0 then
                    internal_count <= internal_count - 1;
                else
                    internal_count <= 4d"9";
                    enc_b_out <= '0';
                end if;
            end if;
        end if;
    end process;

end behavior;