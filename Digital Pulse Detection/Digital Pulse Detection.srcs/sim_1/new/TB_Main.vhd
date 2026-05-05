Library Ieee;
Use Ieee.Std_Logic_1164.All;
Use Ieee.Numeric_Std.All;

Entity Tb_Main Is

End Tb_Main;

Architecture Behavioral Of Tb_Main Is

    Signal Clk   : Std_Logic := '0';
    Signal Reset_N : Std_Logic := '0';
    Signal Pulse_In : Std_Logic := '0';
    Signal Glitch_Filter_En : Std_Logic := '0';
    Signal Threshold_Short  : Std_Logic_Vector(7 Downto 0) := X"03";
    Signal Threshold_Medium : Std_Logic_Vector(7 Downto 0) := X"05";
    Signal Alert_Threshold  : Std_Logic_Vector(7 Downto 0) := X"0A";
    
    Signal Pulse_Filtered : Std_Logic;
    Signal Alert          : Std_Logic;
    Signal Short_Count    : Std_Logic_Vector(7 Downto 0);
    Signal Medium_Count   : Std_Logic_Vector(7 Downto 0);
    Signal Long_Count     : Std_Logic_Vector(7 Downto 0);

Begin

    Dut: Entity Work.Main
        Port Map(
            Clk => Clk,
            Reset_N => Reset_N,
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

    Clk_Process : Process
    Begin
        While True Loop
            Clk <= '0';
            Wait For 5 Ns;
            Clk <= '1';
            Wait For 5 Ns;
        End Loop;
    End Process;


    Stim_Proc : Process
    Begin
    
        Reset_N <= '0';
        Wait For 25 Ns;
        Reset_N <= '1';


        Pulse_In <= '1';
        Wait For 10 Ns;
        Pulse_In <= '0';
        Wait For 20 Ns;

        Pulse_In <= '1';
        Wait For 30 Ns;
        Pulse_In <= '0';
        Wait For 20 Ns;

        Pulse_In <= '1';
        Wait For 70 Ns;
        Pulse_In <= '0';
        Wait For 10 Ns;
        
        Glitch_Filter_En <= '1';
        Wait For 10 Ns;
        
        Pulse_In <= '1';
        Wait For 90 Ns;
        Pulse_In <= '0';
        Wait For 20 Ns;
        
        Pulse_In <= '1';
        Wait For 130 Ns;
        Pulse_In <= '0';
        Wait For 20 Ns;
        
        Pulse_In <= '1';
        Wait For 10 Ns;
        Pulse_In <= '0';
        Wait For 20 Ns;

        Wait;

    End Process;

End Behavioral;