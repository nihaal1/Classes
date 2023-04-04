library IEEE;
use IEEE.std_logic_1164.all;


entity mux2to1_5 is
 port (D0:  in std_logic_vector (4 downto 0);
       D1:  in std_logic_vector (4 downto 0);
       SEL: in std_logic;
       MX_OUT : out std_logic_vector (4 downto 0)); 

end mux2to1_5;

architecture dataflow of mux2to1_5 is

begin

     with SEL select
	MX_OUT <= 
	D0  when '0',
	D1  when '1',
	"-----" when others;

end dataflow;
