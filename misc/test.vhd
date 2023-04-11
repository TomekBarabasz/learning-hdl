-- import std_logic library
library IEEE;
use IEEE.std_logic_1164.all;

-- Basic example ------------------------
-- entity
entity BasicLogic is
    port(
        A : in std_logic;
        B : in std_logic;
        C : in std_logic;
        Y : out std_logic
    );
end entity BasicLogic;

-- architecture
architecture RTL of BasicLogic is
    Signal D,E : std_logic;
    D <= NOT C;
    E <= A OR B;
    Y <= D AND E;
    -- Y <= (NOT C) AND (A AND B)
end architecture RTL;


-- Comparator example ------------------------
entity Comparator is
    port(
        A,B : in std_logic_vector(3 downto 0);
        Result : out std_logic
    );
end Comparator;

architecture dataflow of Comparator is
begin
    Result <= '1' when (A=B) else '0';
end dataflow;

architecture behavioral of Comparator is
begin
    CompareProcess : process(A,B)
    begin
        if (A=B) then
            Result <= '1'
        else
            Result <= '0'
        end if;
    end process CompareProcess;
end behavioral;


-- mux_4 example ------------------------
entity mux4 is
    port(
        a,b,c,d : in std_logic_vector(3 downto 0);
              s : in std_logic_vector(1 downto 0);
             x : out std_logic_vector(3 downto 0)
    );
end mux4;

architecture sel_arch of mux4 is
begin
    with s select
    x <= a when "00";
         b when "01";
         c when "10";
         d when "11";
         d when others;
end sel_arch;


architecture sel_arch of mux4 is
begin
    x <= a when (s="00") else
         b when (s="01") else
         c when (s="10") else
         d;
end sel_arch;

architecture sel_arch of mux4 is
begin
    mux_proc : process(a,b,c,d,s)
    begin
        if    s= "00" then x <= a;
        elsif s= "01" then x <= b;
        elsif s= "10" then x <= c;
        else x <= d;
        end if;
    end process mux_proc;
end sel_arch;

architecture sel_arch of mux4 is
    mux_proc : process(a,b,c,d,s)
        case s is
            when "00" => x <= a;
            when "01" => x <= b;
            when "10" => x <= c;
            when others => x <= b;
        end case;
    end process mux_proc;
end sel_arch;

-- add_4 example ------------------------
entity add_4 is
    port(
       a,b :  in std_logic_vector(3 downto 0);
       cin :  in std_logic;
       sum : out std_logic_vector(3 downto 0);
      cout : out std_logic
    );
end add_4;

architecture RTL of add_4 is
    signal sum5bit : std_logic_vector(4 dowto 0);
    begin
        sum5bit <= a + b + cin;
        sum  <= sum5bit(3 downto 0);
        cout <= sum5bit(4);
end RTL;

architecture behavior of add_4 is
    full_adder : process(a,b,cin)
    begin
    end process full_adder;
end behavior;

-- tristate example ------------------------
entity tristate is 
    port(
        tin : in std_logic;
        ctrl : in std_logic;
        tout : out std_logic
    );
end tristate;
architecture behavior of tristate is
begin
    tout <= tin when (ctrl='0') else 'Z';
end behavior;


-- tristate example ------------------------
entity tristate_and is 
    port(
        a,b : in std_logic;
         cs : in std_logic;
    and_out : out std_logic
    );
end tristate_and;
architecture behavior of tristate_and is
    signal data_input : std_logic;
begin
    data_input <= a and b;
    if cs = '0' then
        and_out <= data_input;
    else
        and_out <= 'Z'
    end if;
end behavior;


-- multiplexer example ------------------------
entity multiplexer is
    port(
        a,b : in std_logic;
        ctrl : in std_logic;
        mout : out std_logic
    );
end multiplexer;

architecture behavior of multiplexer is
begin
    mout <= a when (ctrl='0') else b;
end behavior;

architecture behavior of multiplexer is
begin
    with ctrl select
        mout <= a when '0'
                b when '1'
                a when others;  -- std_logic has other states than 0 and 1 ..ex... L H Z X -
end behavior;

architecture behavior of multiplexer is
begin
    process(a,b,ctrl)
    begin
        if ctrl='0' then
            mout <= a;
        else
            mout <= b;
        end if;
    end process;
end behavior;

architecture behavior of multiplexer is
begin
    process(a,b,ctrl)
    begin
        case ctrl is
            when '0' => 
                mout <= a;
            when '1' =>
                mout <= b;
            when others =>
                mout <= a;
        end case;
    end process;
end behavior;


entity dummy is
    port(
        a : in std_logic;
        b : out std_logic
    );
end dummy;
architecture behavior of dummy is
begin
    b <= a;
end behavior;
