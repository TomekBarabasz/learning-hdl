library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity encoder_debouncer is
    generic(
        N : integer := 4
    );
    port(
    clk : in std_logic;
    enc_a,enc_b : in std_logic;
    act_inc,act_dec : out std_logic
    );
end encoder_debouncer;

architecture behavior of encoder_debouncer is
	type State_t is (Idle,Started,WaitForEnd);
  signal history : std_logic_vector(N-1 downto 0);   
begin

process(clk,enc_a,enc_b)
	variable  state : State_t := Idle;
  --variable state : unsigned(2 downto 0);
  --variable state : std_logic_vector(2 downto 0);
begin
    case state is
        when Idle =>
            if enc_a='0' then
                state := Started; 
                --state := 0;
                --state := "000";
                act_inc <= '1';
            elsif enc_b='0' then
                state := Started;
                act_dec <= '1';
            else
                act_inc <= '0';
                act_dec <= '0';
            end if;
        --- rotate right (increase)
        when Started =>
          if enc_a='0' and enc_b='0' then
            act_inc <= '0';
            act_dec <= '0';
            state := WaitForEnd;
          end if;
        when WaitForEnd =>
          if rising_edge(clk) then
            if enc_a='1' and enc_b='1' then
              history <= history <= history(N-2 downto 0) & '1';
            else
              history <= history <= history(N-2 downto 0) & '0';
            end if;
            if unsigned(history) = resize("1", N) then
                state := Idle;
            end if;
          end if;
        when others => 
				  state := Idle;
    end case;
end process;

end behavior;