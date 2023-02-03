-- library declaration

library IEEE;
use IEEE.std_logic_1164.all;
-- entity

entity Mux2to1_dataflow is
port (A,B,S : in std_logic;
      O : out std_logic);


end Mux2to1_dataflow;


-- architecture
architecture mux2t1 of Mux2to1_dataflow is
begin

O <= A when (S = '0') else
B when (S = '1' ) else
'0';


end mux2t1;
