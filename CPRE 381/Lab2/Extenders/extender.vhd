library IEEE;
use IEEE.std_logic_1164.all;


entity extender is

  port(input 		            : in std_logic_vector (15 downto 0);
       sel 		            : in std_logic;
       output 		            : out std_logic_vector (31 downto 0));

end extender;


architecture dataflow of extender is
  

   begin
    output <=   x"FFFF" & input when (input(15) = '1'AND sel = '1') else
		x"0000" & input;

  end dataflow;
