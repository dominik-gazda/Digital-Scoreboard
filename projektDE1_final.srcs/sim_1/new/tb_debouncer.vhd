-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 18:24:39 GMT
-- Request id : cfwk-fed377c2-680e7667208ac

library ieee;
use ieee.std_logic_1164.all;

entity tb_debouncer is
end tb_debouncer;

architecture tb of tb_debouncer is

    component debouncer
        port (inp  : in std_logic;
              clk  : in std_logic;
              outp : out std_logic;
              rst  : in std_logic);
    end component;

    signal inp  : std_logic;
    signal clk  : std_logic;
    signal outp : std_logic;
    signal rst  : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : debouncer
    port map (inp  => inp,
              clk  => clk,
              outp => outp,
              rst  => rst);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        inp <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        dirtySignal : for i in 0 to 10 loop
            inp <= '1';
            wait for 50 ps;
            inp <= '0';
            wait for 50 ps;
        end loop ; -- dirtySignal
        
        cleanSignal : for i in 0 to 10 loop
            inp <= '1';
            wait for 25 ns;
            inp <= '0';
            wait for 25 ns;
        end loop ; -- cleanSignal

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_debouncer of tb_debouncer is
    for tb
    end for;
end cfg_tb_debouncer;