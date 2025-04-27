----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2025 10:40:03 PM
-- Design Name: 
-- Module Name: toggler - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity toggler is
    Port ( outp : out STD_LOGIC;
           pause : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_500 : in STD_LOGIC;
           clk : in STD_LOGIC);
end toggler;

architecture Behavioral of toggler is

    type state is (pause_s, normal);
    signal sigState : state;
    signal sigHold : std_logic := '0';
begin

    
    p_reset : process(clk) is
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    sigState <= normal;
                else
                    if (pause = '1') then
                        sigState <= pause_s;
                    else
                        sigState <= normal;
                    end if;
                end if;
                if clk_500 = '1' then
                    if sigHold = '1' then
                        sigHold <= '0';
                    else
                        sigHold <= '1';
                    end if;
                end if;
            end if;
        end process;
    
    -- p_hold : process(clk_500) is
    -- begin
    --     if rising_edge(clk_500) then
    --         if sigHold = '1' then
    --             sigHold <= '0';
    --         else
    --             sigHold <= '1';
    --         end if;
    --     end if;
    -- end process;
    -- p_set_state : process(pause) is
    --     begin
            
    --     end process;

    p_writeAN : process(sigState, sigHold) is    
    begin
        case sigState is
            when pause_s =>
                    if sigHold = '1' then
                        outp <= '1';
                    else
                        outp <= '0';
                    end if;
            when normal =>
                outp <= '0';
            when others =>
                outp <= '0';
        end case;
    end process;
end Behavioral;
