library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CounterLogic is
    Port (
        CLK       : in  std_logic;
        RST       : in  std_logic;
        BTN_SYNC  : in  std_logic;
        BTN_PREV  : in  std_logic;
        SW_SYNC   : in  std_logic;
        CNT1_OUT  : out std_logic_vector(3 downto 0);
        CNT2_OUT  : out std_logic_vector(3 downto 0)
    );
end CounterLogic;

architecture Behavioral of CounterLogic is
    signal counter1 : unsigned(3 downto 0) := (others => '0');
    signal counter2 : unsigned(3 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                counter1 <= (others => '0');
                counter2 <= (others => '0');
            else
                if (BTN_SYNC = '1' and BTN_PREV = '0') then
                    if SW_SYNC = '0' then
                        if counter1 = "1001" then
                            if counter2 = "1001" then
                                counter1 <= (others => '0');
                                counter2 <= (others => '0');
                            else
                                counter1 <= (others => '0');
                                counter2 <= counter2 + 1;
                            end if;
                        else
                            counter1 <= counter1 + 1;
                        end if;
                    else
                        if (counter1 = "0000" and counter2 = "0000") then
                            null;
                        elsif counter1 = "0000" then
                            counter1 <= "1001";
                            counter2 <= counter2 - 1;
                        else
                            counter1 <= counter1 - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    CNT1_OUT <= std_logic_vector(counter1);
    CNT2_OUT <= std_logic_vector(counter2);
end Behavioral;
