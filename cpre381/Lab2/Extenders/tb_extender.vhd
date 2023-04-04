library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_extender is

end tb_extender;

architecture mixed of tb_extender is

component extender is
  port(input 		            : in std_logic_vector (15 downto 0);
       sel 		            : in std_logic;
       output 		            : out std_logic_vector (31 downto 0));
end component;

  signal S_in		        : std_logic_vector (15 downto 0);
  signal S_sel		        : std_logic;
  signal S_out  		: std_logic_vector (31 downto 0);

begin
    ext1: extender
    port map(
	     input     => S_in,
	     sel       => S_sel,
	     output    => S_out);

     P_TEST_CASES: process
     begin

       S_in   <= x"1111";
       S_sel  <= '0';

       wait for 10 ns;

       S_in   <= x"BEEF";
       S_sel  <= '0';

       wait for 10 ns;


       S_in   <= x"BEEF";
       S_sel  <= '1';

       wait for 10 ns;


       S_in   <= x"0FFF";
       S_sel  <= '0';

       wait;
  

   end process;

end mixed;
