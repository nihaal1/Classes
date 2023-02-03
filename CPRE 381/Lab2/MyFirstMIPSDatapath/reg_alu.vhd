library IEEE;
use IEEE.std_logic_1164.all;

entity reg_alu is

  generic(N : integer := 32;
	  M : integer := 5);

  port (SEL1    : in std_logic_vector(4 downto 0);   -- select line 1 [rs]
        SEL2    : in std_logic_vector(4 downto 0);   -- select line 2 [rt]
        wrEn    : in std_logic_vector(M-1 downto 0);  -- write enabler to choose reg(input of the decoder) RD (I messed up while naming)
        dstData : in std_logic_vector(N-1 downto 0);  -- Input to the register to store data(rd) 
	En	: in std_logic;	 		      -- enabler for the register
        i_CLK   : in std_logic;   		      -- Clock
        i_RST   : in std_logic;                       -- Reset
 
   	in_Mux_2: in std_logic_vector(N-1 downto 0);-- 2nd input of the intermediate 2to1 32 bit MUX
	immSel  : in std_logic;                           -- select line for the MUX 2to1, 32

	nAdd_Sub: in std_logic;                       -- select line for the ALU (add or sub)
        ALU_Out : out std_logic_vector(N-1 downto 0)); -- output from the ALU

end reg_alu;

architecture structure of reg_alu is

-- defining components

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

 component mux2to1_32
    port ( D0:  in std_logic_vector (31 downto 0);
           D1:  in std_logic_vector (31 downto 0);
           SEL: in std_logic;
           MX_OUT : out std_logic_vector (31 downto 0));

  end component;

--signals
        signal RS          : std_logic_vector(N-1 downto 0); 
        signal RT          : std_logic_vector(N-1 downto 0); 
        signal S_MX_OUT    : std_logic_vector(N-1 downto 0); 
        signal S_ALU_Out   : std_logic_vector(N-1 downto 0);


--port mapping


begin
     ALU_Out <= S_ALU_Out;

   reg1 : reg_file
	  port MAP(D_IN     => wrEn, 
	 	   En	    => En,	 		      
        	   i_CLK    => i_CLK,   		     
       		   i_RST    => i_RST,                       
        	   i_D      => S_ALU_Out, --dstData,
      		   SEL1     => SEL1,   
       		   SEL2     => SEL2,   
       		   MX_OUT1  => RS,
       		   MX_OUT2  => RT);

   mux32bit_1 : mux2to1_32
	  port MAP(D0       => RT,
                   D1       => in_Mux_2,
                   SEL      => immSel,
                   MX_OUT   => S_MX_OUT);


   add_sub1 : adder_sub
	  port MAP(A        => RS ,
      		   B        => S_MX_OUT ,
      	           nAdd_Sub => nAdd_Sub,
     		   O        => S_ALU_Out);



  end structure;













