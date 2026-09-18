----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/08/2026 01:54:26 PM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is
    component rgb_top is
        generic (
            CLK_CYCLES_PER_TOGGLE : positive := 62_500_000 --fall through for testbench
        );
        Port (
            sys_clk : in std_logic;
            rst : in std_logic;
            sw : in std_logic_vector(2 downto 0); --sw0 only -> red, sw1 only -> green, sw2 only -> blue
            rgb_out : out std_logic_vector(2 downto 0) := (others => '0')
        );
    end component;
    constant CLK_PERIOD : time := 8 ns;
    constant CLK_CYCLES_PER_TOGGLE_TB : integer := 10;
    signal sys_clk_tb, rst_tb : std_logic := '0';
    signal sw_tb : std_logic_vector(2 downto 0) := (others => '0');
    signal rgb_out_tb : std_logic_vector(2 downto 0);
begin

    rgb_top_inst: rgb_top
    generic map(
        CLK_CYCLES_PER_TOGGLE => CLK_CYCLES_PER_TOGGLE_TB
    )
    port map (
      sys_clk => sys_clk_tb, --125 MHz
      rst     => rst_tb, --synchronous reset
      sw      => sw_tb, --rgb switches: sw(0) only => red, sw(1) only => green, sw(2) only => blue
      rgb_out => rgb_out_tb --powers the rgb lights
    );

    CLK_PROCESS : process
    begin
        wait for CLK_PERIOD / 2;
        sys_clk_tb <= '1';
        wait for CLK_PERIOD / 2;
        sys_clk_tb <= '0';
    end process;


    test_process : process
    begin

    --test 1, red light
    wait until rising_edge(sys_clk_tb);
    wait for 1 ps; --delay to update values
    sw_tb(0) <= '1'; --turn on red rgb input
    wait for CLK_PERIOD * 10; --wait for 10 clock cycles
    wait for 1 ps; --delay to update values
    if (rgb_out_tb(0) /= '1') --check if output toggled
    then
        report "TEST FAILED: the red switch was enabled, the other switches were disabled. CLK_CYCLES_PER_TOGGLE fully elasped. Output did not toggle.";
        finish;
    elsif (rgb_out_tb(1) = '1' or rgb_out_tb(2) = '1') then
        report "TEST FAILED: the wrong output signals were activated";
        finish;
    end if;

    sw_tb(0) <= '0';
    wait until rising_edge(sys_clk_tb); --let entity reset
    wait for 1 ps; --delay to update values

    
    --test 2, green light
    wait until rising_edge(sys_clk_tb);
    wait for 1 ps; --delay to update values
    sw_tb(1) <= '1'; --turn on green rgb input
    wait for CLK_PERIOD * 10; --wait for 10 clock cycles
    wait for 1 ps; --delay to update values
    if (rgb_out_tb(1) /= '1') --check if output toggled
    then
        report "TEST FAILED: the green switch was enabled, the other switches were disabled. CLK_CYCLES_PER_TOGGLE fully elasped. Output did not toggle.";
        finish;
    elsif (rgb_out_tb(0) = '1' or rgb_out_tb(2) = '1') then
        report "TEST FAILED: the wrong output signals were activated";
        finish;
    end if;

    sw_tb(1) <= '0';
    wait until rising_edge(sys_clk_tb); --let entity reset
    wait for 1 ps; --delay to update values


    --test 3, blue light
    wait until rising_edge(sys_clk_tb);
    wait for 1 ps; --delay to update values
    sw_tb(2) <= '1'; --turn on blue rgb input
    wait for CLK_PERIOD * 10; --wait for 10 clock cycles
    wait for 1 ps; --delay to update values
    if (rgb_out_tb(2) /= '1') --check if output toggled
    then
        report "TEST FAILED: the blue switch was enabled, the other switches were disabled. CLK_CYCLES_PER_TOGGLE fully elasped. Output did not toggle.";
        finish;
    elsif (rgb_out_tb(0) = '1' or rgb_out_tb(1) = '1') then
        report "TEST FAILED: the wrong output signals were activated";
        finish;
    end if;

    sw_tb(2) <= '0';
    wait until rising_edge(sys_clk_tb); --let entity reset
    wait for 1 ps; --delay to update values




    --test 4: mixed switch signals
    -------------------------------
    -- 4a: red light and green light
    sw_tb(0) <= '1'; --turn on red rgb input
    sw_tb(1) <= '1'; --turn on green rgb input
    wait for CLK_PERIOD * 10; --wait for 10 clock cycles
    wait for 1 ps; --delay to update values
    if (rgb_out_tb(0) /= '0' and rgb_out_tb(1) /= '0') --check if output inappropriately toggled
    then
        report "TEST FAILED: multiple switches were enabled, but output signals were still activated.";
        finish;
    end if;

    sw_tb(0) <= '0';
    sw_tb(1) <= '0';
    wait until rising_edge(sys_clk_tb); --synchronize clk edge
    wait for 1 ps; --delay to update values


    -- 4b: red light and blue light
    sw_tb(0) <= '1'; --turn on red rgb input
    sw_tb(2) <= '1'; --turn on blue rgb input
    wait for CLK_PERIOD * 10; --wait for 10 clock cycles
    wait for 1 ps; --delay to update values
    if (rgb_out_tb(0) /= '0' and rgb_out_tb(2) /= '0') --check if output inappropriately toggled
    then
        report "TEST FAILED: multiple switches were enabled, but output signals were still activated.";
        finish;
    end if;

    sw_tb(0) <= '0';
    sw_tb(2) <= '0';
    wait until rising_edge(sys_clk_tb); --synchronize clk edge
    wait for 1 ps; --delay to update values


    -- 4c: green light and blue light
    sw_tb(1) <= '1'; --turn on green rgb input
    sw_tb(2) <= '1'; --turn on blue rgb input
    wait for CLK_PERIOD * 10; --wait for 10 clock cycles
    wait for 1 ps; --delay to update values
    if (rgb_out_tb(1) /= '0' and rgb_out_tb(2) /= '0') --check if output inappropriately toggled
    then
        report "TEST FAILED: multiple switches were enabled, but output signals were still activated.";
        finish;
    end if;

    sw_tb(1) <= '0';
    sw_tb(2) <= '0';
    wait until rising_edge(sys_clk_tb); --synchronize clk edge
    wait for 1 ps; --delay to update values


    -- 4d: red light, blue light and green light
    sw_tb(0) <= '1'; --turn on red rgb input
    sw_tb(1) <= '1'; --turn on green rgb input
    sw_tb(2) <= '1'; --turn on blue rgb input
    wait for CLK_PERIOD * 10; --wait for 10 clock cycles
    wait for 1 ps; --delay to update values
    if (rgb_out_tb(0) /= '0' and rgb_out_tb(1) /= '0' and rgb_out_tb(2) /= '0') --check if output inappropriately toggled
    then
        report "TEST FAILED: multiple switches were enabled, but output signals were still activated.";
        finish;
    end if;

    sw_tb(0) <= '0';
    sw_tb(1) <= '0';
    sw_tb(2) <= '0';
    wait until rising_edge(sys_clk_tb); --synchronize clk edge
    wait for 1 ps; --delay to update values

    --the rgb_top entity only forwards the reset signal to the blinking_led entity.
    --the reset signal was already tested when testing blinking_led entity.

    report "Test Passed";
    finish;
    end process;

end Behavioral;
