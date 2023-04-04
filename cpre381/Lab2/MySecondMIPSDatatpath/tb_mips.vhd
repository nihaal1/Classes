library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_mips is
  generic(N : integer := 32;
	  M : integer := 5;
	  DATA_WIDTH : natural := 32;
	  ADDR_WIDTH : natural := 10;
  	  gCLK_HPER   : time := 10 ns);

end tb_mips;

architecture mixed of tb_mips is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component mips is
  generic(N : integer := 32;
	  M : integer := 5;
	  DATA_WIDTH : natural := 32;
	  ADDR_WIDTH : natural := 10); 


  port (rs_in    : in std_logic_vector(4 downto 0);   -- select line 1 [rs]
        rt_in    : in std_logic_vector(4 downto 0);   -- select line 2 [rt]
        rd    : in std_logic_vector(4 downto 0);      -- destination register
        wrEn    : in std_logic;                     
        	
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
end component;


        signal rs_in    :  std_logic_vector(4 downto 0);   -- select line 1 [rs]
        signal rt_in    :  std_logic_vector(4 downto 0);   -- select line 2 [rt]
        signal rd       :  std_logic_vector(4 downto 0);
        signal wrEn     :  std_logic;  -- write enabler 
        
        --signal En	:  std_logic;	 		      -- enabler for the register
        signal i_CLK    :  std_logic;   		      -- Clock
        signal i_RST    :  std_logic;                       -- Reset
 
   	signal imm      :  std_logic_vector(15 downto 0);       -- extender input
	signal immSel   :  std_logic;                           -- select line for the MUX 
	signal immExt   :  std_logic;
	signal mem2reg  :  std_logic;

	signal nAdd_Sub :  std_logic;                         -- select line for the ALU 
	signal we :  std_logic; 
        signal Data_Out :  std_logic_vector(N-1 downto 0);

begin

  mips_d: mips
 generic map(N => N, M => M)
  port map(
            rs_in      => rs_in,
            rt_in      => rt_in,
            rd   => rd,
            wrEn      => wrEn,

            --En        => En,
            i_CLK     => i_CLK,
            i_RST     => i_RST,

            imm   => imm,
            immSel    => immSel,
            immExt  => immExt,
            mem2reg  => mem2reg,

	    we        => we,
            nAdd_Sub  => nAdd_Sub,
            Data_Out   => Data_Out);


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
	we         <= '0';
	wait for  gCLK_HPER;
	
    i_RST   <= '1';
    wait for gCLK_HPER;
    i_RST   <= '0';

			--Test Cases from lab doc   --we only for sw

		-- addi $25, $0 , 0

    wrEn   <= '1';  --write enabler
    rd     <= "11001";
    rs_in   <= "00000";  
    rt_in   <= "-----"; 

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '0';            

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;


		-- addi $26, $0 , 256

    wrEn   <= '1';  --write enabler
    rd     <= "11010";
    rs_in   <= "00000";  
    rt_in   <= "-----"; 

    imm   <= x"0100";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '0'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;



		-- lw $1 ,0($25)

    wrEn   <= '1';  --write enabler
    rd     <= "00001";
    rs_in   <= "11001";  
    rt_in   <= "-----"; 

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1';   			-- is this correct?

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;


		-- lw $2, 4($25)

    wrEn   <= '1';  --write enabler
    rd     <= "00010";
    rs_in   <= "11001";  
    rt_in   <= "-----"; 

    imm   <= x"0001";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;

		-- add $1, $1, $2

    wrEn   <= '1';  --write enabler
    rd     <= "00001";
    rs_in   <= "00001";  
    rt_in   <= "00010"; 

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '0'; 
    mem2reg   <= '0'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;


		-- sw $1, 0($26)

    we         <= '1';   --for store write enabler for the memory is set to 1
    wrEn   <= '0';  --write enabler for reg --don't alter reg file
    rd     <= "-----";
    rs_in   <= "11010";  
    rt_in   <= "00001"; -- is this correct? rs, and rt??

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '1';    -- is this right? should mux not select????
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    --we         <= '1';   --for store write enabler for the memory is set to 1

    wait for cCLK_PER;
    wait for cCLK_PER;

		-- lw $2, 8($25) 

    wrEn   <= '1';  --write enabler
    rd     <= "00010";
    rs_in   <= "11001";  
    rt_in   <= "-----"; 

    imm   <= x"0002";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;

 --------------------------------------------------- DO 

		-- add $1, $1, $2

    wrEn   <= '1';  --write enabler
    rd     <= "00001";
    rs_in   <= "00001";  
    rt_in   <= "00010"; 

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '0';        -- no extension
    mem2reg   <= '0'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;

		-- sw $1, 4($26)

    wrEn   <= '0';  --write enabler for reg --don't alter reg file
    rd     <= "-----";
    rs_in   <= "11010";  
    rt_in   <= "00001"; 

    imm   <= x"0001";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '1';   --for store write enabler for the memory is set to 1

    wait for cCLK_PER;
    wait for cCLK_PER;

		-- lw $2, 12($25)

    wrEn   <= '1';  --write enabler register
    rd     <= "00010";
    rs_in   <= "11001";  
    rt_in   <= "-----"; 

    imm   <= x"0003";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '0'; --write enabler memory

    wait for cCLK_PER;


		-- add $1, $1, $2

    wrEn   <= '1';  --write enabler
    rd     <= "00001";
    rs_in   <= "00001";  
    rt_in   <= "00010"; 

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '0';        -- no extension
    mem2reg   <= '0'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;


		-- sw $1, 8($26)

    we         <= '1';   --for store write enabler for the memory is set to 1
    wrEn   <= '0';  --write enabler for reg --don't alter reg file
    rd     <= "-----";
    rs_in   <= "11010";  
    rt_in   <= "00001"; 

    imm   <= x"0002";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
   

    wait for cCLK_PER;
    wait for cCLK_PER;

		-- lw $2, 16($25)

    wrEn   <= '1';  --write enabler register
    rd     <= "00010";
    rs_in   <= "11001";  
    rt_in   <= "-----"; 

    imm   <= x"0004";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '0'; --write enabler memory

    wait for cCLK_PER;

		-- add $1, $1, $2

    wrEn   <= '1';  --write enabler
    rd     <= "00001";
    rs_in   <= "00001";  
    rt_in   <= "00010"; 

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '0';        -- no extension
    mem2reg   <= '0'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;


		-- sw $1, 12($26)

    wrEn   <= '0';  --write enabler for reg --don't alter reg file
    rd     <= "-----";
    rs_in   <= "11010";  
    rt_in   <= "00001"; 

    imm   <= x"0003";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '1';   --for store write enabler for the memory is set to 1

    wait for cCLK_PER;
    wait for cCLK_PER;

		-- lw $2, 20($25)

    wrEn   <= '1';  --write enabler register
    rd     <= "00010";
    rs_in   <= "11001";  
    rt_in   <= "-----"; 

    imm   <= x"0005";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '0'; --write enabler memory

    wait for cCLK_PER;

		-- add $1, $1, $2

    wrEn   <= '1';  --write enabler
    rd     <= "00001";
    rs_in   <= "00001";  
    rt_in   <= "00010"; 

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '0';        -- no extension
    mem2reg   <= '0'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;

		-- sw $1, 16($26)

    wrEn   <= '0';  --write enabler for reg --don't alter reg file
    rd     <= "-----";
    rs_in   <= "11010";  
    rt_in   <= "00001"; 

    imm   <= x"0004";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '1';   --for store write enabler for the memory is set to 1

    wait for cCLK_PER;
    wait for cCLK_PER;

		-- lw $2, 24($25)

    wrEn   <= '1';  --write enabler register
    rd     <= "00010";
    rs_in   <= "11001";  
    rt_in   <= "-----"; 

    imm   <= x"0006";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '0'; 
    we         <= '0'; --write enabler memory

    wait for cCLK_PER;

		-- add $1, $1, $2

    wrEn   <= '1';  --write enabler
    rd     <= "00001";
    rs_in   <= "00001";  
    rt_in   <= "00010"; 

    imm   <= x"0000";   
    immExt   <= '1';  
    immSel   <= '0';        -- no extension
    mem2reg   <= '0'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;

		-- addi $27, $0 , 512

    wrEn   <= '1';  --write enabler
    rd     <= "11011";
    rs_in   <= "00000";  
    rt_in   <= "-----"; 

    imm   <= x"0200";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '0'; 

    nAdd_Sub   <= '0'; 
    we         <= '0';

    wait for cCLK_PER;


		-- sw $1, -4($27)

    wrEn   <= '0';  --write enabler for reg --don't alter reg file
    rd     <= "-----";
    rs_in   <= "11011";  
    rt_in   <= "00001"; 

    imm   <= x"0001";   
    immExt   <= '1';  
    immSel   <= '1'; 
    mem2reg   <= '1'; 

    nAdd_Sub   <= '1'; 
    we         <= '1';   --for store write enabler for the memory is set to 1
   
 wait for cCLK_PER;
    wait; 

  end process;

end mixed;













