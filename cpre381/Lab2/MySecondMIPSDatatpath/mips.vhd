library IEEE;
use IEEE.std_logic_1164.all;
--use Extenders.all;

entity mips is

  generic(N          : integer := 32;
	  M          : integer := 5;
	  DATA_WIDTH : natural := 32;
	  ADDR_WIDTH : natural := 10);

  port (rs_in    : in std_logic_vector(4 downto 0);   -- select line 1 [rs]
        rt_in    : in std_logic_vector(4 downto 0);   -- select line 2 [rt]
        rd    : in std_logic_vector(4 downto 0);      -- destination 
        wrEn    : in std_logic;                       -- write enabler 
        --dstData : in std_logic_vector(N-1 downto 0);  -- Input to the register to store 
	
        --En	: in std_logic;	 		      -- enabler for the register
        i_CLK   : in std_logic;   		      -- Clock
        i_RST   : in std_logic;                       -- Reset
 
   	imm     : in std_logic_vector(15 downto 0);       -- extender input
	immSel  : in std_logic;                           -- select line for the MUX 
	immExt  : in std_logic;
	mem2reg : in std_logic;

	we      : in std_logic;				-- we for Data Memory
	nAdd_Sub: in std_logic;                         -- select line for the ALU 
        Data_Out : out std_logic_vector(N-1 downto 0)); -- output from the ALU

end mips;

architecture structure of mips is

  component reg_file
    port (D_IN	: in std_logic_vector(M-1 downto 0); 
	  En	: in std_logic;	 		      
          i_CLK   : in std_logic;   		     
          i_RST   : in std_logic;                       
          i_D     : in std_logic_vector(N-1 downto 0);
          SEL1     : in std_logic_vector(4 downto 0);   
          SEL2     : in std_logic_vector(4 downto 0);   
          MX_OUT1  : out std_logic_vector (31 downto 0);
          MX_OUT2  : out std_logic_vector (31 downto 0));
  end component;

 component adder_sub
    port(A         : in std_logic_vector(N-1 downto 0);
         B         : in std_logic_vector(N-1 downto 0);
         nAdd_Sub  : in std_logic;
         O         : out std_logic_vector(N-1 downto 0));
  end component;

 component mem
    port (clk		: in std_logic;
	  addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
	  data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
	  we		: in std_logic := '1';
	  q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
  end component;

 component extender
  port(input 		            : in std_logic_vector (15 downto 0);
       sel 		            : in std_logic;
       output 		            : out std_logic_vector (31 downto 0));

  end component;

 component mux2to1_32
    port ( D0:  in std_logic_vector (31 downto 0);
           D1:  in std_logic_vector (31 downto 0);
           SEL: in std_logic;
           MX_OUT : out std_logic_vector (31 downto 0));

  end component;

--signals
        signal RS              : std_logic_vector(N-1 downto 0); 
        signal RT              : std_logic_vector(N-1 downto 0); 
        signal S_extenderOut   : std_logic_vector(N-1 downto 0);
        signal S_MX_OUT    : std_logic_vector(N-1 downto 0);   -- output signal for immMux
        signal S_ALU_Out   : std_logic_vector(N-1 downto 0);        
	signal S_Data_Out      : std_logic_vector(N-1 downto 0);
        signal S_MX_FinalOut    : std_logic_vector(N-1 downto 0);

begin
     Data_Out <= S_Data_Out;

   reg1 : reg_file
	  port MAP(D_IN     => rd, 
	 	   En	    => WrEn,	 		      
        	   i_CLK    => i_CLK,   		     
       		   i_RST    => i_RST,                       
        	   i_D      => S_MX_FinalOut,   --dstData
      		   SEL1     => rs_in,   
       		   SEL2     => rt_in,   
       		   MX_OUT1  => RS,
       		   MX_OUT2  => RT);

   extender_1 : extender
	  port MAP(input    => imm,
                   sel      => immExt,
                   output   => S_extenderOut);

   mux32bit_1 : mux2to1_32
	  port MAP(D0       => RT,
                   D1       => S_extenderOut,
                   SEL      => immSel,
                   MX_OUT   => S_MX_OUT);

   add_sub1 : adder_sub
	  port MAP(A        => RS ,
      		   B        => S_MX_OUT ,
      	           nAdd_Sub => nAdd_Sub,
     		   O        => S_ALU_Out);

   mux32bit_2 : mux2to1_32
	  port MAP(D0       => S_ALU_Out,
                   D1       => S_Data_Out,
                   SEL      => mem2reg,
                   MX_OUT   => S_MX_FinalOut);

   memory1 : mem
	  port MAP(clk      => i_CLK,
                   addr     => S_ALU_Out(9 downto 0), -- last 10 bits of the ALU output
                   data     => RT,
                   we       => we,
                   q   => S_Data_Out);

  end structure;











