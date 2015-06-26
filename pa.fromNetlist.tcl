
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name final -dir "C:/Users/NTHUCS/final/HardwareFinal/planAhead_run_2" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/NTHUCS/final/HardwareFinal/calculator.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/NTHUCS/final/HardwareFinal} }
set_property target_constrs_file "calculator.ucf" [current_fileset -constrset]
add_files [list {calculator.ucf}] -fileset [get_property constrset [current_run]]
link_design
