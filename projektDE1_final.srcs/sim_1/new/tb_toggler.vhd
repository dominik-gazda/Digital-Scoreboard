-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 18:31:08 GMT
-- Request id : cfwk-fed377c2-680e77ec740b1

library ieee;
use ieee.std_logic_1164.all;

entity tb_toggler is
end tb_toggler;

architecture tb of tb_toggler is

    component toggler
        port (outp    : out std_logic;
              pause   : in std_logic;
              rst     : in std_logic;
              clk_500 : in std_logic;
              clk     : in std_logic);
    end component;

    signal outp    : std_logic;
    signal pause   : std_logic;
    signal rst     : std_logic;
    signal clk_500 : std_logic;
    signal clk     : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : toggler
    port map (outp    => outp,
              pause   => pause,
              rst     => rst,
              clk_500 => clk_500,
              clk     => clk);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk_500 is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        pause <= '0';
        clk_500 <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        clk500loop : for i in 0 to 5 loop
            clk_500 <= '1';
            wait for 10 ns;
            clk_500 <= '0';
            wait for 50 ns;
        end loop ; -- clk500loop

        pause <= '1';
        wait for 25 ns;
        clk500loop2 : for i in 0 to 5 loop
            clk_500 <= '1';
            wait for 10 ns;
            clk_500 <= '0';
            wait for 50 ns;
        end loop ; -- clk500loop

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_toggler of tb_toggler is
    for tb
    end for;
end cfg_tb_toggler;