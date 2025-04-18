library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ButtonCounters_Top is
    Port (
        CLK       : in std_logic;
        RST       : in std_logic;
        BTN       : in std_logic;
        SW        : in std_logic;
        CNT1_OUT  : out std_logic_vector(3 downto 0);
        CNT2_OUT  : out std_logic_vector(3 downto 0)
    );
end ButtonCounters_Top;

architecture Structural of ButtonCounters_Top is
    signal btn_sync  : std_logic;
    signal btn_prev  : std_logic;
    signal sw_sync   : std_logic;
begin

    -- Instance synchronizační logiky
    U1: entity work.SyncLogic
        port map (
            CLK       => CLK,
            BTN       => BTN,
            SW        => SW,
            BTN_SYNC  => btn_sync,
            BTN_PREV  => btn_prev,
            SW_SYNC   => sw_sync
        );

    -- Instance čítací logiky
    U2: entity work.CounterLogic
        port map (
            CLK       => CLK,
            RST       => RST,
            BTN_SYNC  => btn_sync,
            BTN_PREV  => btn_prev,
            SW_SYNC   => sw_sync,
            CNT1_OUT  => CNT1_OUT,
            CNT2_OUT  => CNT2_OUT
        );

end Structural;
