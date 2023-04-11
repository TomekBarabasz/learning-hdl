library IEEE;
use IEEE.std_logic_1164.all;

entity d_flip_flop is
    port(
        D,clk,rst,ena : in std_logic;
                    Q : out std_logic
    );
end d_flip_flop;

-- four different implementation of flip flop

architecture behavior of d_flip_flop is
    process
    begin
        wait until (clk 'event and clk = '1');
        Q <= D;
    end process;
end behavior;

architecture behavior of d_flip_flop is
    process
    begin
        wait until (clk 'event and clk = '1');
        if rst = '1' then
            Q <= '0'
        else
            Q <= D;
        end if;
    end process;
end behavior;

architecture behavior of d_flip_flop is
    process(rst,clk)
    begin        
        if rst = '1' then
            Q <= '0'
        elsif (clk 'event and clk = '1') then
            Q <= D;
        end if;
    end process;
end behavior;

architecture behavior of d_flip_flop is
    process(rst,clk)
    begin        
        if rst = '1' then
            Q <= '0'
        elsif (clk 'event and clk = '1') then
            if ena = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end behavior;