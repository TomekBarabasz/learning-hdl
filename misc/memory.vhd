library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
    port(
        rd_address : in unsigned(7 downto 0);
        wr_address : in unsigned(7 downto 0);
           rd_data : out unsigned(7 downto 0);
           wr_data : in unsigned(7 downto 0);
                wr : in std_logic;
               clk : in std_Logic
    );
end memory;

architecture behavior of memory is
    type memory_type is array(0 to 7) of unsigned(7 downto 0);
    signal memory_arr : memory_type;
begin
    -- rd_data <= memory_arr( conv_integer(rd_address) );
    rd_data <= memory_arr( rd_address );
    process
    begin
        -- wait until clk 'event and clk = '1';
        wait until raising_edge(clk);
        if wr = '1' then
            memory_arr( wr_address ) <= wr_data;
        end if;
    end process;
end behavior;
