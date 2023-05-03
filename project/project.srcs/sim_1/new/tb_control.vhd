library ieee;
  use ieee.std_logic_1164.all;


entity tb_control is
  
end entity tb_control;


architecture testbench of tb_control is

  -- Local constants
  constant c_CLK_100MHZ_PERIOD : time := 10 ns;

  -- Local signals
  signal sig_clk_100mhz     : std_logic;
  signal sig_rst            : std_logic;
  signal sig_BTNU_d         : std_logic;
  signal sig_BTNC_d         : std_logic;
  signal sig_BTND_d         : std_logic;
  signal sig_BTNL_d         : std_logic;
  signal sig_BTNR_d         : std_logic;
  signal sig_set_SW         : std_logic;
  signal sig_train_SW       : std_logic;
  signal sig_break_SW       : std_logic;
  signal sig_reps_SW        : std_logic;
  signal sig_digit_0          : std_logic_vector(4 - 1 downto 0);
  signal sig_digit_1          : std_logic_vector(4 - 1 downto 0);
  signal sig_digit_2          : std_logic_vector(4 - 1 downto 0);
  signal sig_digit_3          : std_logic_vector(4 - 1 downto 0);

begin

  -- Connecting testbench signals with tlc entity
  -- (Unit Under Test)
  uut_ctrl_state : entity work.ctrl_state
    port map (
      clk      => sig_clk_100mhz,
      rst      => sig_rst,
      BTNU   => sig_BTNU_d,
      BTNC_d   => sig_BTNC_d,
      BTND     => sig_BTND_d,
      BTNL   => sig_BTNL_d,
      BTNR   => sig_BTNR_d,
      set_SW   => sig_set_SW,
      train_SW => sig_train_SW,
      break_SW => sig_break_SW,
      reps_SW  => sig_reps_SW,
      digit_0  => sig_digit_0,
      digit_1  => sig_digit_1,
      digit_2  => sig_digit_2,
      digit_3  => sig_digit_3
    );


  --------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------
  p_clk_gen : process is
  begin

    while now < 30000 ns loop -- 10 usec of simulation

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;

    wait;

  end process p_clk_gen;

  --------------------------------------------------------
  -- Reset generation process
  --------------------------------------------------------
  p_reset_gen : process is
  begin

    sig_rst <= '0';
    wait for 50 ns;

    -- Reset activated
    sig_rst <= '1';
    wait for 50 ns;

    -- Reset deactivated
    sig_rst <= '0';
    wait;

  end process p_reset_gen;

  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";
    
    
    sig_set_SW <= '1';
    sig_train_SW <= '1';
    wait for 200 ns;
    
    sig_set_SW <= '1';
    sig_train_SW <= '1';
    
    sig_BTNR_d <= '1';
    wait for 400 ns;
    sig_BTNR_d <= '0';
    wait for 15 ns;
    
    sig_train_SW <= '0';
    sig_set_SW <= '0';
    wait for 50 ns;
    
    
    --sig_BTNR_d <= '1';
    --wait for 50 ns;
    --sig_BTNR_d <= '0';
    --sig_train_SW <= '0';
    --sig_break_SW <= '1';
    --wait for 50 ns;
    
    --sig_BTNR_d <= '1';
    --wait for 50 ns;
    --sig_BTNR_d <= '0';
    --sig_break_SW <= '0';
    --sig_reps_SW <= '1';
    --wait for 50 ns;
    
    --sig_BTNR_d <= '1';
    --wait for 50 ns;
    --sig_BTNR_d <= '0';
    --sig_reps_SW <= '0';
    --sig_set_SW <= '0';
    --wait for 50 ns;
    
    sig_BTNU_d <= '1';
    wait for 50 ns;
    sig_BTNU_d <= '0';
    
    
    wait for 500 ns;
    sig_BTND_d <= '1';
    wait for 50 ns;
    sig_BTND_d <= '0';
    wait for 50 ns;
    sig_BTND_d <= '1';
    wait for 50 ns;
    sig_BTND_d <= '0';
    
    report "Stimulus process finished";
    wait;

  end process p_stimulus;

end architecture testbench;