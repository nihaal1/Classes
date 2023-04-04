library IEEE;
use IEEE.std_logic_1164.all;

entity registerID_EX is

 generic(N : integer := 32); 

  port(i_CLK          : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input

       i_MemtoReg     : in std_logic; 
       i_MemWrite     : in std_logic; 
       i_ALUOp        : in std_logic_vector(3 downto 0);   
       i_ALUSrc       : in std_logic; 
       i_regWrite     : in std_logic; 
       i_JumpLink     : in std_logic; 
       i_halt         : in std_logic;
       i_regDst       : in std_logic;
       i_PCplus4      : in std_logic_vector(N-1 downto 0);
       i_RS           : in std_logic_vector(N-1 downto 0);
       i_RT           : in std_logic_vector(N-1 downto 0);
       i_reg_addr     : in std_logic_vector(4 downto 0);
       i_SignExtended : in std_logic_vector(N-1 downto 0);
       i_Imem         : in std_logic_vector(31 downto 0);

       o_MemtoReg     : out std_logic; 
       o_MemWrite     : out std_logic; 
       o_ALUOp        : out std_logic_vector(3 downto 0); 
       o_ALUSrc       : out std_logic; 
       o_regWrite     : out std_logic; 
       o_JumpLink     : out std_logic; 
       o_halt         : out std_logic;
       o_regDst       : out std_logic;
       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       o_RS           : out std_logic_vector(N-1 downto 0);
       o_RT           : out std_logic_vector(N-1 downto 0);
       o_reg_addr     : out std_logic_vector(4 downto 0);
       o_SignExtended : out std_logic_vector(N-1 downto 0);
       o_Imem         : out std_logic_vector(31 downto 0));


end registerID_EX;


architecture behavioral of registerID_EX is

component n_bit_reg is
   generic(N : integer := 32);
  port(i_CLK        : in std_logic;   
       i_RST        : in std_logic;   
       i_WE         : in std_logic;  
       i_D          : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));
  end component;


component dffg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
  end component;


begin

    Csignal_reg_Dst: dffg         
      port map(i_D            => i_regDst,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_regDst); 

    Csignal_MemtoReg: dffg         
      port map(i_D            => i_MemtoReg,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_MemtoReg);    

    Csignal_MemWrite: dffg 
      port map(i_D            => i_MemWrite,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_MemWrite);  

    Csignal_ALUOp:  n_bit_reg             
  generic map(N => 4) 
      port map(i_D            => i_ALUOp,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_ALUOp);    

    Csignal_ALUSrc: dffg 
      port map(i_D            => i_ALUSrc,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_ALUSrc);     

    Csignal_regWrite: dffg 
      port map(i_D            => i_regWrite,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_regWrite);      

    Csignal_JumpLink: dffg 
      port map(i_D            => i_JumpLink,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_JumpLink);   

    Csignal_halt: dffg 
      port map(i_D            => i_halt,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_halt);     

    PCplus4: n_bit_reg 
      port map(i_D            => i_PCplus4,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_PCplus4);     

    RS: n_bit_reg 
      port map(i_D            => i_RS,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_RS);  

    RT: n_bit_reg 
      port map(i_D            => i_RT,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_RT);   

    reg_address: n_bit_reg                          
  generic map(N => 5) 
      port map(i_D            => i_reg_addr,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_reg_addr);      

   signExtended: n_bit_reg 
      port map(i_D            => i_SignExtended,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_SignExtended);   

    instruction: n_bit_reg                          
      port map(i_D            => i_Imem,
               i_CLK          => i_CLK,
               i_RST          => i_RST,
               i_WE           => i_WE,
               o_Q            => o_Imem);  

    

  
end behavioral;
