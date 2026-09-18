----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2026 07:16:24 PM
-- Design Name: 
-- Module Name: blinking_led_tb - Behavioral
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
use std.env.finish;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blinking_led_tb is
--  Port ( );
end blinking_led_tb;

architecture Behavioral of blinking_led_tb is
    constant CLK_PERIOD : time := 8 ns; --125 MHz
    constant CLK_CYCLES_PER_TOGGLE_TB : integer := 10; --for testbench practicality purposes
    signal clk_tb, rst_tb, led_en_tb : std_logic := '0'; --inputs; sim is driver
    signal led_out_tb : std_logic; --output; externally driven
--  rules: 
-- • Implement a counter that increments on every rising edge of the system clock
-- • When the counter reaches (CLK_CYCLES_PER_TOGGLE – 1), then toggle led_out
-- and clear the counter back to 0
-- • When rst is 1 or when led_en is 0, both the counter and led_out must be cleared
-- to 0
-- • With a 125 MHz clock and the default parameter value, led_out toggles every 0.5
-- seconds, which causes the LED to blink once every second
begin
    blinking_led_inst: entity work.blinking_led
    generic map (
      CLK_CYCLES_PER_TOGGLE => CLK_CYCLES_PER_TOGGLE_TB
    )
    port map (
      sys_clk => clk_tb,
      rst     => rst_tb,
      led_en  => led_en_tb,
      led_out => led_out_tb
    );

    CLK_PROCESS : process
    begin
        wait for CLK_PERIOD / 2;
        clk_tb <= '0';
        wait for CLK_PERIOD / 2;
        clk_tb <= '1';
    end process;

    test_process : process
    begin
        --test functionality 1: increments on every rising edge of the system clock
        -- • When the counter reaches (CLK_CYCLES_PER_TOGGLE – 1), then toggle led_out
        -- and clear the counter back to 0
        wait until rising_edge(clk_tb); --neutral state
        --allow counter to function
        led_en_tb <= '1';
        rst_tb <= '0';
        ---
        
        wait for (CLK_CYCLES_PER_TOGGLE_TB) * CLK_PERIOD;
        wait for 1 ps;
        if (led_out_tb /= '1') then
            report "TEST FAILED: LED output not toggling on CLK_CYCLES_PER_TOGGLE-1 CNT";
            finish;
        end if;
        --current state: counter at 0



        --test functionality 2: When rst is 1 or when led_en is 0, 
        --both the counter and led_out must be cleared to 0

        --get the counter counting to really be able to validate the counter reset, 
        --as the counter is hidden within the blinking_led block
        wait for (CLK_CYCLES_PER_TOGGLE_TB/2) * CLK_PERIOD;

        --current state: counter = CLK_CYCLES_PER_TOGGLE/2
        led_en_tb <= '0';
        wait for CLK_PERIOD;

        --assumed current state: counter = 0
        led_en_tb <= '1';
        wait for (CLK_CYCLES_PER_TOGGLE_TB) * CLK_PERIOD;
        wait for 1 ps;
        if (led_out_tb /= '1') then
            report "TEST FAILED: led enable signal did not reset led out signal";
            finish;
        end if;
        --current state: counter = 0

        wait for (CLK_CYCLES_PER_TOGGLE_TB/2) * CLK_PERIOD;
        --current state: counter = CLK_CYCLES_PER_TOGGLE/2

        --testing rst signal now
        rst_tb <= '1';
        wait for CLK_PERIOD;

        --assumed current state: counter = 0
        rst_tb <= '0';
        wait for (CLK_CYCLES_PER_TOGGLE_TB) * CLK_PERIOD;
        wait for 1 ps;
        if (led_out_tb /= '1') then
            report "TEST FAILED: led enable signal did not reset led out signal";
            finish;
        end if;
        --current state: counter = 0

        wait for (CLK_CYCLES_PER_TOGGLE_TB/2) * CLK_PERIOD;
        --testing both signals now
        rst_tb <= '1';
        led_en_tb <= '0';
        wait for CLK_PERIOD;

        --assumed current state: counter = 0
        rst_tb <= '0';
        led_en_tb <= '1';
        wait for (CLK_CYCLES_PER_TOGGLE_TB) * CLK_PERIOD;
        wait for 1 ps;
        if (led_out_tb /= '1') then
            report "TEST FAILED: led enable signal did not reset led out signal";
            finish;
        end if;
        --current state: counter = 0

        report "TEST PASSED";
        finish;
    end process;




end Behavioral;
