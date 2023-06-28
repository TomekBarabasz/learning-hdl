library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_ripple is
generic (N : integer := 3);
    port (x, y : in std_logic_vector (N downto 0);
        cin : in std_logic;
        sum : out std_logic_vector (N downto 0);
        cout : out std_logic);
end adder_ripple;

architecture adder of adder_ripple is
procedure Faddr (sf, cof : out std_logic;
        af, bf, cinf : in std_logic) is

--This procedure describes a full adder
begin

sf := af xor bf xor cinf;
cof := (af and bf) or (af and cinf) or (bf and cinf);
end Faddr;

begin
addrpl : process (x, y, cin)
variable c1, c2, tem1, tem2 : std_logic;
variable cint : std_logic_vector (N+1 downto 0);
variable sum1 : std_logic_vector (N downto 0);
begin
cint(0) := cin;
for i in 0 to N loop
    Faddr (sum1(i), cint(i+1), x(i), y(i), cint(i));
    --The above statement is a call to the procedure Faddr
end loop;
sum <= sum1;
cout <= cint(N+1);

end process;

end adder;
