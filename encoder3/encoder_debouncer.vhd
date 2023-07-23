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
	type State_t is (S000,S001,S010,S011,S100,S101,S110,S111);
begin

process(enc_a,enc_b)
	--variable state : std_logic_vector(2 downto 0) := "000";
	variable  state : State_t := S000;
begin
    -- s_state <= state;
    case state is
        when S000 =>
            if enc_a='0' then
                state := S001;
                act_inc <= '1';
            elsif enc_b='0' then
                state := S101;
                act_dec <= '1';
            else
                act_inc <= '0';
                act_dec <= '0';
            end if;
        --- rotate right (increase)
        when S001 =>
				if enc_b='0' then
					state := S010;
				end if;
            act_inc <= '0';
            act_dec <= '0';
        when S010 =>
				if enc_a='1' then
					state := S011;
				end if;
        when S011 =>
				if enc_b='1' then
					state := S000;
				end if;
        --- rotate left (decrease)
        when S101 =>
				if enc_a='0' then
					state := S110;
					act_inc <= '0';
					act_dec <= '0';
				end if;
        when S110 =>
				if enc_b='1' then
					state := S111;
				end if;
        when S111 =>
				if enc_a='1' then
					state := S000;
				end if;
        when others => 
				state := S000;
    end case;
end process;

end behavior;