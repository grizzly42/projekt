
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity hex_7seg is
    Port ( hex : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           blank : in STD_LOGIC);
end hex_7seg;

architecture Behavioral of hex_7seg is

begin
  

  p_7seg_decoder : process (blank, hex) is

  begin

    if (blank = '1') then
      seg <= "1111111";     -- Blanking display
    else

      case hex is

        when "0000" =>

          seg <= "0000001"; -- 0

        when "0001" =>

          seg <= "1001111"; -- 1
          
        when "0010" =>

          seg <= "0010010"; -- 2

        when "0011" =>

          seg <= "0000110"; -- 3

        when "0100" =>

          seg <= "1001100"; -- 4
          
        when "0101" =>

          seg <= "0100100"; -- 5
          
        when "0110" =>

          seg <= "0100000"; -- 6

        when "0111" =>

          seg <= "0001111"; -- 7

        when "1000" =>

          seg <= "0000000"; -- 8
        
        when "1001" =>

          seg <= "0001100"; -- 9
        
        when "1010" =>

          seg <= "0001000"; -- A
         
        when "1011" =>

          seg <= "0010010"; -- b
        
        when "1100" =>

          seg <= "0000000"; -- C
        
        when "1101" =>

          seg <= "0011000"; -- d

        when "1110" =>

          seg <= "1110000"; -- E

        when others =>

          seg <= "1100000"; -- F

      end case;

    end if;
  end process p_7seg_decoder;

end Behavioral;
