------------------------------------------------------------------------------
-- Copyright (C) 2007 Jonathon W. Donaldson
--                    jwdonal a t opencores DOT org
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
--
------------------------------------------------------------------------------
--
-- $Id: lq057q3dc02.vhd,v 1.2 2007-05-25 11:27:37 jwdonal Exp $
--
-- Description:
--   Top level file for the lq057q3dc02 pcore.
--
-- LCD Handling Cautions: You should make sure that you always power off the
-- LCD before turning on the FPGA controller board with the control cable
-- connected.
--
-- Structure:
--   - xupv2p.ucf
--   - components.vhd
--   - lq057q3dc02.vhd
--     - dcm_sys_to_lcd.xaw
--     - video_controller.vhd
--       - enab_control.vhd
--       - hsyncx_control.vhd
--       - vsyncx_control.vhd
--       - clk_lcd_cyc_cntr.vhd
--     - image_gen_bram.vhd
--       - image_gen_bram_red.xco
--       - image_gen_bram_green.xco
--       - image_gen_bram_blue.xco
--
------------------------------------------------------------------------------
--
-- Naming Conventions:
--   active low signals                                       "*x"
--   clock signal                                             "CLK_*"
--   reset signal                                             "RST"
--   generic/constant                                         "C_*"
--   user defined type                                        "TYPE_*"
--   state machine next state                                 "*_ns"
--   state machine current state                              "*_cs""
--   pipelined signals                                        "*_d#"
--   register delay signals                                   "*_p#"
--   signal                                                   "*_sig"
--   variable                                                 "*_var"
--   storage register                                         "*_reg"
--   clock enable signals                                     "*_ce"
--   internal version of output port used as connecting wire  "*_wire"
--   input/output port                                        "ALL_CAPS"
--   process                                                  "*_PROC"
--
------------------------------------------------------------------------------

--////////////////////--
-- LIBRARY INCLUSIONS --
--////////////////////--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.components.ALL;

--////////////////////--
-- ENTITY DECLARATION --
--////////////////////--
ENTITY lq057q3dc02 IS

  GENERIC (
  
    --One useful piece of info for this 320x240x18bpp screen is that the
    --largest amount of image data it can support with all color bits used
    --is 1,382,400 bits = 172,800 bytes.  The Virtex-II Pro has enough BRAM
    --space to support 306KB = 313,344 bytes.  So you could not possible
    --fill up the BRAM with a single image.
    
    --NOTE! You can EASILY mistake success for failure when viewing a test
    --image because the resolution of this LCD is soooooo low.  Be sure to look
    --VERY carefully at the test image before you assume your algorithms are
    --incorrect!
  
    --Video Controller (pass thru)
    C_RL_STATUS : STD_LOGIC := '0';
    C_UD_STATUS : STD_LOGIC := '1';
    C_VQ_STATUS : STD_LOGIC := '0';  --This LCD supports QVGA (320x240) mode only!
    
    --Important Terms:
    --1 Pixel = 1 [RGB] element on the screen
    --BPP = Bits/Pixel = "Color Depth" = "Bit Depth"
    --BPP/3colors_per_pixel = #BPC = #Bits Per Color
    --2 color = 1 bpp
    --16 color = 4 bpp
    --256 color = 8 bpp
    --262,144 color = 18 bpp = 6 bpc = this is what the lq057q3dc02 is capable of
    --16.7 million color (True Color) = 24 bpp
    --A bitmap file that has anything lower than true color stores it's image data as look-up locations
    --to a color pallete.  The color pallete is referenced from the Windows system the bitmap is being viewed on.  Remember, Bitmap if a Microsoft file format!
    C_BIT_DEPTH : POSITIVE := 18; --2**(18 bits/pixel) = 262,144 possible colors
    
    --VSYNCx Controller (pass thru)
    --MIGHT want to make the TV vector one bit larger in case the ser want to allow for larger time than 255 (the actual time spec can be much larger)
    C_VSYNC_TV  : POSITIVE := 255; -- VSYNC cycle time (lines)
    C_VSYNC_TVP : POSITIVE := 3;   -- VSYNCx pulse width (lines)
    C_VSYNC_TVS : POSITIVE := 7;   -- VSYNCx start position - can NOT start sending data until after 7 lines have passed (i.e. start sending data on the 8th line (i.e exactly THE time the 8th HSYNCx pulse))
    
    --HSYNCx Controller (pass thru)
    C_HSYNC_TH  : POSITIVE := 400; -- HSYNC cycle time (clocks)
    C_HSYNC_THP : POSITIVE := 10;  -- HSYNCx pulse width (clocks)  --would rather have MAX to conserve power (checked as accurate number of cycles in sim, but not on LA)
    
    --ENAB Controller (pass thru)    
    C_ENAB_TEP  : POSITIVE := 320; -- ENAB Pulse Width (clocks)
    C_ENAB_THE  : POSITIVE := 8;  -- HSYNCx-ENAB Phase Difference (clocks)
    
    --Change these when changing the image
    --Also, cleanup all project files, and delete all auto-generated image_gen_bram files.
    C_BRAM_ADDR_WIDTH  : POSITIVE := 17;  -- required address width for full_screen image of 320x240 pixles
    C_IMAGE_WIDTH      : POSITIVE := 320; -- in pixels
    C_IMAGE_HEIGHT     : POSITIVE := 240  -- in pixels

  );

  PORT (

    -- <PORT_NAME> : <MODE> <DATA_TYPE>;

    RSTx,
    CLK_100M_PAD : IN std_logic;
    
    CLK_LCD,
    HSYNCx,
    VSYNCx,
    ENAB,
    RL,
    UD,
    VQ      : OUT std_logic;
    
    
    R,
    G,
    B       : OUT std_logic_vector(C_BIT_DEPTH/3-1 downto 0)
  );
  
END ENTITY lq057q3dc02;


--////////////////////////--
-- ARCHITECTURE OF ENTITY --
--////////////////////////--
ARCHITECTURE lq057q3dc02_arch OF lq057q3dc02 IS

  --Connecting wires to carry signals b/w components
  signal CLK_LCD_wire : std_logic;
  signal HSYNCx_wire  : std_logic;
  signal VSYNCx_wire  : std_logic;
  signal LINE_NUM_wire : std_logic_vector(8-1 downto 0);
  signal CLK_LCD_CYC_NUM_wire : std_logic_vector(9-1 downto 0);
  
begin

  --///////////////////--
  -- ASSERT STATEMENTS --
  --///////////////////--
  -- LQ057Q3DC02 Datasheet Timing Parameter Checks
  --TODO: is a check for C_BIT_DEPTH needed?  If colors, will just be truncated then that would be kewl.  Too high might want to be checked in any case as the colors will not display exactly the same on the LCD.
  ASSERT C_VQ_STATUS = '0'
  REPORT "ERROR - lq057q3dc02: Invalid value for generic C_VQ_STATUS (must be '0', lq057q3dc02 only supports QVGA)"
  SEVERITY FAILURE;
  
  ASSERT C_VSYNC_TV >= 251 and C_VSYNC_TV <= 280
  REPORT "ERROR - lq057q3dc02: Invalid value for generic C_VSYNC_TV (must be >= 251 and <= 280)"
  SEVERITY FAILURE;

  ASSERT C_VSYNC_TVP >= 2 and C_VSYNC_TVP <= 34
  REPORT "ERROR - lq057q3dc02: Invalid value for generic C_VSYNC_TVP (must be >= 2 and <= 34)"
  SEVERITY FAILURE;

  ASSERT C_VSYNC_TVS = 7
  REPORT "ERROR - lq057q3dc02: Invalid value for generic C_VSYNC_TVS (must be 7)"
  SEVERITY FAILURE;

  ASSERT C_HSYNC_TH >= 360 and C_HSYNC_TH <= 450
  REPORT "ERROR - lq057q3dc02: Invalid value for generic C_HSYNC_TH (must be >= 360 and <= 450)"
  SEVERITY FAILURE;
  
  ASSERT C_HSYNC_THP >= 2 and C_HSYNC_THP <= 200
  REPORT "ERROR - lq057q3dc02: Invalid value for generic C_HSYNC_THP (must be >= 2 and <= 200)"
  SEVERITY FAILURE;
  
  ASSERT C_ENAB_TEP >= 2 and C_ENAB_TEP <= (C_HSYNC_TH - 10)
  REPORT "ERROR - lq057q3dc02: Invalid value for generic C_ENAB_TEP (must be >= 2 and <= (C_HSYNC_TH - 10))"
  SEVERITY FAILURE;
  
  ASSERT C_ENAB_THE >= 2 and C_ENAB_THE <= (C_HSYNC_TH - 340)
  REPORT "ERROR - lq057q3dc02: Invalid value for generic C_ENAB_THE (must be >= 2 and <= (C_HSYNC_TH - 340))"
  SEVERITY FAILURE;

  --///////////////////////--
  -- CONCURRENT STATEMENTS --
  --///////////////////////--
  CLK_LCD <= CLK_LCD_wire;
  HSYNCx  <= HSYNCx_wire;
  VSYNCx  <= VSYNCx_wire;


  --//////////////////////////--
  -- COMPONENT INSTANTIATIONS --
  --//////////////////////////--  
  -- DCM creates 6.25MHz LCD clock from 100MHz system clock.
  -- DCM creates 25.0MHz clock for Logic Analyzer debugging.
  -- Xilinx does not allow CLK0_OUT to be removed
  -- This DCM was created with the Xilinx architecture wizard,
  -- therefore the .xaw file MUST be included in the project.
  DCM_LCD_CLK : dcm_sys_to_lcd
  PORT MAP (
    RST_IN          => "not"(RSTx),
    CLKIN_IN        => CLK_100M_PAD,
    CLKIN_IBUFG_OUT => OPEN,       -- 100MHz clock if you need it (attach to BUFG)
    CLK0_OUT        => OPEN,       -- 50MHz clock
    CLKDV_OUT       => CLK_LCD_wire,
    CLKFX_OUT       => OPEN        -- Attach this 25MHz clock to an output port for a logic analyzer
  );
  

  V_C : video_controller
  GENERIC MAP (
    --Video Controller
    C_RL_STATUS => C_RL_STATUS,
    C_UD_STATUS => C_UD_STATUS,
    C_VQ_STATUS => C_VQ_STATUS,
        
    --VSYNCx Controller
    C_VSYNC_TV => C_VSYNC_TV,
    C_VSYNC_TVP => C_VSYNC_TVP,
    C_VSYNC_TVS => C_VSYNC_TVS,
    
    --HSYNCx Controller
    C_HSYNC_TH => C_HSYNC_TH,
    C_HSYNC_THP => C_HSYNC_THP,
    
    --ENAB Controller
    C_ENAB_TEP => C_ENAB_TEP,
    C_ENAB_THE => C_ENAB_THE
  )
  PORT MAP (
    RSTx        => RSTx,
    CLK_LCD     => CLK_LCD_wire,
    CLK_LCD_CYC_NUM => CLK_LCD_CYC_NUM_wire,
    
    -- OUTPUTS
    LINE_NUM => LINE_NUM_wire,
    HSYNCx  => HSYNCx_wire,
    VSYNCx  => VSYNCx_wire,
    ENAB    => ENAB,
    RL      => RL,
    UD      => UD,
    VQ      => VQ
  );


  IMAGE : image_gen_bram
  GENERIC MAP (
    C_BIT_DEPTH => C_BIT_DEPTH,    
    C_VSYNC_TVS => C_VSYNC_TVS,    
    C_ENAB_TEP => C_ENAB_TEP,
    C_ENAB_THE => C_ENAB_THE,
    
    C_BRAM_ADDR_WIDTH => C_BRAM_ADDR_WIDTH,
    C_IMAGE_WIDTH      => C_IMAGE_WIDTH,
    C_IMAGE_HEIGHT     => C_IMAGE_HEIGHT
  )
  PORT MAP (
    RSTx    => RSTx,
    CLK_LCD => CLK_LCD_wire,
    LINE_NUM => LINE_NUM_wire,
    CLK_LCD_CYC_NUM => CLK_LCD_CYC_NUM_wire,
    
    --OUTPUTS
    R       => R,
    G       => G,
    B       => B
  );  

END ARCHITECTURE lq057q3dc02_arch;
