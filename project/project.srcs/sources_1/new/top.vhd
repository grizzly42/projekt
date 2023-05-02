----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 01:54:49 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC;  --reset
           BTNU : in STD_LOGIC;  --start
           BTND : in STD_LOGIC;  --pause
           BTNL : in STD_LOGIC;  
           BTNR : in STD_LOGIC);
           --digit_0   : buffer    std_logic_vector(4-1 downto 0);
           --digit_1   : buffer    std_logic_vector(3-1 downto 0);
           --digit_2   : buffer    std_logic_vector(4-1 downto 0);
           --digit_3   : buffer    std_logic_vector(4-1 downto 0));
end top;

----------------------------------------------------------
-- Architecture body for top level
----------------------------------------------------------

architecture behavioral of top is

    signal s_seconds_l  : std_logic_vector(4 - 1 downto 0);  -- minutes
    signal s_seconds_h  : std_logic_vector(4 - 1 downto 0);  -- tens of Seconds
    signal s_minutes_l  : std_logic_vector(4 - 1 downto 0);
    signal s_digit      : std_logic_vector(4 - 1 downto 0); 

begin
  --------------------------------------------------------
  -- Instance (copy) of tlc entity
  --------------------------------------------------------
  driver_7seg_4digits : entity work.driver_7seg_4digits_alt
    port map ( clk     => CLK100MHZ,
               rst     => BTNC,
               data0   => s_seconds_l,
               data1   => s_seconds_h,
               data2   => s_minutes_l,
               data3   => s_digit,           
               seg(6) => CA,
               seg(5) => CB,
               seg(4) => CC,
               seg(3) => CD,
               seg(2) => CE,
               seg(1) => CF,
               seg(0) => CG,
               dp_vect => "1011",
               dp      => DP,
               dig(3 downto 0) => AN(3 downto 0)
    );
    
    ctrl_state : entity work.ctrl_state
    port map ( 
            clk         => CLK100MHZ,                    
            rst         => BTNC,
            BTNU_d      => BTNU,       --pro debounce po uspesne simulaci simulaci   
            BTND_d	    => BTND,
            BTNL_d	    => BTNL,
            BTNR_d	    => BTNR,
            set_SW 	    => SW(0), 
            train_SW 	=> SW(15),
            break_SW 	=> SW(14),
            reps_SW 	=> SW(13),
    
            digit_0		=> s_seconds_l,
            digit_1	 	=> s_seconds_h,
            digit_2 	=> s_minutes_l,
            digit_3 	=> s_digit 
    );
    
AN(7 downto 4) <= b"1111";

end architecture behavioral;