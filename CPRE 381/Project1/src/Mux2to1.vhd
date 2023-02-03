
library IEEE;
use IEEE.std_logic_1164.all;


entity Mux2to1 is

  port(A 		            : in std_logic;
       B 		            : in std_logic;
       S 		            : in std_logic;
       O 		            : out std_logic);

end Mux2to1;

architecture structure of Mux2to1 is
  
  component andg2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component org2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component invg
    port(i_A          : in std_logic;
       o_F          : out std_logic);
  end component;

 

  -- Signal to carry stored weight
  signal A1         : std_logic;
  -- Signals to carry delayed X
  signal B1  : std_logic;
  -- Signal to carry delayed Y
  signal S1        : std_logic;

 

begin


  not_1: invg
    port MAP(i_A               => S,
	     o_F               => S1);            


  and_1: andg2
    port MAP(i_A             => A,
             i_B               => S1,
             o_F               => A1); 
  
  and_2: andg2
    port MAP(i_A             => B,
             i_B               => S,
             o_F               => B1);

  or_2: org2
    port MAP(i_A             => A1,
             i_B               => B1,
             o_F               => O);

  end structure;
