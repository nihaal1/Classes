library IEEE;
use IEEE.std_logic_1164.all;


entity mux2to1_32 is
 port (D0:  in std_logic_vector (31 downto 0);
       D1:  in std_logic_vector (31 downto 0);
       SEL: in std_logic;
       MX_OUT : out std_logic_vector (31 downto 0)); 

end mux2to1_32;

architecture dataflow of mux2to1_32 is

begin

     with SEL select
	MX_OUT <= 
	D0  when '0',
	D1  when '1',
	x"--------" when others;

end dataflow;
