library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pause_toggle is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        btn_pause : in  STD_LOGIC;
        pause_out : out STD_LOGIC
    );
end pause_toggle;

architecture Behavioral of pause_toggle is
    signal state : STD_LOGIC := '0';
    signal btn_prev : STD_LOGIC := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            state <= '0';
            btn_prev <= '0';
        elsif rising_edge(clk) then
            if (btn_prev = '0' and btn_pause = '1') then
                state <= not state;
            end if;
            btn_prev <= btn_pause;
        end if;
    end process;

    pause_out <= state;

end Behavioral;