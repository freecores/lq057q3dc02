--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2006 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file image_gen_bram_blue.vhd when simulating
-- the core, image_gen_bram_blue. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synopsys directives "translate_off/translate_on" specified
-- below are supported by XST, FPGA Compiler II, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synopsys translate_off
Library XilinxCoreLib;
-- synopsys translate_on
ENTITY image_gen_bram_blue IS
	port (
	addr: IN std_logic_VECTOR(16 downto 0);
	clk: IN std_logic;
	dout: OUT std_logic_VECTOR(5 downto 0);
	sinit: IN std_logic);
END image_gen_bram_blue;

ARCHITECTURE image_gen_bram_blue_a OF image_gen_bram_blue IS
-- synopsys translate_off
component wrapped_image_gen_bram_blue
	port (
	addr: IN std_logic_VECTOR(16 downto 0);
	clk: IN std_logic;
	dout: OUT std_logic_VECTOR(5 downto 0);
	sinit: IN std_logic);
end component;

-- Configuration specification 
	for all : wrapped_image_gen_bram_blue use entity XilinxCoreLib.blkmemsp_v6_2(behavioral)
		generic map(
			c_sinit_value => "0",
			c_has_en => 0,
			c_reg_inputs => 0,
			c_yclk_is_rising => 1,
			c_ysinit_is_high => 0,
			c_ywe_is_high => 0,
			c_yprimitive_type => "16kx1",
			c_ytop_addr => "1024",
			c_yhierarchy => "hierarchy1",
			c_has_limit_data_pitch => 0,
			c_has_rdy => 0,
			c_write_mode => 0,
			c_width => 6,
			c_yuse_single_primitive => 0,
			c_has_nd => 0,
			c_has_we => 0,
			c_enable_rlocs => 0,
			c_has_rfd => 0,
			c_has_din => 0,
			c_ybottom_addr => "0",
			c_pipe_stages => 0,
			c_yen_is_high => 1,
			c_depth => 76800,
			c_has_default_data => 0,
			c_limit_data_pitch => 18,
			c_has_sinit => 1,
			c_mem_init_file => "image_gen_bram_blue.mif",
			c_yydisable_warnings => 1,
			c_default_data => "0",
			c_ymake_bmm => 0,
			c_addr_width => 17);
-- synopsys translate_on
BEGIN
-- synopsys translate_off
U0 : wrapped_image_gen_bram_blue
		port map (
			addr => addr,
			clk => clk,
			dout => dout,
			sinit => sinit);
-- synopsys translate_on

END image_gen_bram_blue_a;

