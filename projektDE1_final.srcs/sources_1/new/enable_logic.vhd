library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enable_logic is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        pulse      : in  STD_LOGIC;
        pause      : in  STD_LOGIC;
        carry3     : in  STD_LOGIC;

        enable_out : out STD_LOGIC;
        auto_pause : out STD_LOGIC
    );
end enable_logic;

architecture Behavioral of enable_logic is
    signal auto_pause_reg : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                auto_pause_reg <= '0';
            elsif carry3 = '1' then
                auto_pause_reg <= '1';
            end if;
        end if;
    end process;

    enable_out <= pulse and (not pause) and (not auto_pause_reg);
    auto_pause <= auto_pause_reg;

end Behavioral;