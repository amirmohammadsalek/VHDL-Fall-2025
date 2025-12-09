library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Main is
    Port ( 
        Clk , Reset_n , Pulse_In , Glitch_Filter_En : in std_logic;
        Threshold_Short , Threshold_Medium , Alert_Threshold : in std_logic_vector (7 downto 0);
        Pulse_Filtered , Alert : out std_logic;
        Short_Count , Medium_Count , Long_Count : out std_logic_vector (7 downto 0) 
    );
end Main;

architecture Behavioral of Main is
    component filter port (
        Clk , Pulse_In , Glitch_Filter_En : in std_logic;
        Threshold_Short : in std_logic_vector (7 downto 0);
        Pulse_Filtered: out std_logic
    );
    end component;
    for all : filter use entity work.Glitch_Filter_V2 (rtl);
    signal count : unsigned (7 downto 0) := (others => '0');
    signal Short , Medium , Long : unsigned (7 downto 0) := (others => '0');
    signal Alert_d : std_logic := '0';
begin
    
    F1 : Filter
    
    port map (
        Clk => Clk,
        Pulse_in => Pulse_in,
        Glitch_Filter_En => Glitch_Filter_En,
        Threshold_Short => Threshold_Short,
        Pulse_Filtered => Pulse_Filtered
    );
    process(Clk)
    begin
        if rising_edge(Clk) then
            if Alert_d = '1' then
                Alert_d <= '0';
            end if;
            if reset_n = '0' then
                count <= (others => '0');
                Short <= (others => '0');
                Medium <= (others => '0');
                Long <= (others => '0');
                Alert_d <= '0';
            else 
                if Pulse_In = '1' then
                    count <= count + 1;
                elsif Pulse_In = '0' then
                    if count > unsigned(Threshold_Short) and count <= unsigned(Threshold_Medium) then
                        Medium <= Medium + 1;
                        Alert_d <= '0';
                    elsif count > unsigned(Threshold_Medium) and count <= unsigned(Alert_Threshold) then
                        Long <= Long + 1;
                        Alert_d <= '0';
                    elsif count = unsigned(Threshold_Short) and count > 0 then
                        Short <= Short + 1;
                        Alert_d <= '0';
                    elsif count > unsigned(Alert_Threshold) then
                        Alert_d <= '1';
                    end if;
                    count <= (others => '0');
                end if; 
            end if; 
        end if;   
    
    end process;        
    Short_Count <= std_logic_vector(Short);
    Medium_Count <= std_logic_vector(Medium);
    Long_Count <= std_logic_vector(Long);
    Alert <= Alert_d;

end Behavioral;