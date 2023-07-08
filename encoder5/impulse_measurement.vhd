library IEEE;
use IEEE.std_logic_1164.all;

entity impulse_measurement is
  port(
		  clk : in std_logic;
		enc_a : in std_logic;
	  digits : out std_logic_vector(11 downto 0)
  );
end impulse_measurement;

architecture behavior of impulse_measurement is
begin
end behavior;