
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity driver_7seg_4digits_alt is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;
    data0   : in    std_logic_vector(3 downto 0);
    data1   : in    std_logic_vector(3 downto 0);
    data2   : in    std_logic_vector(3 downto 0);
    data3   : in    std_logic_vector(3 downto 0);
    dp_vect : in    std_logic_vector(3 downto 0);
    
    dp      : out   std_logic;
    seg     : out   std_logic_vector(6 downto 0);
    dig     : out   std_logic_vector(3 downto 0)
  );
end entity driver_7seg_4digits_alt;


architecture behavioral of driver_7seg_4digits_alt is

  
  signal sig_en_4ms : std_logic;

  
  signal sig_cnt_2bit : std_logic_vector(1 downto 0);

  
  signal sig_hex : std_logic_vector(3 downto 0);

begin


  hex2seg : entity work.hex_7seg
    port map (
      blank => rst,
      hex   => sig_hex,
      seg   => seg
    );

  
  p_mux : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then
        sig_hex <= data0;
        dp      <= dp_vect(0);
        dig     <= "1110";
      else

        case sig_cnt_2bit is

          when "11" =>
            sig_hex <= data3;
            dp      <= dp_vect(3);
            dig     <= "0111";

          when "10" =>
            sig_hex <= data2;
            dp      <= dp_vect(2);
            dig     <= "1011";

          when "01" =>
            sig_hex <= data1;
            dp      <= dp_vect(1);
            dig     <= "1101";

          when others =>
            sig_hex <= data0;
            dp      <= dp_vect(0);
            dig     <= "1110";

        end case;

      end if;
    end if;

  end process p_mux;

end architecture behavioral;