Library Ieee;
Use Ieee.Std_Logic_1164.All;
Use Ieee.Numeric_Std.All;

-- This module categorizes pulses by duration and monitors for out-of-bound (Alert) signals.
Entity Main Is
    Port ( 
        Clk                : In Std_Logic;
        Reset_N            : In Std_Logic;                    -- Asynchronous active-low reset
        Pulse_In           : In Std_Logic;                    -- Raw pulse input
        Glitch_Filter_En   : In Std_Logic;                    -- Master filter enable
        Threshold_Short    : In Std_Logic_Vector (7 Downto 0);-- Boundary between Glitch and Short
        Threshold_Medium   : In Std_Logic_Vector (7 Downto 0);-- Boundary between Short and Medium
        Alert_Threshold    : In Std_Logic_Vector (7 Downto 0);-- Boundary for critical Alert
        Pulse_Filtered     : Out Std_Logic;                   -- Filtered signal output
        Alert              : Out Std_Logic;                   -- High if pulse width exceeds limit
        Short_Count        : Out Std_Logic_Vector (7 Downto 0);
        Medium_Count       : Out Std_Logic_Vector (7 Downto 0);
        Long_Count         : Out Std_Logic_Vector (7 Downto 0) 
    );
End Main;

Architecture Behavioral Of Main Is
    -- Component Declaration for the Glitch Filter unit
    Component Filter Port (
        Clk , Pulse_In , Glitch_Filter_En : In Std_Logic;
        Threshold_Short : In Std_Logic_Vector (7 Downto 0);
        Pulse_Filtered: Out Std_Logic
    );
    End Component;

    For All : Filter Use Entity Work.Glitch_Filter (Behavioral);

    Signal Count   : Unsigned (7 Downto 0) := (Others => '0');
    Signal Short   : Unsigned (7 Downto 0) := (Others => '0');
    Signal Medium  : Unsigned (7 Downto 0) := (Others => '0');
    Signal Long    : Unsigned (7 Downto 0) := (Others => '0');
    Signal Alert_D : Std_Logic := '0';
Begin
    
    -- Instantiate the glitch filter to clean the input signal
    F1 : Filter
    Port Map (
        Clk => Clk,
        Pulse_In => Pulse_In,
        Glitch_Filter_En => Glitch_Filter_En,
        Threshold_Short => Threshold_Short,
        Pulse_Filtered => Pulse_Filtered
    );

    -- Classification Process: Measures pulse width and increments appropriate counter
    Process(Clk)
    Begin
        If Rising_Edge(Clk) Then
            -- Synchronous pulse clearing for Alert flag
            If Alert_D = '1' Then
                Alert_D <= '0';
            End If;

            -- System Reset
            If Reset_N = '0' Then
                Count <= (Others => '0');
                Short <= (Others => '0');
                Medium <= (Others => '0');
                Long <= (Others => '0');
                Alert_D <= '0';
            Else 
                If Pulse_In = '1' Then
                    Count <= Count + 1; -- Measure pulse duration while signal is High
                Elsif Pulse_In = '0' Then
                    -- Categorize pulse duration on the falling edge
                    If Count > Unsigned(Threshold_Short) And Count <= Unsigned(Threshold_Medium) Then
                        Medium <= Medium + 1;
                    Elsif Count > Unsigned(Threshold_Medium) And Count <= Unsigned(Alert_Threshold) Then
                        Long <= Long + 1;
                    Elsif Count = Unsigned(Threshold_Short) And Count > 0 Then
                        Short <= Short + 1;
                    Elsif Count > Unsigned(Alert_Threshold) Then
                        Alert_D <= '1'; -- Trigger Alert if pulse is too long
                    End If;
                    Count <= (Others => '0'); -- Reset measurement for next pulse
                End If; 
            End If; 
        End If;    
    End Process;        

    -- Type Conversions and Output Assignments
    Short_Count  <= Std_Logic_Vector(Short);
    Medium_Count <= Std_Logic_Vector(Medium);
    Long_Count   <= Std_Logic_Vector(Long);
    Alert        <= Alert_D;

End Behavioral;