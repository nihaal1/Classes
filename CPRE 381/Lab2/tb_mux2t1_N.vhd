library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_mux2t1_N is
  generic(N : integer := 16);
end tb_mux2t1_N;

architecture mixed of tb_mux2t1_N is

component mux2t1_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S                          : in std_logic;
       i_D0 		            : in std_logic_vector;
       i_D1 		            : in std_logic_vector;
       o_O 		            : out std_logic_vector);
end component;


  signal A1        : std_logic_vector(N-1 downto 0);
  signal B1        : std_logic_vector(N-1 downto 0);
  signal S1        : std_logic;
  signal output    : std_logic_vector(N-1 downto 0);

begin

  DUT0: mux2t1_N
  generic map(N => N)
  port map(
            i_D0     => A1(N-1 downto 0),
            i_D1       => B1(N-1 downto 0),
            i_S       => S1,
            o_O     => output(N-1 downto 0));

  P_TEST_CASES: process
  begin
 

    
    A1   <= x"FFFF";  
    B1   <= x"1211";
    S1 <= '0';
 
    wait for 10 ns;
 
    A1   <= x"3E11";  
    B1   <= x"EEEE";
    S1 <= '1';
 
    wait for 10 ns;
 

    
  end process;


end mixed;
