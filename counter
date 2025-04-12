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
                if cnt = 9 then
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
