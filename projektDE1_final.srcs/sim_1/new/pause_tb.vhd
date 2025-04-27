library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pause_tb is
end pause_tb;

architecture behavior of pause_tb is

    -- Signály
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal btn_pause   : std_logic := '0';
    signal pause_out   : std_logic;

    -- Hodinový signál
    constant clk_period : time := 10 ns;

begin

    uut: entity work.pause_toggle
        port map (
            clk         => clk,
            rst         => rst,
            btn_pause   => btn_pause,
            pause_out   => pause_out
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stim_proc : process
    begin
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- Simulácia stlačenia tlačidla (toggle ON)
        btn_pause <= '1';
        wait for clk_period;
        btn_pause <= '0';
        wait for 20 ns;

        -- Opätovné stlačenie tlačidla (toggle OFF)
        btn_pause <= '1';
        wait for clk_period;
        btn_pause <= '0';
        wait for 20 ns;

        wait;
    end process;

end architecture;
