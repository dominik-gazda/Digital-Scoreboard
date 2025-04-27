----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 07:34:22 PM
-- Design Name: 
-- Module Name: 8to1Multiplex - Behavioral
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

entity i8to1Multiplex is
    Port ( counter0 : in STD_LOGIC_VECTOR (3 downto 0);
           counter1 : in STD_LOGIC_VECTOR (3 downto 0);
           counter2 : in STD_LOGIC_VECTOR (3 downto 0);
           counter3 : in STD_LOGIC_VECTOR (3 downto 0);
           counter4 : in STD_LOGIC_VECTOR (3 downto 0);
           counter5 : in STD_LOGIC_VECTOR (3 downto 0);
           counter6 : in STD_LOGIC_VECTOR (3 downto 0);
           counter7 : in STD_LOGIC_VECTOR (3 downto 0);
           switch : in STD_LOGIC_VECTOR (2 downto 0);
           output : out STD_LOGIC_VECTOR (3 downto 0));
end i8to1Multiplex;

architecture Behavioral of i8to1Multiplex is
        
begin

    p_multiplex :    process(switch, counter0, counter1, counter2, counter3, counter4, counter5, counter6, counter7) is
    begin
        case switch is
        when b"000" =>
            output <= counter0;
        when b"001" =>
            output <= counter1;
        when b"010" =>
            output <= counter2;
        when b"011" =>
            output <= counter3;
        when b"100" =>
            output <= counter4;
        when b"101" =>
            output <= counter5;
        when b"110" =>
            output <= counter6;
        when b"111" =>
            output <= counter7;                
        when others =>
            output <= b"1111";
        end case;
    end process p_multiplex;


end Behavioral;
