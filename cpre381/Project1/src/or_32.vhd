library IEEE;
use IEEE.std_logic_1164.all;

entity or_32 is
generic(N : integer := 32);

  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end or_32;

architecture dataflow of or_32 is
begin

NBit: for i in 0 to N-1 generate

  o_F(i) <= i_A(i) or i_B(i);

end generate NBit;
  
end dataflow;