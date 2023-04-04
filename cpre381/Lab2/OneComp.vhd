library IEEE;
use IEEE.std_logic_1164.all;

entity OneComp is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end OneComp;

architecture structural of OneComp is

  component invg is
    port(i_A                 : in std_logic;
         o_F                 : out std_logic);
  end component;

begin


  G_NBit_ONE: for i in 0 to N-1 generate
    ONEI: invg port map(
              i_A     => i_D0(i),  
              o_F      => o_O(i));  
  end generate G_NBit_ONE;
  
end structural;
