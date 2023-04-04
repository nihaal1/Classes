library IEEE;
use IEEE.std_logic_1164.all;

entity pc is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output

end pc;

architecture mixed of pc is

begin

  -- The output of the FF is fixed to s_Q
  --o_Q <= s_Q;
  
  -- Create a multiplexed input to the FF based on i_WE
  --with i_WE select
  --  s_D <= i_D when '1',
  --         s_Q when others;
  
  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize
  -- glitchy behavior on startup.
  process (i_CLK, i_RST)
  begin
    if (i_RST = '1') then
      o_Q <= x"00400000"; -- Use "(others => '0')" for N-bit values
    elsif (rising_edge(i_CLK)) then
      if (i_WE = '1') then
         o_Q <= i_D;
      else
        o_Q <= o_Q;
      end if;
    end if;

  end process;
  
end mixed;


-- Asynchronous reset means we choose when the clock resets as in this case
-- Also it is rising edge as specified in the else if statement

