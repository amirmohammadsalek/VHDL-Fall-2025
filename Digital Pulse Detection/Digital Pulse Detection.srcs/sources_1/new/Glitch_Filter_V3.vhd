library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Glitch_Filter_V3 is
  port (
    Clk              : in  std_logic;
    Pulse_In         : in  std_logic;
    Glitch_Filter_En : in  std_logic;
    Threshold_Short  : in  std_logic_vector(7 downto 0);
    Pulse_Filtered   : out std_logic
  );
end Glitch_Filter_V3;

architecture Behavioral of Glitch_Filter_V3 is

  type buffer_array is array (0 to 255) of std_logic;
  signal buffer        : buffer_array;
  signal write_index   : integer range 0 to 255 := 0;
  signal read_index    : integer range 0 to 255 := 0;

  signal recording     : std_logic := '0';
  signal playback      : std_logic := '0';

  signal width_cnt     : unsigned(7 downto 0) := (others => '0');
  signal in_last       : std_logic := '0';

begin

  process(Clk)
  begin
    if rising_edge(Clk) then

      in_last <= Pulse_In;

      ---------------------------------------------------------
      -- ???? ???? ?????
      ---------------------------------------------------------
      if Glitch_Filter_En = '0' then
        Pulse_Filtered <= Pulse_In;
        recording <= '0';
        playback <= '0';
        write_index <= 0;
        read_index  <= 0;
        width_cnt <= (others => '0');
        return;
      end if;

      ---------------------------------------------------------
      -- ????? 1: ???? ???? ? ???? ???
      ---------------------------------------------------------
      if Pulse_In = '1' and in_last = '0' then
        recording <= '1';
        write_index <= 0;
        width_cnt <= (others => '0');
      end if;

      ---------------------------------------------------------
      -- ????? 2: ??? ?????? ????? ?? ????
      ---------------------------------------------------------
      if recording = '1' then
        buffer(write_index) <= Pulse_In;

        if write_index < 255 then
          write_index <= write_index + 1;
        end if;

        if Pulse_In = '1' then
          width_cnt <= width_cnt + 1;
        end if;
      end if;

      ---------------------------------------------------------
      -- ????? 3: ????? ???? ? ??????????
      ---------------------------------------------------------
      if Pulse_In = '0' and in_last = '1' then
        recording <= '0';

        if width_cnt >= unsigned(Threshold_Short) then
          -- ???? ??? ???? ?????
          playback <= '1';
          read_index <= 0;
        else
          playback <= '0';
        end if;
      end if;

      ---------------------------------------------------------
      -- ????? 4: ??? ?????? ??????? (???? ???)
      ---------------------------------------------------------
      if playback = '1' then
        Pulse_Filtered <= buffer(read_index);

        if read_index < write_index then
          read_index <= read_index + 1;
        else
          playback <= '0';
          Pulse_Filtered <= '0';
        end if;
      else
        Pulse_Filtered <= '0';
      end if;

    end if;
  end process;

end Behavioral;
