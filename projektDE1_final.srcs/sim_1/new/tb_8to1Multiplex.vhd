-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 17:40:45 GMT
-- Request id : cfwk-fed377c2-680e6c1da88a0

library ieee;
use ieee.std_logic_1164.all;

entity tb_i8to1Multiplex is
end tb_i8to1Multiplex;

architecture tb of tb_i8to1Multiplex is

    component i8to1Multiplex
        port (counter0 : in std_logic_vector (3 downto 0);
              counter1 : in std_logic_vector (3 downto 0);
              counter2 : in std_logic_vector (3 downto 0);
              counter3 : in std_logic_vector (3 downto 0);
              counter4 : in std_logic_vector (3 downto 0);
              counter5 : in std_logic_vector (3 downto 0);
              counter6 : in std_logic_vector (3 downto 0);
              counter7 : in std_logic_vector (3 downto 0);
              switch   : in std_logic_vector (2 downto 0);
              output   : out std_logic_vector (3 downto 0));
    end component;

    signal counter0 : std_logic_vector (3 downto 0);
    signal counter1 : std_logic_vector (3 downto 0);
    signal counter2 : std_logic_vector (3 downto 0);
    signal counter3 : std_logic_vector (3 downto 0);
    signal counter4 : std_logic_vector (3 downto 0);
    signal counter5 : std_logic_vector (3 downto 0);
    signal counter6 : std_logic_vector (3 downto 0);
    signal counter7 : std_logic_vector (3 downto 0);
    signal switch   : std_logic_vector (2 downto 0);
    signal output   : std_logic_vector (3 downto 0);

begin

    dut : i8to1Multiplex
    port map (counter0 => counter0,
              counter1 => counter1,
              counter2 => counter2,
              counter3 => counter3,
              counter4 => counter4,
              counter5 => counter5,
              counter6 => counter6,
              counter7 => counter7,
              switch   => switch,
              output   => output);

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        counter0 <= b"0101";    -- 5
        counter1 <= b"0001";   -- 1
        counter2 <= b"0010";  -- 2
        counter3 <= b"0011"; -- 3
        counter5 <= b"0100";  -- 4
        counter6 <= b"0110"; -- 6
        counter4 <= b"1100"; -- 12
        counter7 <= b"1000"; -- 8
        switch <= (others => '0');

        -- ***EDIT*** Add stimuli here
        wait for 25 ns; -- start of simulation
        switch <= b"000"; -- select counter0
        wait for 10 ns;
        switch <= b"001"; -- select counter1
        wait for 10 ns;
        switch <= b"010"; -- select counter2
        wait for 10 ns;
        switch <= b"011"; -- select counter3
        wait for 10 ns;
        switch <= b"100"; -- select counter4
        wait for 10 ns;
        switch <= b"101"; -- select counter5
        wait for 10 ns;
        switch <= b"110"; -- select counter6
        wait for 10 ns;
        switch <= b"111"; -- select counter7

        
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_i8to1Multiplex of tb_i8to1Multiplex is
    for tb
    end for;
end cfg_tb_i8to1Multiplex;