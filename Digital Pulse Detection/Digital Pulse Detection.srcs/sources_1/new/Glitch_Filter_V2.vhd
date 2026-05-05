Library Ieee;
Use Ieee.Std_Logic_1164.All;
Use Ieee.Numeric_Std.All;

Entity Glitch_Filter Is
    Port (
        Clk               : In Std_Logic;                    -- System Clock
        Pulse_In          : In Std_Logic;                    -- Raw input pulse with potential glitches
        Glitch_Filter_En  : In Std_Logic;                    -- Enable signal: '1' for filtering, '0' for bypass
        Threshold_Short   : In Std_Logic_Vector (7 Downto 0);-- Minimum valid pulse width threshold
        Pulse_Filtered    : Out Std_Logic                    -- Cleaned output pulse
    );
End Glitch_Filter;

Architecture Behavioral Of Glitch_Filter Is
    Signal Out_Reg  : Std_Logic := '0';    
    Signal Count    : Unsigned(7 Downto 0) := (Others => '0'); -- Counter for input pulse duration
    Signal Treshold : Unsigned(7 Downto 0) := (Others => '0'); -- Internal register for output pulse holding
Begin

    Process(Clk)
    Begin
        If Rising_Edge(Clk) Then
            If Glitch_Filter_En = '1' Then    
                -- Case: Input signal is active (High)
                If Pulse_In = '1' Then
                    Count <= Count + 1;
                    -- If input exceeds threshold, it's a valid pulse, set output High
                    If Count >= Unsigned(Threshold_Short) Then 
                        Out_Reg <= '1';
                    End If;
                -- Case: Input signal is inactive (Low)
                Else
                    -- Manage output pulse duration based on validated input pulse width
                    If Treshold = 0 And Count = 0 Then
                        Treshold <= (Others => '0');
                    Elsif Count >= Unsigned(Threshold_Short) Then
                        -- Prepare to hold the output High for the validated duration
                        Treshold <= Unsigned(Threshold_Short) - 1; 
                    End If;
                    Count <= (Others => '0'); -- Reset counter for next pulse
                End If;

                -- Pulse Output Logic: Keeps output High if Threshold countdown is active
                If Treshold /= 0 Then
                    Out_Reg <= '1';
                    Treshold <= Treshold - 1;
                Elsif Treshold = 0 And Count < Unsigned(Threshold_Short) Then 
                    Out_Reg <= '0';
                End If;
            Else
                -- Bypass Mode: Directly pass Input to Output
                Out_Reg <= Pulse_In;    
            End If;
        End If;
    End Process;

    Pulse_Filtered <= Out_Reg;

End Behavioral;