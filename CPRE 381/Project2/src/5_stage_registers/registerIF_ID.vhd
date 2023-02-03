library IEEE;
use IEEE.std_logic_1164.all;

entity registerIF_ID is

 generic(N : integer := 32); 

  port(i_CLK          : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input
       i_Imem         : in std_logic_vector(N-1 downto 0);
       i_PCplus4      : in std_logic_vector(N-1 downto 0);
       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       o_Imem         : out std_logic_vector(N-1 downto 0));

end registerIF_ID;


architecture behavioral of registerIF_ID is

  component n_bit_reg is
   generic(N : integer := 32);
  port(i_CLK        : in std_logic;   
       i_RST        : in std_logic;   
       i_WE         : in std_logic;  
       i_D          : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));
  end component;


begin

    instruction: n_bit_reg 
      port map(i_D           => i_Imem,
               i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
               o_Q           => o_Imem);    

    PCplus4: n_bit_reg 
      port map(i_D           => i_PCplus4,
               i_CLK         => i_CLK,
               i_RST         => i_RST,
               i_WE          => i_WE,
               o_Q           => o_PCplus4);    


  
end behavioral;
