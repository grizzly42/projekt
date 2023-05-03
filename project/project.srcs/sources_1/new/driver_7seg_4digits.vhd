----------------------------------------------------------
--
--! @title Driver for 4-digit 7-segment display
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2020 Tomas Fryza
--! This work is licensed under the terms of the MIT license
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

----------------------------------------------------------
-- Entity declaration for display driver
--
--             +-------------------+
--        -----|> clk              |
--        -----| rst            dp |-----
--             |          seg(6:0) |--/--
--        --/--| data0(3:0)        |  7
--        --/--| data1(3:0)        |
--        --/--| data2(3:0)        |
--        --/--| data3(3:0)        |
--          4  |           dig(3:0)|--/--
--        --/--| dp_vect(3:0)      |  4
--          4  +-------------------+
--
-- Inputs:
--   clk          -- Main clock
--   rst          -- Synchronous reset
--   dataX(3:0)   -- Data values for individual digits
--   dp_vect(3:0) -- Decimal points for individual digits
--
-- Outputs:
--   dp:          -- Decimal point for specific digit
--   seg(6:0)     -- Cathode values for individual segments
--   dig(3:0)     -- Common anode signals to individual digits
--
----------------------------------------------------------

entity driver_7seg_4digits is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;
    data0   : out    std_logic_vector(4-1 downto 0);
    data1   : out   std_logic_vector(3-1 downto 0);
    data2   : out    std_logic_vector(4-1 downto 0);
    dp_vect : in    std_logic_vector(3 downto 0);
    dp      : out   std_logic;
    seg     : out   std_logic_vector(6 downto 0);
    dig     : out   std_logic_vector(3 downto 0);
    --BTNU    : out   std_logic
  );
end entity driver_7seg_4digits;

----------------------------------------------------------
-- Architecture declaration for display driver
----------------------------------------------------------

architecture behavioral of driver_7seg_4digits is

  -- Internal clock enable
  signal sig_en_4ms : std_logic;

  -- Internal 2-bit counter for multiplexing 4 digits
  signal sig_cnt_2bit : std_logic_vector(1 downto 0);

  -- Internal 4-bit value for 7-segment decoder
  signal sig_hex : std_logic_vector(3 downto 0);

begin

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity generates
  -- an enable pulse every 4 ms
  --------------------------------------------------------
  

  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity performs
  -- a 2-bit down counter
  --------------------------------------------------------
  stopwatch_seconds : entity work.stopwatch_seconds
    
    port map (
        clk  => clk,
        rst  => rst,
        start_i  => BTNU,
        pause_i => BTNU,
        -- Tens of seconds
        seconds_h_o  => data0,
        -- Seconds
        seconds_l_o  => data1,
        -- Tenths of seconds
        minutes_l_o => data2
       -- secstart : out std_logic_vector(3 downto 0)
    );

  --------------------------------------------------------
  -- Instance (copy) of hex_7seg entity performs
  -- a 7-segment display decoder
  --------------------------------------------------------
  hex2seg : entity work.hex_7seg
    port map (
      blank => rst,
      hex   => sig_hex,
      seg   => seg
    );

  --------------------------------------------------------
  -- p_mux:
  -- A sequential process that implements a multiplexer for
  -- selecting data for a single digit, a decimal point,
  -- and switches the common anodes of each display.
  --------------------------------------------------------
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