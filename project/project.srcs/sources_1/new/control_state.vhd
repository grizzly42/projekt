library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ctrl_state is
  port (
    clk   		: in    std_logic;                    
    rst   		: in    std_logic;
    --BTNU		: in    std_logic;       --pro debounce po uspesne simulaci simulaci
    --BTND		: in    std_logic;
    --BTNL		: in    std_logic;
    --BTNR		: in    std_logic;
    BTNC_d		: in    std_logic;
    BTNU_d		: in    std_logic;
    BTND_d		: in    std_logic;
    BTNL_d		: in    std_logic;
    BTNR_d		: in    std_logic;
    set_SW 		: in    std_logic; 
    train_SW 	: in    std_logic;
    break_SW 	: in    std_logic;
    reps_SW 	: in    std_logic;
    
    digit_0		: out    std_logic_vector(4 - 1 downto 0);
    digit_1	 	: out    std_logic_vector(4 - 1 downto 0);
    digit_2 	: out    std_logic_vector(4 - 1 downto 0);
    digit_3 	: out    std_logic_vector(4 - 1 downto 0)    -- 7 bit vektor pro zobrazeni pismena oznaceni stavu
    );
end entity ctrl_state;


architecture behavioral of ctrl_state is

  type t_state is (
    SET,
    GO,
    PAUSE,
    TRAIN,
    BREAK
    ); 

  signal sig_state		: t_state;
  signal sig_en 		: std_logic;
  
  signal sig_cnt 		: unsigned(4 downto 0);  -- navic, zbytecne
  
  --signal BTNU_d	    : std_logic;    -- signaly pro uz debouncenute buttons
  --signal BTNC_d	    : std_logic;
  --signal BTND_d	    : std_logic;
  --signal BTNL_d	    : std_logic;
  --signal BTNR_d	    : std_logic;
  
  signal sig_num_reps		: unsigned(4 - 1 downto 0);  -- aktualni pocet opakovani/reps
  signal sig_reps_set 		: unsigned(4 - 1 downto 0);  -- nastaveny pocet opakovani/reps
  signal sig_train_set		: unsigned(4 - 1 downto 0);  -- nastavena delka train
  signal sig_break_set 		: unsigned(4 - 1 downto 0);  -- nasatvena delka breaku
  signal sig_last_state 	: t_state;                   -- posledni stav pro prepinani z PAUSE
  
  signal sig_seconds_l     : std_logic_vector(4 - 1 downto 0);
  signal sig_seconds_h     : std_logic_vector(4 - 1 downto 0);
  signal sig_minutes_l     : std_logic_vector(4 - 1 downto 0);
  signal sig_stopwatch_cnt : std_logic_vector(4 - 1 downto 0);  -- delka odpocitavani passovana do stopwatche
  signal sig_set_enable    : std_logic;
  signal sig_end           : std_logic;
  signal sig_start         : std_logic;
  signal sig_pause         : std_logic;

  constant c_SET   		: std_logic_vector(4 - 1 downto 0) := b"1011"; -- sedmisegmentove hodnoty pro pismena stavu
  constant c_GO     	: std_logic_vector(4 - 1 downto 0) := b"1100"; 
  constant c_PAUSE  	: std_logic_vector(4 - 1 downto 0) := b"1101";
  constant c_TRAIN  	: std_logic_vector(4 - 1 downto 0) := b"1110";
  constant c_BREAK  	: std_logic_vector(4 - 1 downto 0) := b"1111";

begin

  clk_en0 : entity work.clock_enable
    generic map (
      -- 250 ms
      g_MAX => 1
      
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en
    );

  stopwatch : entity work.stopwatch_new
    port map (
      clk => clk,
      rst => rst,
      start_i => sig_start,
      pause_i => sig_pause,
      seconds_h_o => sig_seconds_h,
      seconds_l_o => sig_seconds_l,
      minutes_l_o => sig_minutes_l,
      min_set => sig_stopwatch_cnt,
      set_enable => sig_set_enable,
      cnt_end => sig_end
    );

  --s_db_U : entity work.s_debouncing
  --  port map (
  --    clk     => clk,
  --    rst     => rst,
  --    button  => BTNU,
  --    result  => BTNU_d
  --  );
    
  --s_db_C : entity work.s_debouncing
    --port map (
      --clk     => clk,
      --rst     => rst,
      --button  => BTNC,
      --result  => BTNC_d
    --);
    
  --s_db_D : entity work.s_debouncing
  --  port map (
  --    clk     => clk,
  --    rst     => rst,
  --    button  => BTND,
  --    result  => BTND_d
  --  );
    
  --s_db_L : entity work.s_debouncing
  --  port map (
  --    clk     => clk,
  --    rst     => rst,
  --    button  => BTNL,
  --    result  => BTNL_d
  --  );
  
  --s_db_R : entity work.s_debouncing
  --  port map (
  --    clk     => clk,
  --    rst     => rst,
  --    button  => BTNR,
  --    result  => BTNR_d
  --  );
  
    
--000
  p_ctrl : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then                  
        sig_state <= GO;              		
        sig_cnt   <= (others => '0');
        
        sig_reps_set  <= "0010";
        sig_train_set <= "0010";
        sig_break_set <= "0001";
        sig_num_reps  <= "0000";
               
      elsif (sig_en = '1') then
        case sig_state is

          when GO =>
            sig_pause <= '0';
            if (set_SW = '1') then
            	sig_state <= SET; -- prechod na nastaveni (SET)
            elsif (BTNU_d = '1') then
                sig_set_enable <= '1';
            	sig_stopwatch_cnt <= std_logic_vector(sig_train_set);  -- nastaveni odpocitavani na delku train
            	--sig_start <= '1';                  -- zacatek odpoctu stopwatch
            	--sig_pause <= '0';   
            	sig_last_state <= sig_state;              
            	sig_state <= TRAIN;                -- prechod na stav TRAIN
            else 
            	sig_state <= GO;
            end if;

		  when SET =>
            if (train_SW = '1' and break_SW = '0' and reps_SW = '0') then   -- pouze kdyz je v HIGH jenom train switch
                if (BTNR_d = '1') then
                    sig_train_set <= sig_train_set + 1;            -- inkrementace po jedne minute
                elsif (BTNL_d = '1' and sig_train_set /= 0) then   -- pokud se nerovna nule, je mozna i dekrementace
                	sig_train_set <= sig_train_set - 1;
                else
                	sig_state <= SET;
				end if;
                
            elsif (train_SW = '0' and break_SW = '1' and reps_SW = '0') then
            	if (BTNR_d = '1') then
                    sig_break_set <= sig_break_set + 1;
                elsif (BTNL_d = '1' and sig_break_set /= 0) then
                	sig_break_set <= sig_break_set - 1;
                else
                	sig_state <= SET;
				end if;
                
            elsif (train_SW = '0' and break_SW = '0' and reps_SW = '1') then
            	if (BTNR_d = '1') then
                    sig_reps_set <= sig_reps_set + 1;
                elsif (BTNL_d = '1' and sig_reps_set /= 0) then
                	sig_reps_set <= sig_reps_set - 1;
                else
                	sig_state <= SET;
				end if;
            elsif (set_SW = '0') then     -- vraceni zpatky na GO
            	sig_state <= GO;
            else 
            	sig_state <= SET;
            end if;
            
          when TRAIN =>
            
            if sig_set_enable = '1' and sig_stopwatch_cnt = std_logic_vector(sig_train_set) then
                sig_set_enable <= '0';
                sig_start <= '1';                  -- zacatek odpoctu stopwatch
            	sig_pause <= '0';
            elsif sig_end = '1' then
                sig_stopwatch_cnt <= std_logic_vector(sig_break_set);
            elsif sig_last_state = GO and sig_set_enable = '0' then
                sig_stopwatch_cnt <= std_logic_vector(sig_break_set);
            end if;
            if (BTND_d = '1') then        -- prechod na pauzu
                sig_last_state <= sig_state;
                sig_start <= '0';
                sig_pause <= '1';
                sig_state <= PAUSE;
                
            elsif (sig_seconds_l = "0000" and sig_seconds_h = "0000" and sig_minutes_l = "0000" and sig_end = '1') then   -- konec odpoctu     
            --elsif sig_end = '1' then
                if (sig_num_reps = sig_reps_set or sig_reps_set = "0001") then   -- po dokonceni vsech reps prejde zpet do GO
            	   sig_num_reps <= "0000";
            	   sig_start <= '0';
            	   sig_pause <= '1';
            	   sig_state <= GO;
            	--elsif sig_stopwatch_cnt = std_logic_vector(sig_train_set) then
            	   --sig_stopwatch_cnt <= std_logic_vector(sig_break_set);
            	else
            	   sig_num_reps <= sig_num_reps + 1;
            	   sig_stopwatch_cnt <= std_logic_vector(sig_break_set);
            	   sig_set_enable <= '1';
            	   sig_last_state <= sig_state;
                   sig_state <= BREAK;                   -- prechod na BREAK
            	end if;
            end if;
            
          when BREAK =>
            if sig_set_enable = '1' and sig_stopwatch_cnt = std_logic_vector(sig_break_set) then
                sig_start <= '1';                  -- zacatek odpoctu stopwatch
            	sig_pause <= '0';
            	sig_set_enable <= '0';
            elsif sig_end = '1' and sig_set_enable = '0' then
                sig_stopwatch_cnt <= std_logic_vector(sig_train_set);
            end if;
            	
            if (BTND_d = '1') then
                sig_last_state <= sig_state;   -- ulozeni posledniho stavu
                sig_start <= '0';
                sig_pause <= '1';
                sig_state <= PAUSE;            -- prechod na pauzu
                
            elsif (sig_seconds_l = "0000" and sig_seconds_h = "0000" and sig_minutes_l = "0000" and sig_end = '1') then -- konec odpoctu a prechod na TRAIN
            --elsif sig_end = '1' then
                --if sig_stopwatch_cnt = std_logic_vector(sig_train_set) then
            	   --sig_stopwatch_cnt <= std_logic_vector(sig_break_set);
            	--else
            	   sig_set_enable <= '1';
            	   sig_stopwatch_cnt <= std_logic_vector(sig_train_set);
            	   --sig_start <= '1';                  -- zacatek odpoctu stopwatch
            	   --sig_pause <= '0';
            	   sig_last_state <= sig_state;
                   sig_state <= TRAIN;
                --end if;
            end if;

          when PAUSE =>
            if (BTND_d = '1') then
                sig_pause <= '0';
                sig_start <= '1';
                sig_state <= sig_last_state;   -- prechod z pauzy do posledniho stavu
            end if;

          when others =>
            sig_state <= GO;
            sig_cnt   <= (others => '0');

        end case;
      end if; 
      if sig_last_state = GO and sig_end = '1' then
          sig_stopwatch_cnt <= std_logic_vector(sig_train_set);
      elsif sig_last_state = BREAK and sig_end = '1' then
          sig_stopwatch_cnt <= std_logic_vector(sig_train_set);
      elsif sig_last_state = TRAIN and sig_end = '1' then
          sig_stopwatch_cnt <= std_logic_vector(sig_break_set);
      end if;
    end if; 
  end process p_ctrl;


  p_output_fsm : process (clk, sig_state) is
  begin
    if (rising_edge(clk)) then
    case sig_state is
      when GO =>
        digit_0 <= sig_seconds_l;
        digit_1 <= sig_seconds_h;
        digit_2 <= sig_minutes_l;
        digit_3 <= c_GO;
        
      when SET =>   -- dodelat zobrazeni nastavovanych hodnot    000000000000000
        digit_0 <= sig_seconds_l;
        digit_1 <= sig_seconds_h;
        digit_2 <= sig_minutes_l;
        digit_3 <= c_SET;
        
      when TRAIN =>
        digit_0 <= sig_seconds_l;
        digit_1 <= sig_seconds_h;
        digit_2 <= sig_minutes_l;
        digit_3 <= c_TRAIN;
        
      when BREAK =>
        digit_0 <= sig_seconds_l;
        digit_1 <= sig_seconds_h;
        digit_2 <= sig_minutes_l;
        digit_3 <= c_BREAK;
        
      when PAUSE =>
        digit_0 <= sig_seconds_l;
        digit_1 <= sig_seconds_h;
        digit_2 <= sig_minutes_l;
        digit_3 <= c_PAUSE;
        
    end case;
    end if;
  end process p_output_fsm;

end architecture behavioral;
