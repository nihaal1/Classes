library IEEE;
use IEEE.std_logic_1164.all;

entity nor_32 is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end nor_32;

architecture behavioural of nor_32 is
begin


  G_NBit_ONE: for i in 0 to N-1 generate

  o_O(i) <= i_D0(i) nor i_D1(i);

  end generate G_NBit_ONE;

end behavioural;
