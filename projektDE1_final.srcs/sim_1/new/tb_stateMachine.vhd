-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 18:06:36 GMT
-- Request id : cfwk-fed377c2-680e722c3690d

library ieee;
use ieee.std_logic_1164.all;

entity tb_stateMachine is
end tb_stateMachine;

architecture tb of tb_stateMachine is

    component stateMachine
        port (en      : in std_logic;
              rst     : in std_logic;
              clk     : in std_logic;
              stateM  : out std_logic_vector (2 downto 0);
              stateA  : out std_logic_vector (7 downto 0);
              stateDP : out std_logic);
    end component;

    signal en      : std_logic;
    signal rst     : std_logic;
    signal clk     : std_logic;
    signal stateM  : std_logic_vector (2 downto 0);
    signal stateA  : std_logic_vector (7 downto 0);
    signal stateDP : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : stateMachine
    port map (en      => en,
              rst     => rst,
              clk     => clk,
              stateM  => stateM,
              stateA  => stateA,
              stateDP => stateDP);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        en <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 25 ns;
        rst <= '0';
        wait for 25 ns;

        -- ***EDIT*** Add stimuli here

        enableLoop : for i in 0 to 16 loop
            en <= not en;
            wait for 10 ns;
        end loop ; -- enableLoop
        

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_stateMachine of tb_stateMachine is
    for tb
    end for;
end cfg_tb_stateMachine;