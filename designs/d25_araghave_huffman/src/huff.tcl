if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

##############################################################################
## Set global variables and attributes
##############################################################################

set _REPORTS_PATH reports

#45nm 
set LIB_FILE /afs/ece.cmu.edu/usr/araghave/nv_small/hw/tubgemm/NangateOpenCellLibrary_typical_ccs.db

#set_app_var search_path {/afs/ece.cmu.edu/usr/araghave/nv_small/hw/tubgemm/nv_small_DWYES/vmod/}
#set RTL_SEARCH_PATH "/afs/ece.cmu.edu/usr/araghave/nv_small/hw/tubgemm/nv_small_DWYES/vmod/"

set_app_var search_path {/afs/ece.cmu.edu/usr/araghave/18624/project/}
set RTL_SEARCH_PATH "/afs/ece.cmu.edu/usr/araghave/18624/project/"

set RTL_EXTENSIONS {.sv}


set RTL_FILES {huff_enc.sv}


#set RTL_FILES {temporal_mac_8.sv}
set DESIGN huff_encoder 
#set DESIGN temporal_mac

###############################################################
## Library setup
###############################################################

define_design_lib work -path ./work

set_app_var target_library $LIB_FILE
set_app_var link_library $LIB_FILE

####################################################################
## Load Design
####################################################################

analyze -format sverilog $RTL_FILES
elaborate $DESIGN

####################################################################
## Constraints Setup
####################################################################

set_fix_multiple_port_nets -all -buffer_constants
create_clock -period 2.5 -waveform {0 1.25} clk

if {![file exists ${_REPORTS_PATH}]} {
  file mkdir ${_REPORTS_PATH}
  puts "Creating directory ${_REPORTS_PATH}"
}

#####################################################################################################
### Synthesize
#####################################################################################################

uniquify
check_design
compile

######################################################################################################
## Write Reports
######################################################################################################

redirect ${_REPORTS_PATH}/area.rpt { report_area -hierarchy }
redirect ${_REPORTS_PATH}/power.rpt { report_power -hierarchy }
redirect ${_REPORTS_PATH}/timing.rpt { report_timing -path full -delay max -max_paths 1 -nworst 1 }

quit
