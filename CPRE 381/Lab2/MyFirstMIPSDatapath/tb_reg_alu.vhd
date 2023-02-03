library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_reg_alu is
  generic(N : integer := 32;
	  M : integer := 5;
  	  gCLK_HPER   : time := 10 ns);

end tb_reg_alu;

architecture mixed of tb_reg_alu is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component reg_alu is
  generic(N : integer := 32;
	  M : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
  port (SEL1    : in std_logic_vector(4 downto 0);   -- select line 1 [rs]
        SEL2    : in std_logic_vector(4 downto 0);   -- select line 2 [rt]
        wrEn    : in std_logic_vector(M-1 downto 0);  -- write enabler to choose reg (decoder)[rd]
        dstData : in std_logic_vector(N-1 downto 0);  -- Input to the 'register' to store data(rd) 
	En	: in std_logic;	 		      -- enabler for the register
        i_CLK   : in std_logic;   		      -- Clock
        i_RST   : in std_logic;                       -- Reset
 
   	in_Mux_2: in std_logic_vector(N-1 downto 0);-- 2nd input of the intermediate 2to1 32 
	immSel  : in std_logic;                           -- select line for the MUX 2to1, 32

	nAdd_Sub: in std_logic;                       -- select line for the ALU (add or sub)
        ALU_Out : out std_logic_vector(N-1 downto 0)); -- output from the ALU
end component;


       signal SEL1    :  std_logic_vector(4 downto 0);   
       signal SEL2    :  std_logic_vector(4 downto 0);  
       signal wrEn    :  std_logic_vector(M-1 downto 0);  
       signal dstData :  std_logic_vector(N-1 downto 0);  
       signal En      :  std_logic;	 		     
       signal i_CLK   :  std_logic;   		      
       signal i_RST   :  std_logic;                     
       signal in_Mux_2:  std_logic_vector(N-1 downto 0);
       signal immSel  :  std_logic;                      
       signal nAdd_Sub:  std_logic;                   
       signal ALU_Out :  std_logic_vector(N-1 downto 0); 

begin

  DUT0: reg_alu
  generic map(N => N, M => M)
  port map(
            SEL1      => SEL1,
            SEL2      => SEL2,
            wrEn      => wrEn,
            dstData   => dstData,
            En        => En,
            i_CLK     => i_CLK,
            i_RST     => i_RST,

            in_Mux_2  => in_Mux_2,
            immSel    => immSel,

            nAdd_Sub  => nAdd_Sub,
            ALU_Out   => ALU_Out);


  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    i_CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    i_CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;


  P_TEST_CASES: process
  begin
	
	wait for  gCLK_HPER;
	
    i_RST   <= '1';
    wait for gCLK_HPER;
    i_RST   <= '0';

			--Test Cases from lab doc

    wrEn   <= "00001";         --RD 
    SEL1   <= "00000";         --rs
    SEL2   <= "-----";         --rt
    --dstData   <= x"00000"; 
    En   <= '1';               --wrEn (Write Enabler)
    in_Mux_2   <= x"00000001"; --imm
    immSel   <= '1';           -- choose b/w ReadB or imm
    nAdd_Sub   <= '0';         -- 0 - add, 1 - sub

    wait for cCLK_PER;

    wrEn   <= "00010";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000002"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
 

    wait for cCLK_PER;

    wrEn   <= "00011";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000003"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
 

    wait for cCLK_PER;

    wrEn   <= "00100";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000004"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;

    wrEn   <= "00100";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000004"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    wrEn   <= "00101";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000005"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    wrEn   <= "00110";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000006"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    wrEn   <= "00110";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000006"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    wrEn   <= "00111";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000007"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    wrEn   <= "01000";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000008"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    wrEn   <= "01001";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"00000009"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    wrEn   <= "01010";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    En   <= '1';    
    in_Mux_2   <= x"0000000A"; 
    immSel   <= '1'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;
	
					---- 10
    En   <= '1'; 
    wrEn   <= "01011";  --RD           ----  $11 = $1+$2 = 1 + 2 = 3
    SEL1   <= "00001";  
    SEL2   <= "00010"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0'; 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;

		 		 
    En   <= '1'; 
    wrEn   <= "01100";  --RD 
    SEL1   <= "01011";  
    SEL2   <= "00011"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0';				 ---12    $11-$3 = 3 - 3 = 0
    nAdd_Sub   <= '1'; 
    wait for cCLK_PER; 			 
					

    En   <= '1'; 
    wrEn   <= "01101";  --RD 
    SEL1   <= "01100";  
    SEL2   <= "00100"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0'; 				 ---13    $12+$4 = 0 + 4 = 4
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    En   <= '1'; 
    wrEn   <= "01110";  --RD 
    SEL1   <= "01101";  
    SEL2   <= "00101"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0';  				 ---14    $13-$5 = 4-5 = -1 = FFFFFFFF
    nAdd_Sub   <= '1'; 
    wait for cCLK_PER;
					 

    En   <= '1'; 
    wrEn   <= "01111";  --RD 
    SEL1   <= "01110";  
    SEL2   <= "00110"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0';   				 ---15    $14+$6 = -1 + 6 = 5 
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;
					



    En   <= '1'; 
    wrEn   <= "10000";  --RD 
    SEL1   <= "01111";  
    SEL2   <= "00111"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0';   				 ---16    $15-$7 = 5 - 7 = -2 = FFFFFFFE
    nAdd_Sub   <= '1'; 
    wait for cCLK_PER;


    En   <= '1'; 
    wrEn   <= "10001";  --RD 
    SEL1   <= "10000";  
    SEL2   <= "01000"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0';    		          ---17   $16+$8 = -2 + 8 = 6
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    En   <= '1'; 
    wrEn   <= "10010";  --RD 
    SEL1   <= "10001";  
    SEL2   <= "01001"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0';     		          ---18    17-9
    nAdd_Sub   <= '1'; 
    wait for cCLK_PER;
 
 


    En   <= '1'; 
    wrEn   <= "10011";  --RD 
    SEL1   <= "10010";  
    SEL2   <= "01010"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0';   				 ---19    18+10
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    En   <= '1'; 
    wrEn   <= "10100";  --RD 
    SEL1   <= "00000";  
    SEL2   <= "-----"; 
    in_Mux_2   <= x"FFFFFFDD"; 
    immSel   <= '1';    		          ---20   Place -35 in $20
    nAdd_Sub   <= '0'; 
    wait for cCLK_PER;


    En   <= '1'; 
    wrEn   <= "10101";  --RD 
    SEL1   <= "10011";  
    SEL2   <= "10100"; 
    in_Mux_2   <= x"--------"; 
    immSel   <= '0';     		          ---21    19+20
    nAdd_Sub   <= '0'; 


    wait;

    
  end process;


end mixed;





















