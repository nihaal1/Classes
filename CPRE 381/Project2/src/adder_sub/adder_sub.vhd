library IEEE;
use IEEE.std_logic_1164.all;

entity adder_sub is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(A         : in std_logic_vector(N-1 downto 0);
       B         : in std_logic_vector(N-1 downto 0);
       nAdd_Sub  : in std_logic;
       overflow  : out std_logic;
       O         : out std_logic_vector(N-1 downto 0));

end adder_sub;

architecture structural of adder_sub is

 component OneComp
    port(i_D0                 : in std_logic_vector(N-1 downto 0);
         o_O                 : out std_logic_vector(N-1 downto 0));
  end component;

 component mux2t1_N
  generic(N : integer := 32);
    port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component ripple_adder is
  port(A         : in std_logic_vector(N-1 downto 0);
       B         : in std_logic_vector(N-1 downto 0);
       Cin       : in std_logic;
       ovfl      : out std_logic;
       Cout      : out std_logic;
       O         : out std_logic_vector(N-1 downto 0));

  end component;


  signal B1      :    std_logic_vector(N-1 downto 0);
  signal M1      :    std_logic_vector(N-1 downto 0);
  --signal O1      :    std_logic_vector(N-1 downto 0);
  signal Cout1   :    std_logic;

begin

  not_1 : OneComp
    port MAP(i_D0             => B,
             o_O             => B1);

  MUX_1 : mux2t1_N
    port MAP(i_S              => nAdd_Sub,
	     i_D0             => B,
             i_D1             => B1,
             o_O              => M1);
  
  ADD_1 : ripple_adder
    port MAP(A             => A,
	     B             => M1,
	     Cin           => nAdd_Sub,
             ovfl          => overflow,
             Cout          => Cout1,
             O             => O);

--   overflow <= O(31) xor Cout1;

end structural;
