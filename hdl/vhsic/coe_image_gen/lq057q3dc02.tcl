# Tcl script to run in the Xilinx Tcl shell or the ISE Tcl Console

# To run this script, `cd' to the directory containg this file
# using the Tcl shell/console.  Type "source <filename>" at Tcl prompt.

#Go to project directory
cd ../ise_files

# set up the project
project new lq057q3dc02.ise
project set family Virtex2P
project set device XC2VP30
project set package FF896
project set speed -7
project set synthesis_tool "XST (VHDL/Verilog)"
project set generated_simulation_language "ModelSim-SE Mixed"

# Set Generate Programming File properties
project set "Unused IOB Pins" "Pull Up"
project set "FPGA Start-Up Clock" "JTAG Clock"
project set "Done (Output Events)" 6
project set "Enable Outputs (Output Events)" 3
project set "Release Write Enable (Output Events)" 5
project set "Release DLL (Output Events)" 4


# Go back to user source directory
cd ../coe_image_gen

# add source files
xfile add *.vhd *.ucf *.xco *.xaw


