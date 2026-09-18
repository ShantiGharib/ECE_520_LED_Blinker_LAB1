# ECE_520_LED_Blinker_LAB1

# Overview
    This lab is about coding a module in Verilog or VHDL that implements a blinking led controller for a FPGA board.
    The board chosen in my specific implementation is the Zybo Z7-20. The language used is VHDL 2008.
# Design Summary
    The most nested module block is the blinking LED block. The blinking led block controls whether an led should be on or off. This state is inverted/toggled every "CLK_CYCLES_PER_TOGGLE" interval. "CLK_CYCLES_PER_TOGGLE" is a generic input.
    The block takes a clk, reset, and enable signals. It outputs an on/off signal. The outer block, in this case, the top block is the rgb controller block. This block communicates with the FPGA board. It takes the signals used by the blinking led module, forwarding it to that module, as well as three new signals which correspond to outputting either red, green, or blue. Based on which color is selected, when the blinking led module determines the led should be on, that selected color will be outputted. Only one color is declarable, so if more than one color is selected, this will short the enable signal rendering it always at zero. 
# Verification and Results
    I created two testbenches, one for each module. 
    
    For the blinking led module, because the module needs to count up to the value of the generic input, I added a test to check whether that aspect works. 
    I added another test to verify if when rst is 1 or when led_en is 0, that both the counter and led_out are always zero. This test has easy to follow comments in the code, so for more detail, go to code line 93 in ".\Lab1_rgb_led_ShantiGharib.srcs\sim_1\new\blinking_led_tb.vhd"

    For the rgb controller module, I created 7 different tests, where the first three tests are independent and the fourth test is comprised of 4 parts. The tests check whether each of the rgb color inputs and outputs work and whether any combination of at least two of the three rgb colors' enable signals results in the rgb never illuminating: rg, rb, gb, rgb.

    All the tests eventually passed.

# Known Issues or Limitations
    --empty
# References
    --empty