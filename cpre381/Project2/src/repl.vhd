library IEEE;
use IEEE.std_logic_1164.all;

entity repl is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(7 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end repl;

architecture behavioural of repl is
begin  

  o_O <= i_D0 & i_D0 & i_D0 & i_D0;

  

end behavioural;