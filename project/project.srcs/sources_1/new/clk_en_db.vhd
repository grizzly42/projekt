library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; -- Package for arithmetic operations

entity clk_en_db is
  generic (
    g_MAX : natural := 11_000_000
  );                       
  port (
    clk : in    std_logic; --! Main clock
    rst : in    std_logic; --! High-active synchronous reset
    ce  : out   std_logic  --! Clock enable pulse signal
  );
end entity clk_en_db;



architecture behavioral of clk_en_db is

  signal sig_cnt : natural;

begin

  p_clk_en_db : process (clk) is
  begin

    if rising_edge(clk) then             
      if (rst = '1') then                 
        sig_cnt <= 0;                    
        ce      <= '0';                  
      elsif (sig_cnt >= (g_MAX - 1)) then
        sig_cnt <= 0;                     
        ce      <= '1';                   
      else
        sig_cnt <= sig_cnt + 1;
        ce      <= '0';
      end if;
    end if;

  end process p_clk_en_db;

end architecture behavioral;