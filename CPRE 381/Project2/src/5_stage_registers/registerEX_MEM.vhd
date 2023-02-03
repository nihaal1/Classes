library IEEE;
use IEEE.std_logic_1164.all;

entity registerEX_MEM is

 generic(N : integer := 32); 

  port(i_CLK          : in std_logic;     -- Clock input
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





end registerEX_MEM;


architecture behavioral of registerEX_MEM is

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
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_regDst,
               o_Q           => o_regDst);  

    Ctrl_MemToReg: dffg 
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_MemReg,
               o_Q           => o_MemReg);    

    Ctrl_MemWrite: dffg 
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_MemWrite,
               o_Q           => o_MemWrite);   


    PCplus4: n_bit_reg 
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_PCplus4,
               o_Q           => o_PCplus4);   


    ALU_data: n_bit_reg 
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_ALU,
               o_Q           => o_ALU);    

    Ctrl_regWrite: dffg 
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_regWrite,
               o_Q           => o_regWrite); 

    Ctrl_JumpLink: dffg 
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_JumpLink,
               o_Q           => o_JumpLink);  

    Ctrl_halt: dffg 
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_halt,
               o_Q           => o_halt); 

    RT_data: n_bit_reg 
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_RT,
               o_Q           => o_RT);

    reg_address: n_bit_reg 
  generic map(N => 5)           --- ###################### is this right?????
      port map(i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
	       i_D           => i_reg_addr,
               o_Q           => o_reg_addr);


  
end behavioral;
