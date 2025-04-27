library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enable_logic_tb is
end enable_logic_tb;

architecture behavior of enable_logic_tb is

    -- Signály
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal pulse       : std_logic := '0';
    signal pause       : std_logic := '0';
    signal carry3      : std_logic := '0';
    signal enable_out  : std_logic;
    signal auto_pause  : std_logic;

    -- Hodinový signál
    constant clk_period : time := 10 ns;

begin

    uut: entity work.enable_logic
        port map (
            clk        => clk,
            rst        => rst,
            pulse      => pulse,
            pause      => pause,
            carry3     => carry3,
            enable_out => enable_out,
            auto_pause => auto_pause
        );

    -- Generovanie hodinového signálu
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Testovacia logika
    stim_proc : process
    begin
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- Povolený pulz bez pauzy
        pulse <= '1';
        wait for clk_period;
        pulse <= '0';

        -- Pauza aktívna (disable)
        pause <= '1';
        wait for 20 ns;
        pause <= '0';

        -- Pretečenie (carry3 = 1) -- aktivácia pauzy po pretečení
        carry3 <= '1';
        wait for clk_period;
        carry3 <= '0';
        wait for 20 ns;
        
        -- Pokus o pulse po auto_pause -- neprejde
        pulse <= '1';
        wait for clk_period;
        pulse <= '0';

        wait;
    end process;

end architecture;
