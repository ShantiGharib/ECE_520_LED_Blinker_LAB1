----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/08/2026 01:20:33 PM
-- Design Name: 
-- Module Name: top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--purpose: to turn led_out signal into a choice of one of three rgb colors: red, green, or blue
--ONLY ONE rgb color at a time
entity rgb_top is
    generic (
        CLK_CYCLES_PER_TOGGLE : positive := 62_500_000 --fall through for testbench
    );
    Port (
        sys_clk : in std_logic;
        rst : in std_logic;
        sw : in std_logic_vector(2 downto 0); --sw0 only -> red, sw1 only -> green, sw2 only -> blue
        rgb_out : out std_logic_vector(2 downto 0) := (others => '0')
    );
end rgb_top;

architecture Behavioral of rgb_top is
    component blinking_led is
        generic (
            CLK_CYCLES_PER_TOGGLE : positive := 62_500_000
        );
        Port ( 
            sys_clk, --125 MHz; same as zybo board clk speed
            rst, --active high synchronous reset
            led_en : in std_logic; --led enable signal
            led_out : out std_logic := '0' --led power signal
        );
    end component;
    signal led_en, led_out : std_logic;
begin

    led_en <= '1' when ((sw(0) xor sw(1) xor sw(2)) and (not sw(0) or not sw(1))) else '0';--only one switch should be active
    --111 or 100 or 010 or 001; in all the valid states, either sw(0) or sw(1) are zero
    
    blinking_led_inst: blinking_led
    generic map (
        CLK_CYCLES_PER_TOGGLE => CLK_CYCLES_PER_TOGGLE
    )
    port map (
      sys_clk => sys_clk,
      rst     => rst,
      led_en  => led_en,
      led_out => led_out
    );
    rgb_out(0) <= sw(0) and led_out;
    rgb_out(1) <= sw(1) and led_out;
    rgb_out(2) <= sw(2) and led_out;

end Behavioral;
