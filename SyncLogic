library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SyncLogic is
    Port (
        CLK       : in  std_logic;
        BTN       : in  std_logic;
        SW        : in  std_logic;
        BTN_SYNC  : out std_logic;
        BTN_PREV  : out std_logic;
        SW_SYNC   : out std_logic
    );
end SyncLogic;

architecture Behavioral of SyncLogic is
    signal btn_reg  : std_logic := '0';
    signal btn_prev_reg : std_logic := '0';
    signal sw_reg   : std_logic := '0';
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            btn_prev_reg <= btn_reg;
            btn_reg <= BTN;
            sw_reg <= SW;
        end if;
    end process;

    BTN_SYNC <= btn_reg;
    BTN_PREV <= btn_prev_reg;
    SW_SYNC  <= sw_reg;
end Behavioral;
