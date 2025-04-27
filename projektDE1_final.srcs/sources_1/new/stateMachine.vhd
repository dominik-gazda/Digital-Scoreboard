----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2025 08:36:46 PM
-- Design Name: 
-- Module Name: stateMachine - Behavioral
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

entity stateMachine is
    Port ( en : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           stateM : out STD_LOGIC_VECTOR (2 downto 0);
           stateA : out STD_LOGIC_VECTOR (7 downto 0);
           stateDP : out STD_LOGIC 
           );
end stateMachine;

architecture Behavioral of stateMachine is

    type    pos  is (POS0,  POS1,   POS2,   POS3,   POS4,   POS5,   POS6,   POS7);
    signal  current_pos,    next_pos    :   pos;
    -- signal en_prev : std_logic := '0'; 
    
begin
    
    p_pos_reset   :   process(clk)  is
    begin
        if  rising_edge(clk)  then
            current_pos <=  next_pos;
            if rst = '1' then
                current_pos <= POS0;

            end if;
          -- en_prev <= '0';
        end if;
    end process p_pos_reset;        

    p_pos_set   :   process(current_pos,en) is
    begin
    -- if en_prev  =   '0' and en = '1' then
        next_pos <= current_pos;
        case    current_pos is
            when POS0 => if en  =   '1' then    next_pos  <=  POS1; end if;
            when POS1 => if en  =   '1' then    next_pos  <=  POS2; end if;
            when POS2 => if en  =   '1' then    next_pos  <=  POS3; end if;
            when POS3 => if en  =   '1' then    next_pos  <=  POS4; end if;
            when POS4 => if en  =   '1' then    next_pos  <=  POS5; end if;
            when POS5 => if en  =   '1' then    next_pos  <=  POS6; end if;
            when POS6 => if en  =   '1' then    next_pos  <=  POS7; end if;
            when POS7 => if en  =   '1' then    next_pos  <=  POS0; end if;
            when others => next_pos <= POS0;
        end case;        
--    end if; 
--    en_prev <= en;
    end process p_pos_set;
    
    p_pos_write : process(current_pos) is
    begin
        case current_pos is
            when POS0 =>
                stateM <= "000";
                stateA <= b"1111_1110";
                stateDP <= '1';
            when POS1 =>
                stateM <= "001";
                stateA <= b"1111_1101";
                stateDP <= '1';
            when POS2 =>
                stateM <= "010";
                stateA <= b"1111_1011";
                stateDP <= '0';
            when POS3 =>
                stateM <= "011";
                stateA <= b"1111_0111";
                stateDP <= '1';
            when POS4 =>
                stateM <= "100";
                stateA <= b"1110_1111";
                stateDP <= '1';
            when POS5 =>
                stateM <= "101";
                stateA <= b"1101_1111";
                stateDP <= '1';
            when POS6 =>
                stateM <= "110";
                stateA <= b"1011_1111";
                stateDP <= '0';
            when POS7 =>
                stateM <= "111";
                stateA <= b"0111_1111";
                stateDP <= '1';
        end case;
    end process p_pos_write;
end Behavioral;
