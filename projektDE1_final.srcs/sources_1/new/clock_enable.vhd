library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_enable is
    generic (
        N_PERIODS : integer := 100_000_000  -- 1 sekunda @ 100 MHz
    );
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        pulse : out STD_LOGIC
    );
end clock_enable;

architecture Behavioral of clock_enable is
    signal sig_count : integer range 0 to N_PERIODS := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_count <= 0;
                pulse <= '0';
            elsif sig_count = N_PERIODS - 1 then
                pulse <= '1';
                sig_count <= 0;
            else
                pulse <= '0';
                sig_count <= sig_count + 1;
            end if;
        end if;
    end process;

end Behavioral;
