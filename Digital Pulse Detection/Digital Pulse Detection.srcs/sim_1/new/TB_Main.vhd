library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Main is

end tb_Main;

architecture Behavioral of tb_Main is

    signal Clk   : std_logic := '0';
    signal Reset_n : std_logic := '0';
    signal Pulse_In : std_logic := '0';
    signal Glitch_Filter_En : std_logic := '0';
    signal Threshold_Short  : std_logic_vector(7 downto 0) := x"03";
    signal Threshold_Medium : std_logic_vector(7 downto 0) := x"05";
    signal Alert_Threshold  : std_logic_vector(7 downto 0) := x"0A";
    
    signal Pulse_Filtered : std_logic;
    signal Alert          : std_logic;
    signal Short_Count    : std_logic_vector(7 downto 0);
    signal Medium_Count   : std_logic_vector(7 downto 0);
    signal Long_Count     : std_logic_vector(7 downto 0);

begin

    DUT: entity work.Main
        port map(
            Clk => Clk,
            Reset_n => Reset_n,
            Pulse_In => Pulse_In,
            Glitch_Filter_En => Glitch_Filter_En,
            Threshold_Short => Threshold_Short,
            Threshold_Medium => Threshold_Medium,
            Alert_Threshold => Alert_Threshold,
            Pulse_Filtered => Pulse_Filtered,
            Alert => Alert,
            Short_Count => Short_Count,
            Medium_Count => Medium_Count,
            Long_Count => Long_Count
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
    
        Reset_n <= '0';
        wait for 25 ns;
        Reset_n <= '1';


        Pulse_In <= '1';
        wait for 10 ns;
        Pulse_In <= '0';
        wait for 20 ns;

        Pulse_In <= '1';
        wait for 30 ns;
        Pulse_In <= '0';
        wait for 20 ns;

        Pulse_In <= '1';
        wait for 70 ns;
        Pulse_In <= '0';
        wait for 10 ns;
        
        Glitch_Filter_En <= '1';
        wait for 10 ns;
        
        Pulse_In <= '1';
        wait for 90 ns;
        Pulse_In <= '0';
        wait for 20 ns;
        
        Pulse_In <= '1';
        wait for 130 ns;
        Pulse_In <= '0';
        wait for 20 ns;
        
        Pulse_In <= '1';
        wait for 10 ns;
        Pulse_In <= '0';
        wait for 20 ns;

        wait;

    end process;

end Behavioral;
