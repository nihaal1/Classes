library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_OneComp is
  generic(N : integer := 32);
end tb_OneComp;

architecture mixed of tb_OneComp is

component OneComp is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0 		            : in std_logic_vector(N-1 downto 0);
       o_O 		            : out std_logic_vector(N-1 downto 0));
end component;


  signal A1        : std_logic_vector(N-1 downto 0);
  signal output    : std_logic_vector(N-1 downto 0);

begin

  DUT0: OneComp
  generic map(N => N)
  port map(
            i_D0     => A1(N-1 downto 0),
            o_O     => output(N-1 downto 0));

  P_TEST_CASES: process
  begin
 

    
    A1   <= x"00001010";  

    wait for 10 ns;
 
    A1   <= x"00000011";  
 
    wait for 10 ns;
 

    
  end process;


end mixed;
