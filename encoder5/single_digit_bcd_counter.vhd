library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity single_digit_bcd_counter is
    port(
            rst : in std_logic;
    enc_a,enc_b : in std_logic;
        counter : out unsigned(3 downto 0);
      enc_a_out : out std_logic;
		enc_b_out : out std_logic
    );
end single_digit_bcd_counter;

architecture behavior of single_digit_bcd_counter is
	signal value : unsigned(3 downto 0);
begin
	
	counter <= value;
	
	process(rst,enc_a,enc_b)
	begin
		-- enc_a_out <= '1';
		-- enc_b_out <= '1';
		if rst = '0' then
			value <= (others => '0');
			enc_a_out <= '1';
			enc_b_out <= '1';
		elsif falling_edge(enc_a) then
			if enc_b = '1' then
				if value = "1001" then 
					value <= "0000";
					enc_a_out <= '0';
				else
					value <= value + 1;
					enc_a_out <= '1';
				end if;
			else
				enc_a_out <= '1';
			end if;
		elsif falling_edge(enc_b) then
			if enc_a = '1' then
				 if value = "0000" then
					  value <= "1001";
					  enc_b_out <= '0'; 
				 else
					  value <= value - 1;
					  enc_b_out <= '1';
				 end if;
			else
				enc_b_out <= '1';
			end if;
		end if;
	end process;
end behavior;
