library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end counter_tb;

architecture tb of counter_tb is

    component counter
        generic (
            N_BITS : integer := 4
        );
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            en     : in  std_logic;
            count  : out std_logic_vector(N_BITS-1 downto 0);
            carry  : out std_logic
        );
    end component;

    constant TbPeriod : time := 10 ns;

    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal en     : std_logic := '0';
    signal count  : std_logic_vector(3 downto 0);
    signal carry  : std_logic;
    signal TbSimEnded : std_logic := '0';

begin

    -- Hodinový signál
    clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

    dut : counter
        generic map (N_BITS => 4)
        port map (
            clk   => clk,
            rst   => rst,
            en    => en,
            count => count,
            carry => carry
        );

    -- Stimuli
    stim : process
    begin
        -- Reset
        rst <= '1';
        wait for 40 ns;
        rst <= '0';

        -- Enable počítanie
        en <= '1';

        wait for 200 ns;

        -- Stop
        en <= '0';

        -- Reset 
        rst <= '1';
        wait for 30 ns;
        rst <= '0';

        en <= '1';
        wait for 200 ns;

        -- Koniec simulácie
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
