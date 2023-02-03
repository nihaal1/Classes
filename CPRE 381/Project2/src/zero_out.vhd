library IEEE;
use IEEE.std_logic_1164.all;

entity zero_out is
  generic(N : integer := 32); 
  port(A           : in std_logic_vector(N-1 downto 0);
       B           : in std_logic_vector(N-1 downto 0);
       zero_Output : out std_logic);

end zero_out;

architecture structural of zero_out is

  signal S_zero_out : std_logic_vector(31 downto 0);

 component adder_sub
    generic(N : integer := 32); 
  port(A         : in std_logic_vector(N-1 downto 0);
       B         : in std_logic_vector(N-1 downto 0);
       nAdd_Sub  : in std_logic;
       overflow  : out std_logic;
       O         : out std_logic_vector(N-1 downto 0));
  end component;




begin

  zero_out1 : adder_sub
   port MAP(A             => A,
            B             => B,
            nAdd_Sub      => '1',
            overflow      => open,
            O             => S_zero_out);



    zero_Output <=   '1' when (S_zero_out = x"00000000") else
		  '0';

end structural;
