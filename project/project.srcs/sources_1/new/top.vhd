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
           BTND : in STD_LOGIC;  --pause/unpause
           BTNL : in STD_LOGIC;  
           BTNR : in STD_LOGIC);
end top;


architecture behavioral of top is

    signal digit_0  : std_logic_vector(4 - 1 downto 0);
    signal digit_1  : std_logic_vector(4 - 1 downto 0);
    signal digit_2  : std_logic_vector(4 - 1 downto 0);
    signal digit_3  : std_logic_vector(4 - 1 downto 0); 

begin
  
  driver_7seg_4digits : entity work.driver_7seg_4digits_alt
    port map ( clk     => CLK100MHZ,
               rst     => BTNC,
               data0   => digit_0,
               data1   => digit_1,
               data2   => digit_2,
               data3   => digit_3,           
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
            BTNC_d      => BTNC,
            BTNU        => BTNU,        
            BTND	    => BTND,
            BTNL	    => BTNL,
            BTNR	    => BTNR,
            set_SW 	    => SW(0), 
            train_SW 	=> SW(15),
            break_SW 	=> SW(14),
            reps_SW 	=> SW(13),
    
            digit_0		=> digit_0,
            digit_1	 	=> digit_1,
            digit_2 	=> digit_2,
            digit_3 	=> digit_3 
    );
    
AN(7 downto 4) <= b"1111";

end architecture behavioral;