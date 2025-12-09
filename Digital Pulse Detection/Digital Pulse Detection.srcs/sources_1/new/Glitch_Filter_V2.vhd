library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Glitch_Filter_V2 is
  port (
    Clk , Pulse_In , Glitch_Filter_En : in std_logic;
    Threshold_Short : in std_logic_vector (7 downto 0);
    Pulse_Filtered: out std_logic
  );
end Glitch_Filter_V2;

architecture rtl of glitch_filter_v2 is
  signal out_reg : std_logic := '0';   
  signal count , treshold , test : unsigned(7 downto 0) := (others => '0');  
begin

  process(clk)
 
  begin
    if rising_edge(clk) then
    if Glitch_Filter_En = '1' then    
        if Pulse_In = '1' then
            count <= count + 1;
            if count >= unsigned(Threshold_Short) then 
                out_reg <= '1';
            end if;
        else
            if treshold = 0 and count = 0 then
                treshold <= (others => '0');
            elsif count >= unsigned(Threshold_Short) then
                treshold <= unsigned(Threshold_Short) - 1; 
            end if;
            count <= (others => '0');
        end if;
        if treshold /= 0 then
            out_reg <= '1';
            treshold <= treshold - 1;
        elsif treshold = 0 and count < unsigned(Threshold_Short) then 
            out_reg <= '0';
        end if;
    else
        out_reg <= Pulse_In;    
    end if;
    
    end if;
  end process;

  Pulse_Filtered <= out_reg;

end architecture;
