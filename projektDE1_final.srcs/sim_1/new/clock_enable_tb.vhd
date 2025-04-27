library ieee;
use ieee.std_logic_1164.all;

entity clock_enable_tb is
end clock_enable_tb;

architecture tb of clock_enable_tb is
    
    component clock_enable
     generic (N_PERIODS : integer := 10);
        port (clk   : in std_logic;
              rst   : in std_logic;
              pulse : out std_logic);
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal pulse : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : clock_enable
    port map (clk   => clk,
              rst   => rst,
              pulse => pulse);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    stimuli : process
    begin
     
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        wait for 100 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_clock_enable_tb of clock_enable_tb is
    for tb
    end for;
end cfg_clock_enable_tb;