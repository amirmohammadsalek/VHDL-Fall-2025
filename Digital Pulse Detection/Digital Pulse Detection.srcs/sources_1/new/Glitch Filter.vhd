library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Glitch_Filter is
  port (
    Clk , Pulse_In , Glitch_Filter_En : in std_logic;
    Threshold_Short : in std_logic_vector (7 downto 0);
    Pulse_Filtered: out std_logic
  );
end Glitch_Filter;

architecture rtl of glitch_filter is
  signal out_reg : std_logic := '0';   
  --signal cnt , test : unsigned(7 downto 0) := (others => '0');  
begin

  process(clk)
    variable cnt_var  : unsigned(7 downto 0);
    variable test_var : unsigned(7 downto 0);
  begin
    if rising_edge(Clk) then
        if glitch_Filter_En = '1' then
            if Pulse_In = '1' then
                --cnt <= cnt + 1;
                cnt_var := cnt_var + 1;
            else
                if cnt_var > unsigned(Threshold_Short) then
                    out_reg <= '1';
                    --test <= cnt;
                    test_var := cnt_var;
                end if;
                cnt_var := (others => '0');
               -- cnt <= (others => '0');
            end if;
            if test_var /= 0 then
                    out_reg <= '1';
                    --test <= test - 1;
                    test_var := test_var - 1;
                else 
                    out_reg <= '0';
            end if;
        else 
            out_reg <= Pulse_In;
        end if;
    end if;
  end process;

  Pulse_Filtered <= out_reg;

end architecture;
