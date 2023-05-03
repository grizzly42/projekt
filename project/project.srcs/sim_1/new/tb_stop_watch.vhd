------------------------------------------------------------------------
--
-- One-minute stopwatch testbench.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_stopwatch_seconds is
    -- Entity of testbench is always empty
end entity tb_stopwatch_seconds;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_stopwatch_seconds is

    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz   : std_logic;
    signal s_reset        : std_logic;
    signal s_start        : std_logic;
    signal s_pause        : std_logic;
    signal s_seconds_h    : std_logic_vector(4 - 1 downto 0);
    signal s_seconds_l    : std_logic_vector(4 - 1 downto 0);
    signal s_minutes_l    : std_logic_vector(4 - 1 downto 0);
    signal s_min_set      : std_logic_vector(4 - 1 downto 0);
    signal sig_set_enable : std_logic;

begin
    -- Connecting testbench signals with stopwatch_seconds entity
    -- (Unit Under Test)
    uut_stopwatch : entity work.stopwatch_new
        port map(
            clk            => s_clk_100MHz,
            rst            => s_reset,
            start_i        => s_start,
            pause_i        => s_pause,
            seconds_h_o    => s_seconds_h,
            seconds_l_o    => s_seconds_l,          
            minutes_l_o    => s_minutes_l,
            min_set        => s_min_set,
            set_enable     => sig_set_enable
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 100000 ns loop  -- 100 usec of simulation
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 20 ns;
        s_reset <= '1';                 -- Reset activated
        wait for 20 ns;
        s_reset <= '0';
        wait;
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        s_min_set <= "0011";
        s_start  <= '0';
        s_pause  <= '0';
        wait for 50 ns;
        s_start  <= '1';
        wait for 1000 ns;
        s_pause  <= '0';
        wait;
    end process p_stimulus;

end architecture testbench;
