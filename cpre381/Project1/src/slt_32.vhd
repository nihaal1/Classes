library IEEE;
use IEEE.std_logic_1164.all;

entity slt_32 is
generic(N : integer := 32);

  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end slt_32;

architecture dataflow of slt_32 is

component adder_sub is
    port( A 	        : in std_logic_vector(N-1 downto 0);
	  B		: in std_logic_vector(N-1 downto 0);
          nAdd_Sub      : in std_logic; 
          overflow      : out std_logic; 
	  O		: out std_logic_vector(N-1 downto 0));
  end component; 

signal o              : std_logic_vector(N-1 downto 0);
signal Cout           : std_logic;
signal over_flow      : std_logic;


begin

    Add_Sub: adder_sub 
      port map(A             => i_A,
               B             => i_B,
               O             => o,
               nAdd_SUb      => '1',
	       overflow      => over_flow); 

  --o_F <= "000000000000000" AND  o(31) 

  o_F <= x"00000001" when (o(31) = '1') else
         x"00000000" when (o(31) = '0') else
         x"--------";

  
end dataflow;
