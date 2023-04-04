library IEEE;
use IEEE.std_logic_1164.all;

entity ripple_adder is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(A         : in std_logic_vector(N-1 downto 0);
       B         : in std_logic_vector(N-1 downto 0);
       Cin       : in std_logic;
       Cout      : out std_logic;
       O         : out std_logic_vector(N-1 downto 0));

end ripple_adder;

architecture structural of ripple_adder is

  component full_adder is
   port(A 		            : in std_logic;
       B 		            : in std_logic;
       Cin 		            : in std_logic;
       Cout 		            : out std_logic;
       O 		            : out std_logic);
  end component;

  signal carry : std_logic_vector(N downto 0);
begin
  carry(0) <= Cin;
  
  -- Instantiate N mux instances.
  G_NBit_adder: for i in 0 to N-1 generate
    MUXI: full_adder port map(
              A     => A(i),  
              B     => B(i),  
              Cin   => carry(i),
              Cout  => carry(i+1),
              O     => O(i));
  end generate G_NBit_adder;
  
  Cout <= carry(N);
end structural;
