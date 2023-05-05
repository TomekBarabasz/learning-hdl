library IEEE;
use IEEE.std_logic_1164.all;

entity display is
    port(
           clk : in  std_logic;
        digit1 : in  std_logic_vector(3 downto 0);
        digit2 : in  std_logic_vector(3 downto 0);
        digit3 : in  std_logic_vector(3 downto 0);
    disp_digit : out std_logic_vector(3 downto 0);
      disp_sel : out std_logic_vector(2 downto 0)
    );
end display;

architecture behavior of display is
    signal display_sel : std_logic_vector(2 downto 0) := "110";
begin
    disp_sel <= display_sel;
    disp_digit <= digit1 when (display_sel="110") else
                  digit2 when (display_sel="101") else
                  digit3;
    process(clk)
        if rising_edge(clk) then
            display_sel <= display_sel(1 downto 0) & display_sel(2);
        end if;
    end process
end behavior;