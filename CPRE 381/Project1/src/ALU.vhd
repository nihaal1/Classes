library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(A           : in std_logic_vector(N-1 downto 0);
       B           : in std_logic_vector(N-1 downto 0);
       shamt       : in std_logic_vector(4 downto 0);
       replqb_in   : in std_logic_vector(7 downto 0);
       ALU_control : in std_logic_vector(3 downto 0);
       zero_out    : out std_logic;
       overflow    : out std_logic;
       Output      : out std_logic_vector(N-1 downto 0));

end ALU;

architecture structural of ALU is

--port defining
 component mux16to1 
  port(D0:  in std_logic_vector (31 downto 0);
       D1:  in std_logic_vector (31 downto 0);
       D2:  in std_logic_vector (31 downto 0);
       D3:  in std_logic_vector (31 downto 0);
       D4:  in std_logic_vector (31 downto 0);
       D5:  in std_logic_vector (31 downto 0);
       D6:  in std_logic_vector (31 downto 0);
       D7:  in std_logic_vector (31 downto 0);
       D8:  in std_logic_vector (31 downto 0);
       D9:  in std_logic_vector (31 downto 0);
       D10: in std_logic_vector (31 downto 0);
       D11: in std_logic_vector (31 downto 0);
       D12: in std_logic_vector (31 downto 0);
       D13: in std_logic_vector (31 downto 0);
       D14: in std_logic_vector (31 downto 0);
       D15: in std_logic_vector (31 downto 0);

       SEL: in std_logic_vector(3 downto 0);
       MX_OUT : out std_logic_vector (31 downto 0));
  end component;


 component adder_sub
    generic(N : integer := 32); 
  port(A         : in std_logic_vector(N-1 downto 0);
       B         : in std_logic_vector(N-1 downto 0);
       nAdd_Sub  : in std_logic;
       overflow  : out std_logic;
       O         : out std_logic_vector(N-1 downto 0));
  end component;

  component and_32 is
    generic(N : integer := 32);
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component or_32 is
    generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
  end component;



  component BarrelShifter is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Data          : in std_logic_vector(N-1 downto 0);
	i_Shift	       : in std_logic_vector(4 downto 0);
	i_RoL	       : in std_logic;
	i_AoL	       : in std_logic;
        o_X            : out std_logic_vector(N-1 downto 0));

  end component;

  component xor_32 is
    generic(N : integer := 32); 
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component nor_32 is
    generic(N : integer := 32); 
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;


  component slt_32 is
    generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
  end component;


  component repl is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(7 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;




-- defining signals

        signal S_add_sub    : std_logic_vector(31 downto 0);
        signal S_zero_out   : std_logic_vector(31 downto 0);
        signal S_and        : std_logic_vector(31 downto 0);
        signal S_or         : std_logic_vector(31 downto 0);
        signal S_sll        : std_logic_vector(31 downto 0);
        signal S_srl        : std_logic_vector(31 downto 0);
        signal S_sra        : std_logic_vector(31 downto 0);
        signal S_xor        : std_logic_vector(31 downto 0);
        signal S_nor        : std_logic_vector(31 downto 0);
        signal S_slt        : std_logic_vector(31 downto 0);
        signal S_repl       : std_logic_vector(31 downto 0);
        signal S_movn       : std_logic_vector(31 downto 0);
        signal S_lui        : std_logic_vector(31 downto 0);



        signal S_MX_OUT    : std_logic_vector(N-1 downto 0);


--port maping
begin

  mux_select : mux16to1
    port MAP(D0             => S_add_sub,
             D1             => S_add_sub,
             D2             => S_and,
             D3             => S_or,
             D4             => S_sll,  --yet to impliment (D4 - d6, D9,D10)
             D5             => S_srl,
             D6             => S_sra,
             D7             => S_xor,
             D8             => S_nor,
             D9             => S_slt,
             D10            => S_repl,
             D11            => S_movn,
             D12            => S_lui,
             D13            => x"00000000",
             D14            => x"00000000",
             D15            => x"00000000",
             SEL            => ALU_control,
             MX_OUT         => Output);

  add_sub : adder_sub
    port MAP(A             => A,
             B             => B,
             nAdd_Sub      => ALU_control(0),
             overflow      => overflow,
             O             => S_add_sub);




  zero_out1 : adder_sub
   port MAP(A             => A,
            B             => B,
            nAdd_Sub      => '1',
            overflow      => open,
            O             => S_zero_out);



    zero_out <=   '1' when (S_zero_out = x"00000000") else
		  '0';

  and1 : and_32
    port MAP(i_D0             => A,
             i_D1             => B,
             o_O             => S_and);

  or1 : or_32
    port MAP(i_A             => A,
             i_B             => B,
             o_F             => S_or);





  repl1 : repl
    port MAP(i_D0 => replqb_in,
             o_O => S_repl);


  xor1 : xor_32
    port MAP(i_D0             => A,
             i_D1             => B,
             o_O             => S_xor);

  nor1 : nor_32
    port MAP(i_D0             => A,
             i_D1             => B,
             o_O             => S_nor);
  
  sll1 : BarrelShifter
    port MAP(i_Data => B,
	i_Shift => shamt,
	i_RoL => '0',
	i_AoL => '0',
        o_X => S_sll);

  srl1 : BarrelShifter
    port MAP(i_Data => B,
	i_Shift => shamt,
	i_RoL => '1',
	i_AoL => '0',
        o_X => S_srl);

  sra1 : BarrelShifter
    port MAP(i_Data => B,
	i_Shift => shamt,
	i_RoL => '1',
	i_AoL => '1',
        o_X => S_sra);


  slt1 : slt_32
    port MAP(i_A             => A,
             i_B             => B,
             o_F             => S_slt);


  S_movn <= A;

  S_lui(31 downto 16) <= B(15 downto 0);
  S_lui(15 downto 0)  <= x"0000";


end structural;

















