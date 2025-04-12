# Digital-Scoreboard
Digital scoreboard with timer for your preferred sport

## Timer
Schematic of the current timer design for measuring playtime in minutes and seconds. \\
![image](https://github.com/user-attachments/assets/1e54748c-80d1-4b69-98d6-a79cd946e7f6)


#### Clock enable
---
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_enable is
    generic (
        N_PERIODS : integer := 100_000_000  -- 1 sekunda @ 100 MHz
    );
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        pulse : out STD_LOGIC
    );
end clock_enable;

architecture Behavioral of clock_enable is
    signal sig_count : integer range 0 to N_PERIODS := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_count <= 0;
                pulse <= '0';
            elsif sig_count = N_PERIODS - 1 then
                pulse <= '1';
                sig_count <= 0;
            else
                pulse <= '0';
                sig_count <= sig_count + 1;
            end if;
        end if;
    end process;

end Behavioral;
```
#### **Counter**
---
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    generic (
        N_BITS : integer := 4
    );
    Port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        en     : in  STD_LOGIC;
        count  : out STD_LOGIC_VECTOR (N_BITS-1 downto 0);
        carry  : out STD_LOGIC
    );
end counter;

architecture Behavioral of counter is
    signal cnt        : unsigned(N_BITS-1 downto 0) := (others => '0');
    signal carry_next : std_logic := '0';
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
                carry_next <= '0';
            elsif en = '1' then
                if cnt = 9 then -- resp. 5 pre counter na čítanie desiatok sekúnd 
                    cnt <= (others => '0');
                    carry_next <= '1';
                else
                    cnt <= cnt + 1;
                    carry_next <= '0';
                end if;
            else
                carry_next <= '0';
            end if;
        end if;
    end process;

    count <= std_logic_vector(cnt);
    carry <= carry_next;

end Behavioral;
```
#### **Top level**
---
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port (
        CLK100MHZ : in  STD_LOGIC;
        BTNC      : in  STD_LOGIC;
        BTND      : in  STD_LOGIC;

        COUNT0    : out STD_LOGIC_VECTOR (3 downto 0);
        COUNT1    : out STD_LOGIC_VECTOR (3 downto 0);
        COUNT2    : out STD_LOGIC_VECTOR (3 downto 0);
        COUNT3    : out STD_LOGIC_VECTOR (3 downto 0)
    );
end top_level;

architecture Behavioral of top_level is
```vhdl
    component clock_enable is
        generic (
            N_PERIODS : integer := 20 -- pre rýchly test
            -- N_PERIODS : integer := 100_000_000 pre 1 sekundu (pri real HW)
        );
        Port (
            clk   : in  STD_LOGIC;
            rst   : in  STD_LOGIC;
            pulse : out STD_LOGIC
        );
    end component;

    component counter is
        generic (
            N_BITS : integer := 4
        );
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            en     : in  STD_LOGIC;
            count  : out STD_LOGIC_VECTOR (N_BITS-1 downto 0);
            carry  : out STD_LOGIC
        );
    end component;
    
    component counter_sec_des is
        generic (
            N_BITS : integer := 4
        );
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            en     : in  STD_LOGIC;
            count  : out STD_LOGIC_VECTOR (N_BITS-1 downto 0);
            carry  : out STD_LOGIC
        );
    end component;

    -- Interné signály
    signal sig_en       : std_logic;
    signal sig_en_final : std_logic;

    signal c0, c1, c2, c3 : std_logic_vector(3 downto 0);
    signal carry0, carry1, carry2, carry3 : std_logic;

    -- Pomocné signály pre "en"
    signal en1, en2, en3 : std_logic;

begin

    -- Clock enable blok
    u_clk_en : clock_enable
        generic map (
            N_PERIODS => 20
        )
        port map (
            clk   => CLK100MHZ,
            rst   => BTNC,
            pulse => sig_en
        );

    -- Povolenie počítania len ak nie je pauza
    sig_en_final <= sig_en and (not BTND);

    -- Pomocné en signály pre vyššie čítače
    en1 <= carry0 and sig_en_final;
    en2 <= carry1 and sig_en_final;
    en3 <= carry2 and sig_en_final;

    -- Counter 0 (sekundy jednotky)
    u_counter0 : counter
        generic map (N_BITS => 4)
        port map (
            clk    => CLK100MHZ,
            rst    => BTNC,
            en     => sig_en_final,
            count  => c0,
            carry  => carry0
        );

    -- Counter 1 (sekundy desiatky, počíta do 5)
    u_counter1 : counter_sec_des
        generic map (N_BITS => 4)
        port map (
            clk    => CLK100MHZ,
            rst    => BTNC,
            en     => en1,
            count  => c1,
            carry  => carry1
        );

    -- Counter 2 (minúty jednotky)
    u_counter2 : counter
        generic map (N_BITS => 4)
        port map (
            clk    => CLK100MHZ,
            rst    => BTNC,
            en     => en2,
            count  => c2,
            carry  => carry2
        );

    -- Counter 3 (minúty desiatky)
    u_counter3 : counter
        generic map (N_BITS => 4)
        port map (
            clk    => CLK100MHZ,
            rst    => BTNC,
            en     => en3,
            count  => c3,
            carry  => carry3
        );

    -- Výstupy
    COUNT0  <= c0;
    COUNT1  <= c1;
    COUNT2  <= c2;
    COUNT3  <= c3;

end Behavioral;
```
### Simulácia 

## Score

## Displaying data - 7 Segment Driver
