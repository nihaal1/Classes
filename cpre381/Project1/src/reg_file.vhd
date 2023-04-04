library IEEE;
use IEEE.std_logic_1164.all;

entity reg_file is

  generic(N : integer := 32;
	  M : integer := 5);

  port (D_IN	: in std_logic_vector(M-1 downto 0);  -- input of decoder (tells which register to write to)
	En	: in std_logic;	 		      -- enabler for the register
        i_CLK   : in std_logic;   		      -- Clock
        i_RST   : in std_logic;                       -- Reset
        i_D     : in std_logic_vector(N-1 downto 0);  -- Input to the register to store data 
        SEL1     : in std_logic_vector(4 downto 0);   -- select line 1 for mux to output data from the register
        SEL2     : in std_logic_vector(4 downto 0);   -- select line 1 for mux to output data from the register
        MX_OUT1  : out std_logic_vector (31 downto 0);-- Output from 1st MUX
        MX_OUT2  : out std_logic_vector (31 downto 0));-- Output from second MUX

end reg_file;

architecture structure of reg_file is

   component decoder_32
  port (D_IN	: in std_logic_vector(M-1 downto 0);
	En	: in std_logic;	
	F_OUT	: out std_logic_vector(N-1 downto 0));

   end component;


   component n_bit_reg
  port(i_CLK        : in std_logic;   
       i_RST        : in std_logic;   
       i_WE         : in std_logic;  
       i_D          : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));

  end component;


   component mux32to1
 port (D0:  in std_logic_vector (31 downto 0);
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

       D16: in std_logic_vector (31 downto 0);
       D17: in std_logic_vector (31 downto 0);
       D18: in std_logic_vector (31 downto 0);
       D19: in std_logic_vector (31 downto 0);
       D20: in std_logic_vector (31 downto 0);
       D21: in std_logic_vector (31 downto 0);
       D22: in std_logic_vector (31 downto 0);
       D23: in std_logic_vector (31 downto 0);
       D24: in std_logic_vector (31 downto 0);
       D25: in std_logic_vector (31 downto 0);
       D26: in std_logic_vector (31 downto 0);
       D27: in std_logic_vector (31 downto 0);
       D28: in std_logic_vector (31 downto 0);
       D29: in std_logic_vector (31 downto 0);
       D30: in std_logic_vector (31 downto 0);
       D31: in std_logic_vector (31 downto 0);

       SEL: in std_logic_vector(4 downto 0);
       MX_OUT : out std_logic_vector (31 downto 0));
   end component;


	--SIGNALS

	signal S_IN         : std_logic_vector(M-1 downto 0);  -- in dec
	signal S_En         : std_logic;                       -- en dec
	signal S_DeOut      : std_logic_vector(N-1 downto 0); -- out dec

	signal S_CLK        : std_logic;                       -- clk signal
        signal S_RST        : std_logic;                       -- reset signal

	signal S_D          : std_logic_vector(N-1 downto 0);  -- input signal for reg


        signal S_Q0          : std_logic_vector(N-1 downto 0);  -- output signal for reg
        signal S_Q1          : std_logic_vector(N-1 downto 0);  
        signal S_Q2          : std_logic_vector(N-1 downto 0);  
        signal S_Q3          : std_logic_vector(N-1 downto 0);  
        signal S_Q4          : std_logic_vector(N-1 downto 0);  
        signal S_Q5          : std_logic_vector(N-1 downto 0);  
        signal S_Q6          : std_logic_vector(N-1 downto 0);  
        signal S_Q7          : std_logic_vector(N-1 downto 0);  
        signal S_Q8          : std_logic_vector(N-1 downto 0);  
        signal S_Q9          : std_logic_vector(N-1 downto 0);  
        signal S_Q10          : std_logic_vector(N-1 downto 0);  
        signal S_Q11          : std_logic_vector(N-1 downto 0); 
        signal S_Q12          : std_logic_vector(N-1 downto 0); 
        signal S_Q13          : std_logic_vector(N-1 downto 0); 
        signal S_Q14          : std_logic_vector(N-1 downto 0); 
        signal S_Q15          : std_logic_vector(N-1 downto 0); 
        signal S_Q16          : std_logic_vector(N-1 downto 0); 
        signal S_Q17          : std_logic_vector(N-1 downto 0); 
        signal S_Q18          : std_logic_vector(N-1 downto 0); 
        signal S_Q19          : std_logic_vector(N-1 downto 0); 
        signal S_Q20          : std_logic_vector(N-1 downto 0); 
        signal S_Q21          : std_logic_vector(N-1 downto 0); 
        signal S_Q22          : std_logic_vector(N-1 downto 0); 
        signal S_Q23          : std_logic_vector(N-1 downto 0); 
        signal S_Q24          : std_logic_vector(N-1 downto 0); 
        signal S_Q25          : std_logic_vector(N-1 downto 0); 
        signal S_Q26          : std_logic_vector(N-1 downto 0); 
        signal S_Q27          : std_logic_vector(N-1 downto 0); 
        signal S_Q28          : std_logic_vector(N-1 downto 0); 
        signal S_Q29          : std_logic_vector(N-1 downto 0); 
        signal S_Q30          : std_logic_vector(N-1 downto 0); 
        signal S_Q31          : std_logic_vector(N-1 downto 0); 



  
	signal S_SEL1        : std_logic_vector(4 downto 0);    -- sel mux  -- do i need 1 more ofthis?
	signal S_SEL2        : std_logic_vector(4 downto 0);
	 --signal S_MX_OUT1     : std_logic_vector (31 downto 0); -- mux out
	--signal S_MX_OUT2     : std_logic_vector (31 downto 0);

begin

 S_Clk <= i_CLK; --maping signals
 S_RST <= i_RST;
 S_D   <= i_D;
 
 


  dec_1: decoder_32
    port MAP(D_IN             => D_IN, --S_IN,
	     En               => En, --S_En,
	     F_OUT            => S_DeOut);    -- not sure if this is correct, output of dec to wE of reg       



  reg_0: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(0), 
             i_D                => S_D,
             o_Q                => S_Q0); 

  reg_1: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(1), 
             i_D                => S_D,
             o_Q                => S_Q1);

  reg_2: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(2), 
             i_D                => S_D,
             o_Q                => S_Q2);

  reg_3: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(3), 
             i_D                => S_D,
             o_Q                => S_Q3);

  reg_4: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(4), 
             i_D                => S_D,
             o_Q                => S_Q4);

  reg_5: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(5), 
             i_D                => S_D,
             o_Q                => S_Q5);

  reg_6: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(6), 
             i_D                => S_D,
             o_Q                => S_Q6);

  reg_7: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(7), 
             i_D                => S_D,
             o_Q                => S_Q7);

  reg_8: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(8), 
             i_D                => S_D,
             o_Q                => S_Q8);

  reg_9: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(9), 
             i_D                => S_D,
             o_Q                => S_Q9);

  reg_10: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(10), 
             i_D                => S_D,
             o_Q                => S_Q10);

  reg_11: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(11), 
             i_D                => S_D,
             o_Q                => S_Q11);

  reg_12: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(12), 
             i_D                => S_D,
             o_Q                => S_Q12);

  reg_13: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(13), 
             i_D                => S_D,
             o_Q                => S_Q13);

  reg_14: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(14), 
             i_D                => S_D,
             o_Q                => S_Q14);

  reg_15: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(15), 
             i_D                => S_D,
             o_Q                => S_Q15);

  reg_16: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(16), 
             i_D                => S_D,
             o_Q                => S_Q16);

  reg_17: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(17), 
             i_D                => S_D,
             o_Q                => S_Q17);

  reg_18: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(18), 
             i_D                => S_D,
             o_Q                => S_Q18);

  reg_19: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(19), 
             i_D                => S_D,
             o_Q                => S_Q19);

  reg_20: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(20), 
             i_D                => S_D,
             o_Q                => S_Q20);

  reg_21: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(21), 
             i_D                => S_D,
             o_Q                => S_Q21); 

  reg_22: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(22), 
             i_D                => S_D,
             o_Q                => S_Q22);

  reg_23: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(23), 
             i_D                => S_D,
             o_Q                => S_Q23);

  reg_24: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(24), 
             i_D                => S_D,
             o_Q                => S_Q24);

  reg_25: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(25), 
             i_D                => S_D,
             o_Q                => S_Q25); 

  reg_26: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(26), 
             i_D                => S_D,
             o_Q                => S_Q26);

  reg_27: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(27), 
             i_D                => S_D,
             o_Q                => S_Q27);

  reg_28: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(28), 
             i_D                => S_D,
             o_Q                => S_Q28);

  reg_29: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(29), 
             i_D                => S_D,
             o_Q                => S_Q29); 

  reg_30: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(30), 
             i_D                => S_D,
             o_Q                => S_Q30);

  reg_31: n_bit_reg
    port MAP(i_CLK              => S_CLK,
             i_RST              => S_RST,    
             i_WE               => S_DeOut(31), 
             i_D                => S_D,
             o_Q                => S_Q31);








  mux_1: mux32to1
    port MAP( D0        =>  S_Q0, 
       D1               =>  S_Q1, 
       D2               =>  S_Q2, 
       D3               =>  S_Q3, 
       D4               =>  S_Q4, 
       D5               =>  S_Q5, 
       D6               =>  S_Q6, 
       D7               =>  S_Q7, 
       D8               =>  S_Q8, 
       D9               =>  S_Q9, 
       D10              =>  S_Q10, 
       D11              =>  S_Q11, 
       D12              =>  S_Q12, 
       D13              =>  S_Q13, 
       D14              =>  S_Q14, 
       D15              =>  S_Q15, 

       D16              =>  S_Q16, 
       D17              =>  S_Q17, 
       D18              =>  S_Q18, 
       D19              =>  S_Q19, 
       D20              =>  S_Q20, 
       D21              =>  S_Q21, 
       D22              =>  S_Q22, 
       D23              =>  S_Q23, 
       D24              =>  S_Q24, 
       D25              =>  S_Q25, 
       D26              =>  S_Q26, 
       D27              =>  S_Q27, 
       D28              =>  S_Q28, 
       D29              =>  S_Q29, 
       D30              =>  S_Q30, 
       D31              =>  S_Q31, 

       SEL              =>   SEL1,  
       MX_OUT           =>   MX_OUT1);

  mux_2: mux32to1
    port MAP( D0        =>  S_Q0, 
       D1               =>  S_Q1, 
       D2               =>  S_Q2, 
       D3               =>  S_Q3, 
       D4               =>  S_Q4, 
       D5               =>  S_Q5, 
       D6               =>  S_Q6, 
       D7               =>  S_Q7, 
       D8               =>  S_Q8, 
       D9               =>  S_Q9, 
       D10              =>  S_Q10, 
       D11              =>  S_Q11, 
       D12              =>  S_Q12, 
       D13              =>  S_Q13, 
       D14              =>  S_Q14, 
       D15              =>  S_Q15, 

       D16              =>  S_Q16, 
       D17              =>  S_Q17, 
       D18              =>  S_Q18, 
       D19              =>  S_Q19, 
       D20              =>  S_Q20, 
       D21              =>  S_Q21, 
       D22              =>  S_Q22, 
       D23              =>  S_Q23, 
       D24              =>  S_Q24, 
       D25              =>  S_Q25, 
       D26              =>  S_Q26, 
       D27              =>  S_Q27, 
       D28              =>  S_Q28, 
       D29              =>  S_Q29, 
       D30              =>  S_Q30, 
       D31              =>  S_Q31, 

       SEL              =>   SEL2,  
       MX_OUT           =>   MX_OUT2);


  end structure;


















