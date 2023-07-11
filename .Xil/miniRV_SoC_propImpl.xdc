set_property SRC_FILE_INFO {cfile:d:/lab2_miniRV/proj_single_cycle.gen/sources_1/ip/cpuclk/cpuclk.xdc rfile:../proj_single_cycle.gen/sources_1/ip/cpuclk/cpuclk.xdc id:1 order:EARLY scoped_inst:Clkgen/inst} [current_design]
current_instance Clkgen/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.100
