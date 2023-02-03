
library IEEE;
use IEEE.std_logic_1164.all;


entity full_adder is

  port(A 		            : in std_logic;
       B 		            : in std_logic;
       Cin 		            : in std_logic;
       Cout 		            : out std_logic;
       O 		            : out std_logic);
       

end full_adder;

architecture structure of full_adder is
  
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

  component xorg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;




 


  signal A1         : std_logic;
  signal B1         : std_logic;
  signal C1         : std_logic;

 

begin


  xorg_1: xorg2
    port MAP(i_A             => A,
             i_B               => B,
             o_F               => A1);

  and_1: andg2
    port MAP(i_A             => A,
             i_B               => B,
             o_F               => B1); 
  
  xorg_2: xorg2
    port MAP(i_A             => A1,
             i_B               => Cin,
             o_F               => O);


  and_2: andg2
    port MAP(i_A             => A1,
             i_B               => Cin,
             o_F               => C1);

  or_1: org2
    port MAP(i_A             => C1,
             i_B               => B1,
             o_F               => Cout);

  end structure;
