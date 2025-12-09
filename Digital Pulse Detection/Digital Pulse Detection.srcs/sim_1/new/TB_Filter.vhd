library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Filter is

end tb_Filter;

architecture Behavioral of tb_Filter is

    signal Clk   : std_logic := '0';
    signal Pulse_In : std_logic := '0';
    signal Glitch_Filter_En : std_logic := '1';
    signal Threshold_Short  : std_logic_vector(7 downto 0) := x"03";
    
    signal Pulse_Filtered : std_logic;

begin

    -- ????? DUT
    DUT: entity work.Glitch_Filter_V2
        port map(
            Clk => Clk,
            Pulse_In => Pulse_In,
            Glitch_Filter_En => Glitch_Filter_En,
            Threshold_Short => Threshold_Short,
            Pulse_Filtered => Pulse_Filtered
        );

    Clk_process : process
    begin
        while true loop
            Clk <= '0';
            wait for 5 ns;
            Clk <= '1';
            wait for 5 ns;
        end loop;
    end process;


    stim_proc : process
    begin
        Pulse_In <= '0';
        wait for 5 ns;

        Pulse_In <= '1';
        wait for 10 ns;
        Pulse_In <= '0';
        wait for 10 ns;

        Pulse_In <= '1';
        wait for 40 ns;
        Pulse_In <= '0';
        wait for 10 ns;

        Pulse_In <= '1';
        wait for 10 ns;
        Pulse_In <= '0';
        wait for 10 ns;
        
        Pulse_In <= '1';
        wait for 60 ns;
        Pulse_In <= '0';
        wait for 10 ns;
        
        Pulse_In <= '1';
        wait for 70 ns;
        Pulse_In <= '0';
        wait for 10 ns;
        
        Pulse_In <= '1';
        wait for 80 ns;
        Pulse_In <= '0';
        wait for 10 ns;
        
        Pulse_In <= '1';
        wait for 60 ns;
        Pulse_In <= '0';
        wait for 10 ns;

        wait;

    end process;

end Behavioral;
