library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_pipelineReg is
generic(N : integer := 32; gCLK_HPER   : time := 10 ns);
end tb_pipelineReg;

architecture mixed of tb_pipelineReg is

constant cCLK_PER  : time := gCLK_HPER * 2;

component registerIF_ID
  generic(N : integer := 32);

  port(i_CLK          : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input

       i_Imem         : in std_logic_vector(N-1 downto 0);

       i_PCplus4      : in std_logic_vector(N-1 downto 0);

       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       o_Imem         : out std_logic_vector(N-1 downto 0));

end component;


component registerID_EX 
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

end component;


component registerEX_MEM
  generic(N : integer := 32);
port(i_CLK            : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input

       i_ALU          : in std_logic_vector(N-1 downto 0);
       o_ALU          : out std_logic_vector(N-1 downto 0);
       i_PCplus4      : in std_logic_vector(N-1 downto 0);
       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       i_RT           : in std_logic_vector(N-1 downto 0);
       o_RT           : out std_logic_vector(N-1 downto 0);
       i_reg_addr     : in std_logic_vector(4 downto 0);
       o_reg_addr     : out std_logic_vector(4 downto 0);

       i_MemReg       : in std_logic;
       o_MemReg       : out std_logic;
       i_MemWrite     : in std_logic;
       o_MemWrite     : out std_logic;
       i_regWrite     : in std_logic;
       o_regWrite     : out std_logic;
       i_JumpLink     : in std_logic;
       o_JumpLink     : out std_logic;
       i_regDst       : in std_logic;
       o_regDst       : out std_logic;
       i_halt         : in std_logic;
       o_halt         : out std_logic);

end component;

component registerMEM_WB
  generic(N : integer := 32);
port(i_CLK            : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input

       i_MemtoReg     : in std_logic; 
       i_regWrite     : in std_logic; 
       i_JumpLink     : in std_logic; 
       i_halt         : in std_logic; 
       i_regDst       : in std_logic;
       i_PCplus4      : in std_logic_vector(N-1 downto 0);
       i_DMEM         : in std_logic_vector(N-1 downto 0);
       i_ALU          : in std_logic_vector(N-1 downto 0);
       i_reg_addr     : in std_logic_vector(4 downto 0);

       o_MemtoReg     : out std_logic; 
       o_regWrite     : out std_logic; 
       o_JumpLink     : out std_logic; 
       o_halt         : out std_logic; 
       o_regDst       : out std_logic;
       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       o_DMEM         : out std_logic_vector(N-1 downto 0);
       o_ALU          : out std_logic_vector(N-1 downto 0);
       o_reg_addr     : out std_logic_vector(4 downto 0));

end component;


  signal CLK              : std_logic;

  signal Imem             : std_logic_vector(31 downto 0);
  signal DMEM             : std_logic_vector(N-1 downto 0);
  signal halt             : std_logic;
  signal MemtoReg         : std_logic;
  signal MemWrite         : std_logic;
  signal ALUOp            : std_logic_vector(3 downto 0);
  signal ALUSrc           : std_logic;
  signal regWrite         : std_logic;
  signal JumpLink         : std_logic;
  signal ALU              : std_logic_vector(N-1 downto 0);
  signal regDst           : std_logic;
  signal PCplus4          : std_logic_vector(N-1 downto 0);
  signal RS               : std_logic_vector(N-1 downto 0);
  signal RT               : std_logic_vector(N-1 downto 0);
  signal reg_addr         : std_logic_vector(4 downto 0);
  signal SignExtended     : std_logic_vector(N-1 downto 0);

--pipeline 1 signals
  signal p1_RST           : std_logic := '0';
  signal p1_WE            : std_logic;
  signal p1_Imem          : std_logic_vector(31 downto 0);
  signal p1_PCplus4       : std_logic_vector(N-1 downto 0);

--pipeline 2 signals
  signal p2_RST           : std_logic := '0';
  signal p2_WE            : std_logic;
  signal p2_MemtoReg      : std_logic;
  signal p2_MemWrite      : std_logic;
  signal p2_ALUSrc        : std_logic;
  signal p2_regWrite      : std_logic;
  signal p2_JumpLink      : std_logic;
  signal p2_halt          : std_logic;
  signal p2_regDst        : std_logic;
  signal p2_ALUOp         : std_logic_vector(3 downto 0);
  signal p2_Imem          : std_logic_vector(N-1 downto 0);
  signal p2_SignExtended  : std_logic_vector(N-1 downto 0);
  signal p2_PCplus4       : std_logic_vector(N-1 downto 0);
  signal p2_RS            : std_logic_vector(N-1 downto 0);
  signal p2_RT            : std_logic_vector(N-1 downto 0);
  signal p2_reg_addr      : std_logic_vector(4 downto 0);

--pipeline 3 signals
  signal p3_RST           : std_logic := '0';
  signal p3_WE            : std_logic;
  signal p3_MemtoReg      : std_logic;
  signal p3_MemWrite      : std_logic;
  signal p3_regWrite      : std_logic;
  signal p3_JumpLink      : std_logic;
  signal p3_regDst        : std_logic;
  signal p3_halt          : std_logic;
  signal p3_PCplus4       : std_logic_vector(N-1 downto 0);
  signal p3_RT            : std_logic_vector(N-1 downto 0);
  signal p3_ALU           : std_logic_vector(N-1 downto 0);
  signal p3_reg_addr      : std_logic_vector(4 downto 0);

--pipeline 4 signals
  signal p4_RST           : std_logic := '0';
  signal p4_WE            : std_logic;
  signal p4_MemtoReg      : std_logic;
  signal p4_regWrite      : std_logic;
  signal p4_JumpLink      : std_logic;
  signal p4_halt          : std_logic;
  signal p4_regDst        : std_logic;
  signal p4_PCplus4       : std_logic_vector(N-1 downto 0);
  signal p4_DMEM          : std_logic_vector(N-1 downto 0);
  signal p4_ALU           : std_logic_vector(N-1 downto 0);
  signal p4_reg_addr      : std_logic_vector(4 downto 0);


begin


  pipeline1: registerIF_ID
  generic map(N => N)
  port map(i_CLK       =>  CLK,    
       i_RST           =>  p1_RST,
       i_WE            =>  p1_WE,

       i_Imem          =>  Imem,
       i_PCplus4       =>  PCplus4,

       o_Imem          =>  p1_Imem,
       o_PCplus4       =>  p1_PCplus4);


  pipeline2: registerID_EX
  generic map(N => N)
  port map(i_CLK       =>  CLK,    
       i_RST           =>  p2_RST,
       i_WE            =>  p2_WE,

       i_MemtoReg      =>  MemtoReg,
       i_MemWrite      =>  MemWrite,
       i_ALUOp         =>  ALUOp,
       i_ALUSrc        =>  ALUSrc,
       i_regWrite      =>  regWrite,
       i_JumpLink      =>  JumpLink, 
       i_halt          =>  halt, 
       i_regDst        =>  regDst,
       i_PCplus4       =>  p1_PCplus4,
       i_RS            =>  RS,
       i_RT            =>  RT,
       i_reg_addr      =>  reg_addr,
       i_SignExtended  =>  SignExtended,
       i_Imem          =>  p1_Imem,

       o_MemtoReg      =>  p2_MemtoReg,
       o_MemWrite      =>  p2_MemWrite,
       o_ALUOp         =>  p2_ALUOp,
       o_ALUSrc        =>  p2_ALUSrc,
       o_regWrite      =>  p2_regWrite,
       o_JumpLink      =>  p2_JumpLink, 
       o_halt          =>  p2_halt, 
       o_regDst        =>  p2_regDst,
       o_PCplus4       =>  p2_PCplus4,
       o_RS            =>  p2_RS,
       o_RT            =>  p2_RT,
       o_reg_addr      =>  p2_reg_addr,
       o_SignExtended  =>  p2_SignExtended,
       o_Imem          =>  p2_Imem);


  pipeline3: registerEX_MEM
  generic map(N => N)
  port map(i_CLK       =>  CLK,    
       i_RST           =>  p3_RST,
       i_WE            =>  p3_WE,

       i_ALU           =>  ALU,
       o_ALU           =>  p3_ALU,
       i_PCplus4       =>  p2_PCplus4,
       o_PCplus4       =>  p3_PCplus4,
       i_RT            =>  p2_RT,
       o_RT            =>  p3_RT,
       i_reg_addr      =>  p2_reg_addr,
       o_reg_addr      =>  p3_reg_addr,

       i_MemReg        =>  p2_MemtoReg,
       o_MemReg        =>  p3_MemtoReg,
       i_MemWrite      =>  p2_MemWrite,
       o_MemWrite      =>  p3_MemWrite,
       i_regWrite      =>  p2_regWrite,
       o_regWrite      =>  p3_regWrite,
       i_JumpLink      =>  p2_JumpLink,
       o_JumpLink      =>  p3_JumpLink,
       i_regDst        =>  p2_regDst,
       o_regDst        =>  p3_regDst,
       i_halt          =>  p2_halt,
       o_halt          =>  p3_halt);
 

  pipeline4: registerMEM_WB
  generic map(N => N)
  port map(i_CLK       =>  CLK,    
       i_RST           =>  p4_RST,
       i_WE            =>  p4_WE,
  
       i_MemtoReg      =>  p3_MemtoReg,
       i_regWrite      =>  p3_regWrite,
       i_JumpLink      =>  p3_JumpLink, 
       i_halt          =>  p3_halt, 
       i_regDst        =>  p3_regDst,
       i_PCplus4       =>  p3_PCplus4,
       i_DMEM          =>  DMEM,
       i_ALU           =>  p3_ALU,
       i_reg_addr      =>  p3_reg_addr,

       o_MemtoReg      =>  p4_MemtoReg,
       o_regWrite      =>  p4_regWrite,
       o_JumpLink      =>  p4_JumpLink,
       o_halt          =>  p4_halt,
       o_regDst        =>  p4_regDst,
       o_PCplus4       =>  p4_PCplus4,
       o_DMEM          =>  p4_DMEM,
       o_ALU           =>  p4_ALU,
       o_reg_addr      =>  p4_reg_addr);



  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;


  P_TEST_CASES: process

  begin


    wait for gCLK_HPER/2;
    wait for gCLK_HPER*2;
---------------------------------------- Test case 1: 
       --pipeline 1
       p1_RST           <=  '0';
       p1_WE            <=  '1';

       Imem          <=  x"0714FFFF";
       PCplus4       <=  x"58578099"; 

       --pipeline 2
       p2_RST           <=  '0';
       p2_WE            <=  '1';

       MemtoReg      <=  '1';
       MemWrite      <=  '0';
       ALUOp         <=  "0010";
       ALUSrc        <=  '0';
       regWrite      <=  '1';
       JumpLink      <=  '0';
       halt          <=  '0';
       regDst        <=  '1';
     --  p1_PCplus4    <=  x"58578099";
       RS            <=  x"00FF00FF";
       RT            <=  x"0000FE65";
       reg_addr      <=  "00110";
       SignExtended  <=  x"00005164";
    --   p1_Imem       <=  x"0714FFFF";

       --pipeline 3
       p3_RST           <=  '1';                            --Flushing
       p3_WE            <=  '1';

       ALU             <=  x"01234567";
    --   p2_PCplus4      <=  x"58578099";
     --  p2_RT           <=  x"0000FE65";
     --  p2_reg_addr     <=  "10011";
    --   p2_MemtoReg     <=  '1';
    --   p2_MemWrite     <=  '1';
    --   p2_regWrite     <=  '1';
    --   p2_JumpLink     <=  '0';
   --    p2_regDst       <=  '1';
   --    p2_halt         <=  '0';

    --pipeline 4
       p4_RST              <=  '1';                       --Flushing
       p4_WE               <=  '1';
  
     --  p3_MemtoReg      <=  '1';
     --  p3_regWrite      <=  '1';
     --  p3_JumpLink      <=  '0';
     --  p3_halt          <=  '0';
    --   p3_regDst        <=  '1';
    --   p3_PCplus4       <=  x"58578099";
       DMEM             <=  x"00246810";
    --   p3_ALU           <=  x"01234567";
    --   p3_reg_addr      <=  "01101"; 


    wait for gCLK_HPER*2;
    -- Expect: 


---------------------------------------- Test case 2: 
       --pipeline 1
       p1_RST           <=  '0';
       p1_WE            <=  '1';

       Imem          <=  x"0714FFFF";
       PCplus4       <=  x"58578099"; 

       --pipeline 2
       p2_RST           <=  '0';
       p2_WE            <=  '1';

       MemtoReg      <=  '1';
       MemWrite      <=  '0';
       ALUOp         <=  "0010";
       ALUSrc        <=  '0';
       regWrite      <=  '1';
       JumpLink      <=  '0';
       halt          <=  '0';
       regDst        <=  '1';
  --     p1_PCplus4    <=  x"58578099";
       RS            <=  x"00FF00FF";
       RT            <=  x"0000FE65";
       reg_addr      <=  "00110";
       SignExtended  <=  x"00005164";
     --  p1_Imem       <=  x"0714FFFF";

       --pipeline 3
       p3_RST           <=  '0';
       p3_WE            <=  '0';                       --Stalling

       ALU             <=  x"01234567";
     --  p2_PCplus4      <=  x"58578099";
      -- p2_RT           <=  x"0000FE65";
      -- p2_reg_addr     <=  "10011";
      -- p2_MemtoReg     <=  '0';
     --  p2_MemWrite     <=  '0';
      -- p2_regWrite     <=  '0';
      -- p2_JumpLink     <=  '1';
      -- p2_regDst       <=  '0';
     --  p2_halt         <=  '1';

    --pipeline 4
       p4_RST              <=  '0'; 
       p4_WE               <=  '0';                      --Stalling
  
      -- p3_MemtoReg      <=  '0';
      -- p3_regWrite      <=  '0';
       --p3_JumpLink      <=  '1';
      -- p3_halt          <=  '1';
      -- p3_regDst        <=  '0';
      -- p3_PCplus4       <=  x"0FFFFFFF";
       DMEM             <=  x"0DDDDDDD";
      -- p3_ALU           <=  x"0AAAAAAA";
      -- p3_reg_addr      <=  "00001"; 


    wait for gCLK_HPER*2;
    -- Expect: 


  end process;
end mixed;
