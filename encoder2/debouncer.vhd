library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity debouncer is
    generic(N:integer);
		 port(
			  clk : in std_logic;
			  enc_a,enc_b : in std_logic;
			  ena,dir: out std_logic
		 );
end debouncer;

architecture behavior of debouncer is
	type State_t is (Idle,Started,WaitForEnd);
	signal ha : std_logic_vector(N-1 downto 0);
	signal hb : std_logic_vector(N-1 downto 0);

	function unary_and(inputv : std_logic_vector) return std_logic is
		variable result : std_logic := '1';
	begin
		for i in inputv'range loop
			result := result and inputv(i);
		end loop;
		return result;
	end function;

	function unary_or(input : std_logic_vector) return std_logic is
		variable result : std_logic := '0';
	begin
		for i in input'range loop
			result := result or input(i);
		end loop;
		return result;
	end function;

begin
	process(clk)
		variable  state : State_t := Idle;
	begin
		if rising_edge(clk) then
			ha <= ha(N-2 downto 0) & enc_a;
			hb <= hb(N-2 downto 0) & enc_b;
			case state is
				when Idle =>
					if unary_or(ha) = '0' then
						dir <= '0';
						state := Started;
					elsif unary_or(hb) = '0' then
						dir <= '1';
						state := Started;
					else
						dir <= '0';
						ena <= '0';
					end if;
					
				when Started =>
					ena <= '1';
					if unary_or(ha)= '0' and unary_or(hb) = '0' then
						ena <= '0';
						dir <= '0';
						state := WaitForEnd;
					end if;
					
				when WaitForEnd =>
					if unary_and(ha) = '1' and unary_and(hb) = '1' then
						state := Idle;
					end if;
			end case;
		end if;
    end process;
end behavior;
