library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_Mux2to1_dataflow is

end tb_Mux2to1_dataflow;

architecture mixed of tb_Mux2to1_dataflow is

component Mux2to1_dataflow is
  port(A                            : in std_logic;
       B 		            : in std_logic;
       S 		            : in std_logic;
       O 		            : out std_logic);
end component;


  signal A1         : std_logic;
  signal B1         : std_logic;
  signal S1         : std_logic;
  signal output     : std_logic;

begin

  DUT0: Mux2to1_dataflow
  port map(
            A     => A1,
            B       => B1,
            S       => S1,
            O     => output);

  P_TEST_CASES: process
  begin
 

    
    A1   <= '0';  
    B1   <= '1';
    S1 <= '0';
 
    wait for 10 ns;
 
    A1   <= '0';  
    B1   <= '1';
    S1 <= '1';
 
    wait for 10 ns;
 

    
  end process;


end mixed;
