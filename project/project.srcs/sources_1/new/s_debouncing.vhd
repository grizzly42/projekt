library ieee;
use ieee.std_logic_1164.all;

entity s_debouncing is
  
  Port(
    clk     : in  std_logic;  
    rst	    : in  std_logic;  
    button  : in  std_logic;
    result  : out std_logic); 
end s_debouncing;

architecture Behavioral of s_debouncing is

signal sig_en 		: std_logic;

begin
    
clk_enable : entity work.clk_en_db
      generic map (
            g_MAX => 5    -- sim 5, board 12000000
      )        
      port map (
          clk => clk,
          rst => rst,
          ce   => sig_en
      );
    
    p_s_debouncing : process (clk, rst) is
    begin
        if rising_edge(clk) then
           	if (rst = '1') then
               	result <= '0';
           	elsif (button = '1' and sig_en = '1') then
           		result <= '1';
            else
            	result <= '0';
       		end if;
        end if;
    end process p_s_debouncing;
end architecture Behavioral;
