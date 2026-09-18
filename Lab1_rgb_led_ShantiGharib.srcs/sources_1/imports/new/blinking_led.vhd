----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2026 07:05:30 PM
-- Design Name: 
-- Module Name: blinking_led - Behavioral
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

entity blinking_led is
    generic (
        CLK_CYCLES_PER_TOGGLE : positive := 62_500_000
    );
    Port ( 
        sys_clk, --125 MHz; same as zybo board clk speed
        rst, --active high synchronous reset
        led_en : in std_logic; --led enable signal
        led_out : out std_logic := '0' --led power signal
    );
end blinking_led;

architecture Behavioral of blinking_led is
--  rules: 
-- • Implement a counter that increments on every rising edge of the system clock
-- • When the counter reaches (CLK_CYCLES_PER_TOGGLE – 1), then toggle led_out
-- and clear the counter back to 0
-- • When rst is 1 or when led_en is 0, both the counter and led_out must be cleared
-- to 0
-- • With a 125 MHz clock and the default parameter value, led_out toggles every 0.5
-- seconds, which causes the LED to blink once every second
begin
    led_control_proc : process(sys_clk)
        variable counter : integer range 0 to CLK_CYCLES_PER_TOGGLE-1 := 0;
    begin
        if (rising_edge(sys_clk)) then
            if (rst = '1' or led_en = '0') then
                led_out <= '0';
                counter := 0;
            elsif (counter = CLK_CYCLES_PER_TOGGLE -1) then
                led_out <= '0' when led_out = '1' else '1'; --toggle
                counter := 0;
            else
                counter := counter + 1;
            end if;
        end if;

    end process;

end Behavioral;
