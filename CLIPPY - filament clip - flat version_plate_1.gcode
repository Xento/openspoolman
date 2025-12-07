; HEADER_BLOCK_START
; BambuStudio 01.10.01.50
; model printing time: 16m 10s; total estimated time: 22m 36s
; total layer number: 50
; total filament length [mm] : 410.54,146.73,322.21,224.70
; total filament volume [cm^3] : 987.46,352.92,775.00,540.47
; total filament weight [g] : 1.28,0.46,1.02,0.70
; filament_density: 1.3,1.3,1.32,1.3,1.32
; filament_diameter: 1.75,1.75,1.75,1.75,1.75
; max_z_height: 9.98
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0,0,0,0,0
; additional_cooling_fan_speed = 70,70,70,70,70
; auxiliary_fan = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 
; before_layer_change_gcode = 
; best_object_pos = 0.5,0.5
; bottom_shell_layers = 3
; bottom_shell_thickness = 0
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 50
; brim_object_gap = 0.1
; brim_type = auto_brim
; brim_width = 5
; chamber_temperatures = 0,0,0,0,0
; change_filament_gcode = ;===== A1 20240913 =======================\nM1007 S0 ; turn off mass estimation\nG392 S0\nM620 S[next_extruder]A\nM204 S9000\n{if toolchange_count > 1}\nG17\nG2 Z{max_layer_z + 0.4} I0.86 J0.86 P1 F10000 ; spiral lift a little from second lift\n{endif}\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n\nG1 X267 F18000\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F1200\n{else}\nM620.11 S0\n{endif}\nM400\n\nM620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}\nM620.10 A0 F[old_filament_e_feedrate]\nT[next_extruder]\nM620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}\nM620.10 A1 F[new_filament_e_feedrate] L[flush_length] H[nozzle_diameter] T[nozzle_temperature_range_high]\n\nG1 Y128 F9000\n\n{if next_extruder < 255}\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\n\nM400\nG92 E0\nM628 S0\n\n{if flush_length_1 > 1}\n; FLUSH_START\n; always use highest temperature to flush\nM400\nM1002 set_filament_type:UNKNOWN\nM109 S[nozzle_temperature_range_high]\nM106 P1 S60\n{if flush_length_1 > 23.7}\nG1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\n{else}\nG1 E{flush_length_1} F{old_filament_e_feedrate}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\nM400\nM1002 set_filament_type:{filament_type[next_extruder]}\n{endif}\n\n{if flush_length_1 > 45 && flush_length_2 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_2 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 45 && flush_length_3 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_3 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 45 && flush_length_4 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_4 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n\nM629\n\nM400\nM106 P1 S60\nM109 S[new_filament_temp]\nG1 E6 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nG1 Z{max_layer_z + 3.0} F3000\nM106 P1 S0\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\n\nM622.1 S0\nM9833 F{outer_wall_volumetric_speed/2.4} A0.3 ; cali dynamic extrusion compensation\nM1002 judge_flag filament_need_cali_flag\nM622 J1\n  G92 E0\n  G1 E-[new_retract_length_toolchange] F1800\n  M400\n  \n  M106 P1 S178\n  M400 S4\n  G1 X-38.2 F18000\n  G1 X-48.2 F3000\n  G1 X-38.2 F18000 ;wipe and shake\n  G1 X-48.2 F3000\n  G1 X-38.2 F12000 ;wipe and shake\n  G1 X-48.2 F3000\n  M400\n  M106 P1 S0 \nM623\n\nM621 S[next_extruder]A\nG392 S0\n\nM1007 S1\n
; close_fan_the_first_x_layers = 1,1,1,1,1
; complete_print_exhaust_fan_speed = 70,70,70,70,70
; cool_plate_temp = 35,35,35,35,35
; cool_plate_temp_initial_layer = 35,35,35,35,35
; curr_bed_type = Textured PEI Plate
; default_acceleration = 6000
; default_filament_colour = ;;;;
; default_filament_profile = "Bambu PLA Basic @BBL A1"
; default_jerk = 0
; default_print_profile = 0.20mm Standard @BBL A1
; deretraction_speed = 30
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; different_settings_to_system = initial_layer_print_height;initial_layer_speed;wall_generator;filament_cost;filament_density;hot_plate_temp_initial_layer;textured_plate_temp_initial_layer;filament_cost;filament_density;hot_plate_temp_initial_layer;textured_plate_temp_initial_layer;;filament_cost;filament_density;hot_plate_temp_initial_layer;textured_plate_temp_initial_layer;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70,70,70,70,70
; elefant_foot_compensation = 0.075
; enable_arc_fitting = 1
; enable_long_retraction_when_cut = 2
; enable_overhang_bridge_fan = 1,1,1,1,1
; enable_overhang_speed = 1
; enable_pressure_advance = 0,0,0,0,0
; enable_prime_tower = 1
; enable_support = 0
; enforce_support_layers = 0
; eng_plate_temp = 0,0,0,0,0
; eng_plate_temp_initial_layer = 0,0,0,0,0
; ensure_vertical_shell_thickness = 1
; exclude_object = 1
; extruder_clearance_dist_to_rod = 56.5
; extruder_clearance_height_to_lid = 256
; extruder_clearance_height_to_rod = 25
; extruder_clearance_max_radius = 73
; extruder_colour = #018001
; extruder_offset = 0x0
; extruder_type = DirectDrive
; fan_cooling_layer_time = 80,80,80,80,80
; fan_max_speed = 80,80,80,80,80
; fan_min_speed = 60,60,60,60,60
; filament_colour = #000000;#FFFAFA;#FFFFFF;#00BBFF;#FFFFFF
; filament_cost = 11.85,11.85,24.99,11.85,24.99
; filament_density = 1.3,1.3,1.32,1.3,1.32
; filament_diameter = 1.75,1.75,1.75,1.75,1.75
; filament_end_gcode = "; filament end gcode \nM106 P3 S0\n";"; filament end gcode \nM106 P3 S0\n";"; filament end gcode \nM106 P3 S0\n";"; filament end gcode \nM106 P3 S0\n";"; filament end gcode \nM106 P3 S0\n"
; filament_flow_ratio = 0.98,0.98,0.98,0.98,0.98
; filament_ids = GFL99;GFL99;GFA01;GFL99;GFA01
; filament_is_support = 0,0,0,0,0
; filament_long_retractions_when_cut = nil,nil,1,nil,1
; filament_max_volumetric_speed = 12,12,22,12,22
; filament_minimal_purge_on_wipe_tower = 15,15,15,15,15
; filament_notes = 
; filament_retraction_distances_when_cut = nil,nil,18,nil,18
; filament_scarf_gap = 15%,15%,0%,15%,0%
; filament_scarf_height = 10%,10%,5%,10%,5%
; filament_scarf_length = 10,10,10,10,10
; filament_scarf_seam_type = none,none,none,none,none
; filament_settings_id = "Generic PLA @BBL A1";"Generic PLA @BBL A1";"Bambu PLA Matte @BBL A1";"Generic PLA @BBL A1";"Bambu PLA Matte @BBL A1"
; filament_shrink = 100%,100%,100%,100%,100%
; filament_soluble = 0,0,0,0,0
; filament_start_gcode = "; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif};Prevent PLA from jamming\n\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif};Prevent PLA from jamming\n\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif};Prevent PLA from jamming\n\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
; filament_type = PLA;PLA;PLA;PLA;PLA
; filament_vendor = Generic;Generic;"Bambu Lab";Generic;"Bambu Lab"
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_volumes_matrix = 0,663,667,626,667,188,0,167,356,167,143,123,0,313,123,211,586,588,0,588,143,123,123,313,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0,0,0,0,0
; fuzzy_skin = none
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 226x224,256x224,256x256,226x256
; host_type = octoprint
; hot_plate_temp = 65,65,65,65,65
; hot_plate_temp_initial_layer = 75,75,65,75,65
; independent_support_layer_height = 0
; infill_combination = 0
; infill_direction = 45
; infill_jerk = 9
; infill_wall_overlap = 15%
; initial_layer_acceleration = 500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 105
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.18
; initial_layer_speed = 30
; inner_wall_acceleration = 0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 300
; interface_shells = 0
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 250
; ironing_direction = 45
; ironing_flow = 10%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.2
; line_width = 0.42
; long_retractions_when_cut = 0
; machine_end_gcode = ;===== date: 20231229 =====================\nG392 S0 ;turn off nozzle clog detect\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-13.0 F3000 ; move to safe pos\n{if !spiral_mode && print_sequence != "by object"}\nM1002 judge_flag timelapse_record_flag\nM622 J1\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM991 S0 P-1 ;end timelapse at safe pos\nM623\n{endif}\n\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\n;G1 X27 F15000 ; wipe\n\n; pull back filament to AMS\nM620 S255\nG1 X267 F15000\nT255\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nM621 S255\n\nM104 S0 ; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 256}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z256 F600\n    G1 Z256\n{endif}\nM400 P100\nM17 R ; restore z current\n\nG90\nG1 X-48 Y180 F3600\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A0 B20 L100 C37 D20 M40 E42 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C46 D10 M80 E46 F10 N80\nM1006 A44 B20 L100 C39 D20 M60 E48 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C48 D10 M60 E44 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10  N80\nM1006 A44 B20 L100 C49 D20 M80 E41 F20 N80\nM1006 A0 B20 L100 C0 D20 M60 E0 F20 N80\nM1006 A0 B20 L100 C37 D20 M30 E37 F20 N60\nM1006 W\n;=====printer finish  sound=========\n\n;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\nM400\nM18 X Y Z\n\n
; machine_load_filament_time = 25
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 12000,12000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 9000,9000
; machine_max_acceleration_x = 12000,12000
; machine_max_acceleration_y = 12000,12000
; machine_max_acceleration_z = 1500,1500
; machine_max_jerk_e = 3,3
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_speed_e = 30,30
; machine_max_speed_x = 500,200
; machine_max_speed_y = 500,200
; machine_max_speed_z = 30,30
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = M400 U1
; machine_start_gcode = ;===== machine: A1 =========================\n;===== date: 20240620 =====================\nG392 S0\nM9833.2\n;M400\n;M73 P1.717\n\n;===== start to heat heatbead&hotend==========\nM1002 gcode_claim_action : 2\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM104 S140\nM140 S[bed_temperature_initial_layer_single]\n\n;=====start printer sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A0 B10 L100 C37 D10 M60 E37 F10 N60\nM1006 A0 B10 L100 C41 D10 M60 E41 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A43 B10 L100 C46 D10 M70 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C43 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C41 D10 M80 E41 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E44 F10 N80\nM1006 A0 B10 L100 C49 D10 M80 E49 F10 N80\nM1006 A0 B10 L100 C0 D10 M80 E0 F10 N80\nM1006 A44 B10 L100 C48 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A43 B10 L100 C46 D10 M60 E39 F10 N80\nM1006 W\nM18 \n;=====start printer sound ===================\n\n;=====avoid end stop =================\nG91\nG380 S2 Z40 F1200\nG380 S3 Z-15 F1200\nG90\n\n;===== reset machine status =================\n;M290 X39 Y39 Z8\nM204 S6000\n\nM630 S0 P0\nG91\nM17 Z0.3 ; lower the z-motor current\n\nG90\nM17 X0.65 Y1.2 Z0.6 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\n;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\nM1002 gcode_claim_action : 13\n\nG28 X\nG91\nG1 Z5 F1200\nG90\nG0 X128 F30000\nG0 Y254 F3000\nG91\nG1 Z-5 F1200\n\nM109 S25 H140\n\nM17 E0.3\nM83\nG1 E10 F1200\nG1 E-0.5 F30\nM17 D\n\nG28 Z P0 T140; home z with low precision,permit 300deg temperature\nM104 S{nozzle_temperature_initial_layer[initial_extruder]}\n\nM1002 judge_flag build_plate_detect_flag\nM622 S1\n  G39.4\n  G90\n  G1 Z5 F1200\nM623\n\n;M400\n;M73 P1.717\n\n;===== prepare print temperature and material ==========\nM1002 gcode_claim_action : 24\n\nM400\n;G392 S1\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on\n\nG90\nG1 X-28.5 F30000\nG1 X-48.2 F3000\n\nM620 M ;enable remap\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\n    M1002 gcode_claim_action : 4\n    M400\n    M1002 set_filament_type:UNKNOWN\n    M109 S[nozzle_temperature_initial_layer]\n    M104 S250\n    M400\n    T[initial_no_support_extruder]\n    G1 X-48.2 F3000\n    M400\n\n    M620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]}\n    M109 S250 ;set nozzle to common flush temp\n    M106 P1 S0\n    G92 E0\n    G1 E50 F200\n    M400\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM621 S[initial_no_support_extruder]A\n\nM109 S{nozzle_temperature_range_high[initial_no_support_extruder]} H300\nG92 E0\nG1 E50 F200 ; lower extrusion speed to avoid clog\nM400\nM106 P1 S178\nG92 E0\nG1 E5 F200\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nG92 E0\nG1 E-0.5 F300\n\nG1 X-28.5 F30000\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\n\n;G392 S0\n\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n;M400\n;M73 P1.717\n\n;===== auto extrude cali start =========================\nM975 S1\n;G392 S1\n\nG90\nM83\nT1000\nG1 X-48.2 Y0 Z10 F10000\nM400\nM1002 set_filament_type:UNKNOWN\n\nM412 S1 ;  ===turn on  filament runout detection===\nM400 P10\nM620.3 W1; === turn on filament tangle detection===\nM400 S2\n\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n\n;M1002 set_flag extrude_cali_flag=1\nM1002 judge_flag extrude_cali_flag\n\nM622 J1\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_extruder]}\n    G1 E10 F{outer_wall_volumetric_speed/2.4*60}\n    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n\n    M106 P1 S255\n    M400 S5\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\n\n    M1002 judge_last_extrude_cali_success\n    M622 J0\n        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n        M106 P1 S255\n        M400 S5\n        G1 X-28.5 F18000\n        G1 X-48.2 F3000\n        G1 X-28.5 F18000 ;wipe and shake\n        G1 X-48.2 F3000\n        G1 X-28.5 F12000 ;wipe and shake\n        M400\n        M106 P1 S0\n    M623\n    \n    G1 X-48.2 F3000\n    M400\n    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter]\n    M106 P1 S178\n    M400 S7\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\nM623 ; end of "draw extrinsic para cali paint"\n\n;G392 S0\n;===== auto extrude cali end ========================\n\n;M400\n;M73 P1.717\n\nM104 S170 ; prepare to wipe nozzle\nM106 S255 ; turn on fan\n\n;===== mech mode fast check start =====================\nM1002 gcode_claim_action : 3\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q1 A5 K0 O3\nM974 Q1 S2 P0\n\nM970.2 Q1 K1 W58 Z0.1\nM974 S2\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q0 A10 K0 O1\nM974 Q0 S2 P0\n\nM970.2 Q0 K1 W78 Z0.1\nM974 S2\n\nM975 S1\nG1 F30000\nG1 X0 Y5\nG28 X ; re-home XY\n\nG1 Z4 F1200\n\n;===== mech mode fast check end =======================\n\n;M400\n;M73 P1.717\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\n\nM975 S1\nM106 S255 ; turn on fan (G28 has turn off fan)\nM211 S; push soft endstop status\nM211 X0 Y0 Z0 ;turn off Z axis endstop\n\n;===== remove waste by touching start =====\n\nM104 S170 ; set temp down to heatbed acceptable\n\nM83\nG1 E-1 F500\nG90\nM83\n\nM109 S170\nG0 X108 Y-0.5 F30000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X110 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X112 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X114 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X116 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X118 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X120 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X122 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X124 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X126 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X128 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X130 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X132 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X134 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X136 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X138 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X140 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X142 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X144 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X146 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X148 F10000\nG380 S3 Z-5 F1200\n\nG1 Z5 F30000\n;===== remove waste by touching end =====\n\nG1 Z10 F1200\nG0 X118 Y261 F30000\nG1 Z5 F1200\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-50}\n\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nM104 S140 ; prepare to abl\nG0 Z5 F20000\n\nG0 X128 Y261 F20000  ; move to exposed steel surface\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nG90\nG1 Z10 F1200\n\n;===== brush material wipe nozzle =====\n\nG90\nG1 Y250 F30000\nG1 X55\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X-35 F30000\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Z5.000 F1200\n\nG90\nG1 X30 Y250.000 F30000\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X35 F30000\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Z10.000 F1200\n\n;===== brush material wipe nozzle end =====\n\nG90\n;G0 X128 Y261 F20000  ; move to exposed steel surface\nG1 Y250 F30000\nG1 X138\nG1 Y261\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nM109 S140\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM211 R; pop softend status\n\n;===== wipe nozzle end ================================\n\n;M400\n;M73 P1.717\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\n\nG90\nG1 Z5 F1200\nG1 X0 Y0 F30000\nG29.2 S1 ; turn on ABL\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140\nM106 S0 ; turn off fan , too noisy\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n\n;===== home after wipe mouth end =======================\n\n;M400\n;M73 P1.717\n\nG1 X108.000 Y-0.500 F30000\nG1 Z0.300 F1200\nM400\nG2814 Z0.32\n\nM104 S{nozzle_temperature_initial_layer[initial_extruder]} ; prepare to print\n\n;===== nozzle load line ===============================\n;G90\n;M83\n;G1 Z5 F1200\n;G1 X88 Y-0.5 F20000\n;G1 Z0.3 F1200\n\n;M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n\n;G1 E2 F300\n;G1 X168 E4.989 F6000\n;G1 Z1 F1200\n;===== nozzle load line end ===========================\n\n;===== extrude cali test ===============================\n\nM400\n    M900 S\n    M900 C\n    G90\n    M83\n\n    M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n    G0 X128 E8  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\n\nM900 R\n\nM1002 judge_flag extrude_cali_flag\nM622 J1\n    G90\n    G1 X108.000 Y1.000 F30000\n    G91\n    G1 Z-0.700 F1200\n    G90\n    M83\n    G0 X128 E10  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\nM623\n\nG1 Z0.2\n\n;M400\n;M73 P1.717\n\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type=="Textured PEI Plate"}\nG29.1 Z{-0.02} ; for Textured PEI Plate\n{endif}\n\nM960 S1 P0 ; turn off laser\nM960 S2 P0 ; turn off laser\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\nG90\nM83\nT1000\n\nM211 X0 Y0 Z0 ;turn off soft endstop\n;G392 S1 ; turn on clog detection\nM1007 S1 ; turn on mass estimation\nG29.4\n
; machine_unload_filament_time = 29
; max_bridge_length = 0
; max_layer_height = 0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; nozzle_diameter = 0.4
; nozzle_height = 4.76
; nozzle_temperature = 220,220,220,220,220
; nozzle_temperature_initial_layer = 220,220,220,220,220
; nozzle_temperature_range_high = 240,240,240,240,240
; nozzle_temperature_range_low = 190,190,190,190,190
; nozzle_type = stainless_steel
; nozzle_volume = 92
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 200
; overhang_1_4_speed = 0
; overhang_2_4_speed = 50
; overhang_3_4_speed = 30
; overhang_4_4_speed = 10
; overhang_fan_speed = 100,100,100,100,100
; overhang_fan_threshold = 50%,50%,50%,50%,50%
; overhang_threshold_participating_cooling = 95%,95%,95%,95%,95%
; overhang_totally_speed = 19
; post_process = 
; precise_z_height = 0
; pressure_advance = 0.02,0.02,0.02,0.02,0.02
; prime_tower_brim_width = 3
; prime_tower_width = 35
; prime_volume = 45
; print_compatible_printers = "Bambu Lab A1 0.4 nozzle"
; print_flow_ratio = 1
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL A1
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 256
; printer_model = Bambu Lab A1
; printer_notes = 
; printer_settings_id = Bambu Lab A1 0.4 nozzle
; printer_structure = i3
; printer_technology = FFF
; printer_variant = 0.4
; printhost_authorization_type = key
; printhost_ssl_ignore_revoke = 0
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = 2
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1,1,1,1,1
; reduce_infill_retraction = 1
; required_nozzle_HRC = 3,3,3,3,3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 255
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_length = 0.8
; retraction_minimum_travel = 1
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_inner_walls = 1
; seam_slope_steps = 10
; silent_mode = 0
; single_extruder_multi_material = 1
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1,1,1,1,1
; slow_down_layer_time = 8,8,6,8,6
; slow_down_min_speed = 20,20,20,20,20
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 80
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 1
; sparse_infill_acceleration = 100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 15%
; sparse_infill_filament = 1
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = grid
; sparse_infill_speed = 270
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 45,45,45,45,45
; supertack_plate_temp_initial_layer = 45,45,45,45,45
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 0
; support_critical_regions_only = 0
; support_expansion = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 80
; support_interface_top_layers = 2
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 150
; support_style = default
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = normal(auto)
; temperature_vitrification = 45,45,45,45,45
; template_custom_gcode = 
; textured_plate_temp = 65,65,65,65,65
; textured_plate_temp_initial_layer = 75,75,65,75,65
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;===================== date: 20240606 =====================\n{if !spiral_mode && print_sequence != "by object"}\n; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer\nM622.1 S1 ; for prev firware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\nG92 E0\nG17\nG2 Z{layer_z + 0.4} I0.86 J0.86 P1 F20000 ; spiral lift a little\nG1 Z{max_layer_z + 0.4}\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-48.2 F3000 ; move to safe pos\nM400 P300\nM971 S11 C11 O0\nG92 E0\nG1 X0 F18000\nM623\n\nM622.1 S1\nM1002 judge_flag g39_3rd_layer_detect_flag\nM622 J1\n    ; enable nozzle clog detect at 3rd layer\n    {if layer_num == 2}\n      M400\n      G90\n      M83\n      M204 S5000\n      G0 Z2 F4000\n      G0 X261 Y250 F20000\n      M400 P200\n      G39 S1\n      G0 Z2 F4000\n    {endif}\n\n\n    M622.1 S1\n    M1002 judge_flag g39_detection_flag\n    M622 J1\n      {if !in_head_wrap_detect_zone}\n        M622.1 S0\n        M1002 judge_flag g39_mass_exceed_flag\n        M622 J1\n        {if layer_num > 2}\n            G392 S0\n            M400\n            G90\n            M83\n            M204 S5000\n            G0 Z{max_layer_z + 0.4} F4000\n            G39.3 S1\n            G0 Z{max_layer_z + 0.4} F4000\n            G392 S0\n          {endif}\n        M623\n    {endif}\n    M623\nM623\n{endif}\n
; timelapse_type = 0
; top_area_threshold = 100%
; top_one_wall_type = all top
; top_shell_layers = 5
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1
; top_surface_acceleration = 2000
; top_surface_jerk = 9
; top_surface_line_width = 0.42
; top_surface_pattern = monotonicline
; top_surface_speed = 200
; travel_jerk = 9
; travel_speed = 700
; travel_speed_z = 0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = 0
; upward_compatible_machine = 
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; wall_distribution_count = 1
; wall_filament = 1
; wall_generator = arachne
; wall_loops = 2
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 15
; wipe_tower_y = 221
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_hop = 0.4
; z_hop_types = Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R22
M201 X12000 Y12000 Z1500 E5000
M203 X500 Y500 Z30 E30
M204 P12000 R5000 T12000
M205 X9.00 Y9.00 Z3.00 E3.00
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: A1 =========================
;===== date: 20240620 =====================
G392 S0
M9833.2
;M400
;M73 P1.717

;===== start to heat heatbead&hotend==========
M1002 gcode_claim_action : 2
M1002 set_filament_type:PLA
M104 S140
M140 S75

;=====start printer sound ===================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A43 B10 L100 C46 D10 M70 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C43 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C41 D10 M80 E41 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E44 F10 N80
M1006 A0 B10 L100 C49 D10 M80 E49 F10 N80
M1006 A0 B10 L100 C0 D10 M80 E0 F10 N80
M1006 A44 B10 L100 C48 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A43 B10 L100 C46 D10 M60 E39 F10 N80
M1006 W
M18 
;=====start printer sound ===================

;=====avoid end stop =================
G91
G380 S2 Z40 F1200
G380 S3 Z-15 F1200
G90

;===== reset machine status =================
;M290 X39 Y39 Z8
M204 S6000

M630 S0 P0
G91
M17 Z0.3 ; lower the z-motor current

G90
M17 X0.65 Y1.2 Z0.6 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem

;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

M1002 gcode_claim_action : 13

G28 X
G91
G1 Z5 F1200
G90
G0 X128 F30000
G0 Y254 F3000
G91
G1 Z-5 F1200

M109 S25 H140

M17 E0.3
M83
M73 P1 R22
G1 E10 F1200
G1 E-0.5 F30
M17 D

G28 Z P0 T140; home z with low precision,permit 300deg temperature
M104 S220

M1002 judge_flag build_plate_detect_flag
M622 S1
  G39.4
  G90
M73 P2 R22
  G1 Z5 F1200
M623

;M400
;M73 P1.717

;===== prepare print temperature and material ==========
M1002 gcode_claim_action : 24

M400
;G392 S1
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on

G90
G1 X-28.5 F30000
G1 X-48.2 F3000

M620 M ;enable remap
M620 S1A   ; switch material if AMS exist
    M1002 gcode_claim_action : 4
    M400
    M1002 set_filament_type:UNKNOWN
    M109 S220
    M104 S250
    M400
    T1
    G1 X-48.2 F3000
    M400

    M620.1 E F299.339 T240
    M109 S250 ;set nozzle to common flush temp
    M106 P1 S0
    G92 E0
    G1 E50 F200
    M400
    M1002 set_filament_type:PLA
M621 S1A

M109 S240 H300
G92 E0
G1 E50 F200 ; lower extrusion speed to avoid clog
M400
M106 P1 S178
G92 E0
G1 E5 F200
M104 S220
G92 E0
G1 E-0.5 F300

G1 X-28.5 F30000
M73 P3 R21
G1 X-48.2 F3000
M73 P4 R21
G1 X-28.5 F30000 ;wipe and shake
G1 X-48.2 F3000
G1 X-28.5 F30000 ;wipe and shake
G1 X-48.2 F3000

;G392 S0

M400
M106 P1 S0
;===== prepare print temperature and material end =====

;M400
;M73 P1.717

;===== auto extrude cali start =========================
M975 S1
;G392 S1

G90
M83
T1000
G1 X-48.2 Y0 Z10 F10000
M400
M1002 set_filament_type:UNKNOWN

M412 S1 ;  ===turn on  filament runout detection===
M400 P10
M620.3 W1; === turn on filament tangle detection===
M400 S2

M1002 set_filament_type:PLA

;M1002 set_flag extrude_cali_flag=1
M1002 judge_flag extrude_cali_flag

M622 J1
    M1002 gcode_claim_action : 8

    M109 S220
    G1 E10 F300
    M983 F5 A0.3 H0.4; cali dynamic extrusion compensation

    M106 P1 S255
    M400 S5
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
M73 P5 R21
    G1 X-48.2 F3000
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0

    M1002 judge_last_extrude_cali_success
    M622 J0
        M983 F5 A0.3 H0.4; cali dynamic extrusion compensation
        M106 P1 S255
        M400 S5
        G1 X-28.5 F18000
        G1 X-48.2 F3000
        G1 X-28.5 F18000 ;wipe and shake
        G1 X-48.2 F3000
        G1 X-28.5 F12000 ;wipe and shake
        M400
        M106 P1 S0
    M623
    
M73 P6 R21
    G1 X-48.2 F3000
    M400
    M984 A0.1 E1 S1 F5 H0.4
    M106 P1 S178
    M400 S7
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
    G1 X-48.2 F3000
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0
M623 ; end of "draw extrinsic para cali paint"

;G392 S0
;===== auto extrude cali end ========================

;M400
;M73 P1.717

M104 S170 ; prepare to wipe nozzle
M106 S255 ; turn on fan

;===== mech mode fast check start =====================
M1002 gcode_claim_action : 3

G1 X128 Y128 F20000
G1 Z5 F1200
M400 P200
M970.3 Q1 A5 K0 O3
M974 Q1 S2 P0

M970.2 Q1 K1 W58 Z0.1
M974 S2

G1 X128 Y128 F20000
G1 Z5 F1200
M400 P200
M970.3 Q0 A10 K0 O1
M974 Q0 S2 P0

M970.2 Q0 K1 W78 Z0.1
M974 S2

M975 S1
G1 F30000
G1 X0 Y5
G28 X ; re-home XY

G1 Z4 F1200

;===== mech mode fast check end =======================

;M400
;M73 P1.717

;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14

M975 S1
M106 S255 ; turn on fan (G28 has turn off fan)
M211 S; push soft endstop status
M211 X0 Y0 Z0 ;turn off Z axis endstop

;===== remove waste by touching start =====

M104 S170 ; set temp down to heatbed acceptable

M83
G1 E-1 F500
G90
M83

M109 S170
G0 X108 Y-0.5 F30000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X110 F10000
G380 S3 Z-5 F1200
M73 P25 R16
G1 Z2 F1200
G1 X112 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X114 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X116 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X118 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X120 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X122 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X124 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X126 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X128 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X130 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X132 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X134 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X136 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X138 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X140 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X142 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X144 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X146 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X148 F10000
G380 S3 Z-5 F1200

G1 Z5 F30000
;===== remove waste by touching end =====

G1 Z10 F1200
G0 X118 Y261 F30000
G1 Z5 F1200
M109 S170

G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
M104 S140 ; prepare to abl
G0 Z5 F20000

G0 X128 Y261 F20000  ; move to exposed steel surface
G0 Z-1.01 F1200      ; stop the nozzle

G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

G90
G1 Z10 F1200

;===== brush material wipe nozzle =====

G90
G1 Y250 F30000
G1 X55
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X-35 F30000
G1 Y-0.5
G1 X45
M73 P26 R16
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Z5.000 F1200

G90
G1 X30 Y250.000 F30000
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X35 F30000
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Z10.000 F1200

;===== brush material wipe nozzle end =====

G90
;G0 X128 Y261 F20000  ; move to exposed steel surface
G1 Y250 F30000
G1 X138
G1 Y261
G0 Z-1.01 F1200      ; stop the nozzle

G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

M109 S140
M106 S255 ; turn on fan (G28 has turn off fan)

M211 R; pop softend status

;===== wipe nozzle end ================================

;M400
;M73 P1.717

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag

G90
G1 Z5 F1200
G1 X0 Y0 F30000
G29.2 S1 ; turn on ABL

M190 S75; ensure bed temp
M109 S140
M106 S0 ; turn off fan , too noisy

M622 J1
    M1002 gcode_claim_action : 1
    G29 A1 X11.5397 Y117.246 I120.864 J127.714
    M400
    M500 ; save cali data
M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623

;===== home after wipe mouth end =======================

;M400
;M73 P1.717

G1 X108.000 Y-0.500 F30000
G1 Z0.300 F1200
M400
G2814 Z0.32

M104 S220 ; prepare to print

;===== nozzle load line ===============================
;G90
;M83
;G1 Z5 F1200
;G1 X88 Y-0.5 F20000
;G1 Z0.3 F1200

;M109 S220

;G1 E2 F300
;G1 X168 E4.989 F6000
;G1 Z1 F1200
;===== nozzle load line end ===========================

;===== extrude cali test ===============================

M400
    M900 S
    M900 C
    G90
    M83

    M109 S220
    G0 X128 E8  F720
    G0 X133 E.3742  F1200
    G0 X138 E.3742  F4800
    G0 X143 E.3742  F1200
    G0 X148 E.3742  F4800
    G0 X153 E.3742  F1200
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400

M900 R

M1002 judge_flag extrude_cali_flag
M622 J1
    G90
    G1 X108.000 Y1.000 F30000
    G91
    G1 Z-0.700 F1200
    G90
    M83
    G0 X128 E10  F720
    G0 X133 E.3742  F1200
    G0 X138 E.3742  F4800
    G0 X143 E.3742  F1200
    G0 X148 E.3742  F4800
    G0 X153 E.3742  F1200
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400
M623

G1 Z0.2

;M400
;M73 P1.717

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.02 ; for Textured PEI Plate


M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000

M211 X0 Y0 Z0 ;turn off soft endstop
;G392 S1 ; turn on clog detection
M1007 S1 ; turn on mass estimation
G29.4
G90
G21
M83 ; use relative distances for extrusion
;===== A1 20240913 =======================
M1007 S0 ; turn off mass estimation
G392 S0
M620 S1A
M204 S9000

G1 Z3 F1200

M400
M106 P1 S0
M106 P2 S0

M104 S220


G1 X267 F18000


M620.11 S0

M400

M620.1 E F299 T240
M620.10 A0 F299
T1
M620.1 E F299 T240
M620.10 A1 F299 L0 H0.4 T240

G1 Y128 F9000




M620.11 S0


M400
G92 E0
M628 S0















M629

M400
M106 P1 S60
M109 S220
G1 E6 F299 ;Compensate for filament spillage during waiting temperature
M400
G92 E0
G1 E-2 F1800
M400
M106 P1 S178
M400 S3
M73 P27 R16
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
G1 Z3 F3000
M106 P1 S0

M204 S500



M622.1 S0
M9833 F5 A0.3 ; cali dynamic extrusion compensation
M1002 judge_flag filament_need_cali_flag
M622 J1
  G92 E0
  G1 E-2 F1800
  M400
  
  M106 P1 S178
  M400 S4
  G1 X-38.2 F18000
  G1 X-48.2 F3000
  G1 X-38.2 F18000 ;wipe and shake
  G1 X-48.2 F3000
  G1 X-38.2 F12000 ;wipe and shake
  G1 X-48.2 F3000
  M400
  M106 P1 S0 
M623

M621 S1A
G392 S0

M1007 S1
;_FORCE_RESUME_FAN_SPEED
; filament start gcode
M106 P3 S255
;Prevent PLA from jamming


M981 S1 P20000 ;open spaghetti detector
G1 Z.18 F42000
; CHANGE_LAYER
; Z_HEIGHT: 0.18
; LAYER_HEIGHT: 0.18
; layer num/total_layer_count: 1/50
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S500
G1 E-.8 F1800
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z0.58 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z0.58
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623


G1 Z.98 F42000
G1 X49.5 Y241
G1 Z.18
G1 E.8 F1800
; LAYER_HEIGHT: 0,180000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1  X49.500 Y241.000
G1  X15.500  E1.1739
G1  Y221.500  E0.6733
G1  X49.500  E1.1739
G1  Y241.000  E0.6733
G1  X16.500 Y221.500  
;--------------------
; CP EMPTY GRID START
; layer #2
M73 P28 R16
G1  Y222.000  E0.0173
G1  X49.000  E1.1221
G1  Y222.500  E0.0173
G1  X16.000  E1.1394
G1  Y223.000  E0.0173
G1  X49.000  E1.1394
G1  Y223.500  E0.0173
G1  X16.000  E1.1394
G1  Y224.000  E0.0173
G1  X49.000  E1.1394
G1  Y224.500  E0.0173
G1  X16.000  E1.1394
G1  Y225.000  E0.0173
G1  X49.000  E1.1394
G1  Y225.500  E0.0173
G1  X16.000  E1.1394
G1  Y226.000  E0.0173
G1  X49.000  E1.1394
G1  Y226.500  E0.0173
G1  X16.000  E1.1394
G1  Y227.000  E0.0173
G1  X49.000  E1.1394
G1  Y227.500  E0.0173
G1  X16.000  E1.1394
G1  Y228.000  E0.0173
G1  X49.000  E1.1394
G1  Y228.500  E0.0173
G1  X16.000  E1.1394
G1  Y229.000  E0.0173
G1  X49.000  E1.1394
G1  Y229.500  E0.0173
M73 P29 R16
G1  X16.000  E1.1394
G1  Y230.000  E0.0173
G1  X49.000  E1.1394
G1  Y230.500  E0.0173
G1  X16.000  E1.1394
G1  Y231.000  E0.0173
M73 P29 R15
G1  X49.000  E1.1394
G1  Y231.500  E0.0173
G1  X16.000  E1.1394
G1  Y232.000  E0.0173
G1  X49.000  E1.1394
G1  Y232.500  E0.0173
G1  X16.000  E1.1394
G1  Y233.000  E0.0173
G1  X49.000  E1.1394
G1  Y233.500  E0.0173
G1  X16.000  E1.1394
G1  Y234.000  E0.0173
G1  X49.000  E1.1394
G1  Y234.500  E0.0173
G1  X16.000  E1.1394
G1  Y235.000  E0.0173
M73 P30 R15
G1  X49.000  E1.1394
G1  Y235.500  E0.0173
G1  X16.000  E1.1394
G1  Y236.000  E0.0173
G1  X49.000  E1.1394
G1  Y236.500  E0.0173
G1  X16.000  E1.1394
G1  Y237.000  E0.0173
G1  X49.000  E1.1394
G1  Y237.500  E0.0173
G1  X16.000  E1.1394
G1  Y238.000  E0.0173
G1  X49.000  E1.1394
G1  Y238.500  E0.0173
G1  X16.000  E1.1394
G1  Y239.000  E0.0173
G1  X49.000  E1.1394
G1  Y239.500  E0.0173
G1  X16.000  E1.1394
G1  Y240.000  E0.0173
G1  X49.000  E1.1394
G1  Y240.500  E0.0173
G1  X16.000  E1.1394
G1  Y241.000  E0.0173
; CP EMPTY GRID END
;------------------






M73 P31 R15
G1  X15.000 
G1  Y241.500 
G1  Y221.000  E0.7078
G1  X50.000  E1.2084
G1  Y241.500  E0.7078
G1  X15.000  E1.2084
G1  X14.539 
G1  Y241.961 
G1  Y220.539  E0.7397
G1  X50.461  E1.2403
G1  Y241.961  E0.7397
G1  X14.539  E1.2403
G1  X14.077 
G1  Y242.423 
G1  Y220.077  E0.7715
G1  X50.923  E1.2722
G1  Y242.423  E0.7715
G1  X14.077  E1.2722
G1  X13.616 
G1  Y242.884 
G1  Y219.616  E0.8034
G1  X51.384  E1.3040
G1  Y242.884  E0.8034
G1  X13.616  E1.3040
M73 P32 R15
G1  X13.155 
G1  Y243.345 
G1  Y219.155  E0.8352
G1  X51.845  E1.3359
G1  Y243.345  E0.8352
G1  X13.155  E1.3359
G1  X12.693 
G1  Y243.807 
G1  Y218.693  E0.8671
G1  X52.307  E1.3677
G1  Y243.807  E0.8671
G1  X12.693  E1.3677
G1  X12.232 
G1  Y244.268 
G1  Y218.232  E0.8990
G1  X52.768  E1.3996
G1  Y244.268  E0.8990
G1  X12.232  E1.3996
G1  X11.770 
G1  Y244.730 
G1  Y217.770  E0.9308
G1  X53.230  E1.4315
M73 P33 R15
G1  Y244.730  E0.9308
G1  X11.770  E1.4315
; WIPE_TOWER_END

; WIPE_START
G1 F33600
G1 X11.77 Y242.73 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X17.215 Y237.381 Z.58 F42000
G1 X128.173 Y128.374 Z.58
G1 Z.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44484
; LAYER_HEIGHT: 0.18
G1 X128.03 Y128.116 E.00878
G1 X128.134 Y127.874 E.00782
; LINE_WIDTH: 0.478125
G1 X128.293 Y127.703 E.00753
; LINE_WIDTH: 0.511409
G1 X128.451 Y127.531 E.00811
; LINE_WIDTH: 0.549203
M73 P33 R14
G1 X128.916 Y127.291 E.01958
; LINE_WIDTH: 0.573764
G1 X129.293 Y127.219 E.01505
G1 X129.774 Y127.28 E.01903
; LINE_WIDTH: 0.554619
G1 X130.188 Y127.486 E.0175
; LINE_WIDTH: 0.514938
G1 X130.469 Y127.776 E.01411
; LINE_WIDTH: 0.512022
G1 X130.613 Y128.063 E.01116
M73 P34 R14
G1 X130.729 Y128.536 E.01689
G1 X130.73 Y128.609 E.00255
G2 X130.344 Y128.134 I-2.432 J1.583 E.02129
; LINE_WIDTH: 0.541176
G1 X129.812 Y127.832 E.02257
; LINE_WIDTH: 0.573764
G1 X129.312 Y127.752 E.01986
G1 X129.082 Y127.774 E.00909
; LINE_WIDTH: 0.549203
G1 X128.824 Y127.889 E.01059
; LINE_WIDTH: 0.514391
G1 X128.565 Y128.004 E.00987
; LINE_WIDTH: 0.479579
G1 X128.216 Y128.333 E.01551
; WIPE_START
G1 X128.03 Y128.116 E-.10859
G1 X128.134 Y127.874 E-.09978
G1 X128.293 Y127.703 E-.08883
G1 X128.451 Y127.531 E-.08883
G1 X128.916 Y127.291 E-.19875
G1 X129.293 Y127.219 E-.14575
G1 X129.37 Y127.229 E-.02947
; WIPE_END
G1 E-.04
G1 X127.533 Y129.848 Z.58 F42000
G1 Z.18
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.669894
G2 X127.665 Y129.628 I-.2 J-.269 E.01218
; LINE_WIDTH: 0.633601
G1 X127.723 Y129.483 E.00683
; LINE_WIDTH: 0.597307
G1 X127.771 Y129.197 E.01189
; LINE_WIDTH: 0.566608
G1 X127.82 Y128.911 E.01123
; LINE_WIDTH: 0.535908
G1 X127.706 Y128.417 E.01849
; LINE_WIDTH: 0.499999
G1 X127.555 Y128.164 E.00996
G1 X127.614 Y127.953 E.00741
G1 X127.814 Y127.548 E.0153
G1 X128.088 Y127.221 E.01443
G1 X128.431 Y126.966 E.01448
G1 X128.827 Y126.796 E.01457
G1 X129.229 Y126.725 E.0138
G1 X129.73 Y126.762 E.01702
G3 X130.786 Y127.411 I-.47 J1.949 E.04264
G1 X131.016 Y127.78 E.01471
G1 X131.16 Y128.22 E.01566
; LINE_WIDTH: 0.503116
G1 X131.202 Y128.759 E.0184
; LINE_WIDTH: 0.545151
G1 X131.184 Y128.857 E.00371
; LINE_WIDTH: 0.587185
G1 X131.166 Y128.955 E.00402
; LINE_WIDTH: 0.62922
G1 X131.148 Y129.053 E.00433
; LINE_WIDTH: 0.671254
G1 X131.13 Y129.152 E.00463
G1 X131.152 Y129.597 E.02071
; LINE_WIDTH: 0.654774
G1 X131.199 Y130.524 E.04194
; LINE_WIDTH: 0.634214
G1 X131.228 Y131.734 E.05285
; LINE_WIDTH: 0.640713
G1 X131.262 Y132.731 E.04403
; LINE_WIDTH: 0.649318
G2 X131.38 Y134.007 I9.786 J-.257 E.05747
; LINE_WIDTH: 0.642635
G1 X131.512 Y134.577 E.0259
; LINE_WIDTH: 0.627253
G1 X131.83 Y135.424 E.03904
; LINE_WIDTH: 0.58647
G1 X132.023 Y135.888 E.02023
G1 X132.01 Y135.949 E.00249
G1 X131.919 Y136.005 E.0043
G1 X131.722 Y135.947 E.00825
G1 X131.449 Y135.67 E.01562
G1 X131.163 Y135.247 E.02054
; LINE_WIDTH: 0.627253
G3 X130.862 Y134.429 I3.011 J-1.572 E.03771
; LINE_WIDTH: 0.656303
G1 X130.715 Y133.662 E.03536
G1 X130.655 Y133.585 E.00443
G1 X130.682 Y133.56 E.00166
G1 X130.687 Y133.239 E.01452
; LINE_WIDTH: 0.641061
G1 X130.652 Y132.475 E.0338
; LINE_WIDTH: 0.644211
G1 X130.625 Y131.671 E.03572
G1 X130.57 Y131.589 E.00441
G1 X130.601 Y131.564 E.00173
G1 X130.628 Y131.424 E.00635
; LINE_WIDTH: 0.630943
G1 X130.617 Y130.503 E.04002
; LINE_WIDTH: 0.646339
G1 X130.572 Y130.03 E.02116
; LINE_WIDTH: 0.673041
G1 X130.526 Y129.558 E.02209
G1 X130.457 Y129.472 E.00512
G1 X130.491 Y129.437 E.00226
G1 X130.512 Y129.302 E.00636
; LINE_WIDTH: 0.664384
G1 X130.467 Y129.196 E.00529
; LINE_WIDTH: 0.624067
G1 X130.422 Y129.089 E.00495
; LINE_WIDTH: 0.58375
G1 X130.377 Y128.983 E.00461
; LINE_WIDTH: 0.543433
G1 X130.332 Y128.877 E.00427
; LINE_WIDTH: 0.503116
G1 X130.074 Y128.517 E.01508
; LINE_WIDTH: 0.499999
G1 X129.697 Y128.293 E.01486
G1 X129.276 Y128.24 E.01436
G1 X128.84 Y128.364 E.01532
G1 X128.505 Y128.647 E.01486
; LINE_WIDTH: 0.514764
G1 X128.396 Y128.828 E.00737
; LINE_WIDTH: 0.52535
G1 X128.279 Y129.14 E.01188
; LINE_WIDTH: 0.572897
G1 X128.267 Y129.328 E.0074
; LINE_WIDTH: 0.620444
G1 X128.254 Y129.517 E.00806
; LINE_WIDTH: 0.667991
G1 X128.242 Y129.705 E.00872
; LINE_WIDTH: 0.668992
G1 X128.305 Y129.785 E.00469
G2 X128.285 Y129.889 I.035 J.061 E.00559
; LINE_WIDTH: 0.636479
G1 X128.292 Y129.966 E.00336
; LINE_WIDTH: 0.603965
G1 X128.388 Y130.483 E.02182
; LINE_WIDTH: 0.561232
G2 X128.273 Y130.663 I.084 J.18 E.00864
; LINE_WIDTH: 0.51667
G1 X128.253 Y130.751 E.00314
; LINE_WIDTH: 0.472107
G1 X128.233 Y130.838 E.00285
; LINE_WIDTH: 0.427544
G1 X128.212 Y130.925 E.00256
; LINE_WIDTH: 0.426318
G1 X128.214 Y131.067 E.00403
; LINE_WIDTH: 0.469655
G1 X128.216 Y131.209 E.00448
; LINE_WIDTH: 0.512992
G1 X128.218 Y131.35 E.00493
; LINE_WIDTH: 0.556329
G1 X128.219 Y131.492 E.00538
; LINE_WIDTH: 0.596018
G1 X128.476 Y131.801 E.01641
G3 X128.58 Y132.217 I-1.135 J.505 E.01764
; LINE_WIDTH: 0.561793
G1 X128.636 Y132.506 E.01129
; LINE_WIDTH: 0.527567
G2 X128.528 Y132.698 I.109 J.188 E.0083
; LINE_WIDTH: 0.485457
G1 X128.502 Y132.806 E.00362
; LINE_WIDTH: 0.443346
G1 X128.476 Y132.913 E.00328
; LINE_WIDTH: 0.401235
G1 X128.45 Y133.02 E.00294
; LINE_WIDTH: 0.388678
G1 X128.461 Y133.177 E.00403
; LINE_WIDTH: 0.418232
G1 X128.472 Y133.334 E.00437
; LINE_WIDTH: 0.464696
G1 X128.486 Y133.394 E.00194
; LINE_WIDTH: 0.51116
G1 X128.5 Y133.455 E.00216
; LINE_WIDTH: 0.557624
G1 X128.514 Y133.515 E.00237
; LINE_WIDTH: 0.604087
G1 X128.528 Y133.576 E.00258
G1 X128.682 Y133.75 E.00965
; LINE_WIDTH: 0.596051
G1 X128.737 Y133.929 E.00763
; LINE_WIDTH: 0.569455
G1 X128.791 Y134.107 E.00727
; LINE_WIDTH: 0.542858
G1 X128.846 Y134.445 E.01265
; LINE_WIDTH: 0.513323
G1 X128.901 Y134.782 E.01191
; LINE_WIDTH: 0.521115
G1 X128.926 Y135.453 E.02375
; LINE_WIDTH: 0.556138
G1 X128.908 Y135.625 E.00657
; LINE_WIDTH: 0.59116
G1 X128.891 Y135.798 E.00702
; LINE_WIDTH: 0.626182
G3 X128.81 Y136.481 I-16.139 J-1.568 E.02963
; LINE_WIDTH: 0.62434
G1 X128.643 Y136.97 E.02222
; LINE_WIDTH: 0.633731
G1 X128.374 Y137.409 E.02247
; LINE_WIDTH: 0.637946
G1 X128.02 Y137.782 E.02259
G1 X127.597 Y138.074 E.02259
; LINE_WIDTH: 0.633033
G1 X127.121 Y138.269 E.02242
; LINE_WIDTH: 0.635935
G1 X126.614 Y138.356 E.02252
G1 X126.1 Y138.338 E.02253
; LINE_WIDTH: 0.629913
G1 X125.6 Y138.214 E.02234
; LINE_WIDTH: 0.61859
G1 X125.14 Y137.981 E.02193
; LINE_WIDTH: 0.618336
G1 X124.735 Y137.653 E.02216
; LINE_WIDTH: 0.612902
G1 X124.41 Y137.257 E.02158
; LINE_WIDTH: 0.600904
G1 X124.172 Y136.79 E.02162
; LINE_WIDTH: 0.592018
G1 X124.022 Y136.299 E.0208
; LINE_WIDTH: 0.573042
G1 X123.972 Y136.091 E.00842
; LINE_WIDTH: 0.536824
G1 X123.921 Y135.882 E.00785
; LINE_WIDTH: 0.500605
G1 X123.893 Y135.6 E.0096
; LINE_WIDTH: 0.458494
G1 X123.865 Y135.318 E.00873
; LINE_WIDTH: 0.439868
G1 X123.863 Y134.805 E.0151
; LINE_WIDTH: 0.475419
G1 X123.88 Y134.625 E.00578
; LINE_WIDTH: 0.510969
G1 X123.896 Y134.445 E.00625
; LINE_WIDTH: 0.546519
G2 X123.891 Y134.033 I-1.144 J-.193 E.01543
; LINE_WIDTH: 0.50822
G1 X123.87 Y133.801 E.00803
; LINE_WIDTH: 0.469921
G1 X123.851 Y133.532 E.00854
; LINE_WIDTH: 0.434305
G1 X123.831 Y133.263 E.00783
; LINE_WIDTH: 0.429693
G1 X123.843 Y132.756 E.01453
; LINE_WIDTH: 0.467797
G1 X123.861 Y132.594 E.00514
; LINE_WIDTH: 0.505901
G1 X123.879 Y132.431 E.0056
; LINE_WIDTH: 0.544005
G1 X123.897 Y132.269 E.00606
; LINE_WIDTH: 0.582109
G2 X123.889 Y131.904 I-.758 J-.166 E.0147
; LINE_WIDTH: 0.532807
G1 X123.863 Y131.701 E.00741
; LINE_WIDTH: 0.483504
G1 X123.837 Y131.498 E.00667
; LINE_WIDTH: 0.434201
G1 X123.83 Y130.643 E.02479
; LINE_WIDTH: 0.471717
G1 X123.849 Y130.462 E.00579
; LINE_WIDTH: 0.513427
G1 X123.869 Y130.281 E.00635
; LINE_WIDTH: 0.555136
G2 X123.864 Y129.911 I-.764 J-.174 E.01413
; LINE_WIDTH: 0.508355
G1 X123.839 Y129.723 E.00654
; LINE_WIDTH: 0.461573
G1 X123.815 Y129.535 E.00589
; LINE_WIDTH: 0.414792
G1 X123.79 Y129.347 E.00524
; LINE_WIDTH: 0.368095
G1 X123.786 Y128.796 E.01331
; LINE_WIDTH: 0.411598
G1 X123.812 Y128.604 E.00528
; LINE_WIDTH: 0.4551
G1 X123.837 Y128.413 E.0059
; LINE_WIDTH: 0.498602
G1 X123.862 Y128.222 E.00651
; LINE_WIDTH: 0.542104
G1 X123.887 Y128.03 E.00713
G1 X123.919 Y127.241 E.02915
; LINE_WIDTH: 0.505445
G1 X123.928 Y122.306 E.16896
; LINE_WIDTH: 0.496858
G1 X123.928 Y122.304 E.00008
; LINE_WIDTH: 0.500039
G1 X123.942 Y118.358 E.13353
; LINE_WIDTH: 0.499661
G1 X123.99 Y117.673 E.02322
; LINE_WIDTH: 0.470517
G1 X124.13 Y117.568 E.00553
G1 X124.324 Y117.64 E.00654
G1 X124.388 Y117.822 E.00613
; LINE_WIDTH: 0.500039
G1 X124.402 Y118.387 E.01909
G1 X124.386 Y122.306 E.13262
; LINE_WIDTH: 0.496858
G1 X124.386 Y122.307 E.00004
; LINE_WIDTH: 0.505445
G1 X124.386 Y127.242 E.16896
; LINE_WIDTH: 0.507695
G1 X124.387 Y127.349 E.00369
; LINE_WIDTH: 0.542104
G1 X124.393 Y128.127 E.02873
G1 X124.309 Y128.27 E.0061
; LINE_WIDTH: 0.507046
G1 X124.226 Y128.413 E.00568
; LINE_WIDTH: 0.471987
G1 X124.186 Y128.558 E.00477
; LINE_WIDTH: 0.437357
G1 X124.147 Y128.702 E.00439
; LINE_WIDTH: 0.402726
G1 X124.107 Y128.847 E.00401
; LINE_WIDTH: 0.368095
G1 X124.105 Y129.237 E.00943
; LINE_WIDTH: 0.408348
G1 X124.159 Y129.46 E.00622
; LINE_WIDTH: 0.457639
G1 X124.212 Y129.683 E.00705
; LINE_WIDTH: 0.506388
G1 X124.344 Y129.89 E.00841
; LINE_WIDTH: 0.555136
G1 X124.475 Y130.098 E.00929
G1 X124.441 Y130.128 E.00172
G1 X124.37 Y130.288 E.00665
; LINE_WIDTH: 0.520561
G1 X124.299 Y130.449 E.0062
; LINE_WIDTH: 0.485986
G1 X124.229 Y130.61 E.00576
; LINE_WIDTH: 0.451411
G1 X124.202 Y130.822 E.00648
; LINE_WIDTH: 0.425308
G1 X124.175 Y131.034 E.00607
; LINE_WIDTH: 0.434201
G1 X124.229 Y131.458 E.01239
; LINE_WIDTH: 0.483504
G1 X124.283 Y131.613 E.00536
; LINE_WIDTH: 0.532807
G1 X124.337 Y131.769 E.00596
; LINE_WIDTH: 0.582109
G1 X124.39 Y131.924 E.00655
G1 X124.568 Y132.092 E.00974
G2 X124.38 Y132.341 I.331 J.445 E.01262
; LINE_WIDTH: 0.544073
G1 X124.325 Y132.506 E.00643
; LINE_WIDTH: 0.505947
G1 X124.271 Y132.671 E.00595
; LINE_WIDTH: 0.46782
G1 X124.217 Y132.836 E.00546
; LINE_WIDTH: 0.429693
G1 X124.191 Y133.247 E.01181
; LINE_WIDTH: 0.424746
G1 X124.228 Y133.445 E.00572
; LINE_WIDTH: 0.450301
G1 X124.264 Y133.644 E.0061
; LINE_WIDTH: 0.487033
G1 X124.312 Y133.771 E.00445
; LINE_WIDTH: 0.523765
G1 X124.359 Y133.897 E.00482
; LINE_WIDTH: 0.560496
G1 X124.407 Y134.024 E.00518
; LINE_WIDTH: 0.567441
G1 X124.552 Y134.172 E.00801
G1 X124.411 Y134.316 E.0078
G1 X124.364 Y134.48 E.00663
; LINE_WIDTH: 0.5297
G1 X124.317 Y134.644 E.00615
; LINE_WIDTH: 0.491959
G1 X124.269 Y134.808 E.00568
; LINE_WIDTH: 0.454218
G1 X124.242 Y135.301 E.01505
; LINE_WIDTH: 0.458566
G1 X124.296 Y135.529 E.0072
; LINE_WIDTH: 0.500605
G1 X124.349 Y135.756 E.00792
; LINE_WIDTH: 0.549861
M73 P35 R14
G1 X124.457 Y135.963 E.00875
; LINE_WIDTH: 0.599116
G1 X124.565 Y136.17 E.0096
G1 X124.69 Y136.588 E.01792
; LINE_WIDTH: 0.596652
G1 X124.96 Y137.057 E.02216
; LINE_WIDTH: 0.608774
G1 X125.352 Y137.431 E.02267
; LINE_WIDTH: 0.618296
G1 X125.837 Y137.677 E.0231
; LINE_WIDTH: 0.622593
G1 X126.373 Y137.771 E.0233
; LINE_WIDTH: 0.632988
G1 X126.926 Y137.706 E.02427
G1 X127.414 Y137.491 E.02324
; LINE_WIDTH: 0.627279
G1 X127.801 Y137.173 E.02162
; LINE_WIDTH: 0.622721
G1 X128.09 Y136.759 E.02162
; LINE_WIDTH: 0.62434
G1 X128.244 Y136.325 E.01981
; LINE_WIDTH: 0.626048
G1 X128.288 Y135.914 E.01779
G1 X128.398 Y135.627 E.01323
; LINE_WIDTH: 0.583556
G1 X128.429 Y135.449 E.00724
; LINE_WIDTH: 0.546408
G1 X128.461 Y135.27 E.00675
; LINE_WIDTH: 0.509259
G1 X128.447 Y134.72 E.01902
; LINE_WIDTH: 0.523972
G1 X128.385 Y134.518 E.00751
; LINE_WIDTH: 0.558595
G1 X128.323 Y134.316 E.00805
; LINE_WIDTH: 0.593218
G1 X128.261 Y134.114 E.00858
; LINE_WIDTH: 0.604087
G1 X127.959 Y133.822 E.01743
G1 X128.056 Y133.642 E.00848
G1 X128.071 Y133.519 E.00515
; LINE_WIDTH: 0.554607
G1 X128.086 Y133.395 E.0047
; LINE_WIDTH: 0.505127
G1 X128.101 Y133.272 E.00425
; LINE_WIDTH: 0.455646
G1 X128.115 Y133.148 E.0038
; LINE_WIDTH: 0.406166
G1 X128.13 Y133.025 E.00335
; LINE_WIDTH: 0.399406
G1 X128.133 Y132.89 E.00358
; LINE_WIDTH: 0.442126
G1 X128.136 Y132.754 E.00401
; LINE_WIDTH: 0.484847
G1 X128.139 Y132.619 E.00443
; LINE_WIDTH: 0.527567
G1 X128.142 Y132.484 E.00485
; LINE_WIDTH: 0.561793
G1 X128.07 Y132.285 E.0081
; LINE_WIDTH: 0.596018
G1 X127.998 Y132.087 E.00863
G1 X127.694 Y131.807 E.01688
; LINE_WIDTH: 0.590874
G1 X127.789 Y131.609 E.00888
G1 X127.802 Y131.503 E.00431
; LINE_WIDTH: 0.547314
G1 X127.814 Y131.398 E.00397
; LINE_WIDTH: 0.503753
G1 X127.827 Y131.292 E.00363
; LINE_WIDTH: 0.460193
G1 X127.839 Y131.186 E.00329
; LINE_WIDTH: 0.416633
G1 X127.852 Y131.081 E.00295
; LINE_WIDTH: 0.420515
G1 X127.855 Y130.902 E.00501
; LINE_WIDTH: 0.467957
G1 X127.858 Y130.723 E.00563
; LINE_WIDTH: 0.515399
G1 X127.861 Y130.544 E.00625
; LINE_WIDTH: 0.55407
G1 X127.828 Y130.404 E.00546
; LINE_WIDTH: 0.592741
G1 X127.795 Y130.263 E.00586
; LINE_WIDTH: 0.631411
G1 X127.762 Y130.123 E.00627
; LINE_WIDTH: 0.669894
G1 X127.572 Y129.894 E.01376
; CHANGE_LAYER
; Z_HEIGHT: 0.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F1800
G1 X127.606 Y129.774 E-.04778
G1 X127.665 Y129.628 E-.05952
G1 X127.723 Y129.483 E-.05952
G1 X127.771 Y129.197 E-.11023
G1 X127.82 Y128.911 E-.11023
G1 X127.706 Y128.417 E-.19263
G1 X127.555 Y128.164 E-.11189
G1 X127.604 Y127.991 E-.06819
; WIPE_END
G1 E-.04
; layer num/total_layer_count: 2/50
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S198.9
M106 P2 S178
; open powerlost recovery
M1003 S1
M204 S6000
M140 S65 ; set bed temperature
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z0.78 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z0.78
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623


G1 X49.5 Y241 F42000
G1 Z1.18
G1 Z.38
G1 E.8 F1800
; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1  X49.500 Y241.000 F5400
G1  X15.500  E1.2922
G1  Y221.500  E0.7411
G1  X49.500  E1.2922
G1  Y241.000  E0.7411
G1  X16.500 Y221.500  
;--------------------
; CP EMPTY GRID START
; layer #3
G1  Y241.000  E0.7411
G1  X24.500 
G1  Y221.500  E0.7411
G1  X32.500 
G1  Y241.000  E0.7411
G1  X40.500 
G1  Y221.500  E0.7411
G1  X48.500 
G1  Y241.000  E0.7411
; CP EMPTY GRID END
;------------------






G1  X50.000 
G1  Y241.500 
G1  X15.000  E1.3302
G1  Y221.000  E0.7791
G1  X50.000  E1.3302
G1  Y241.500  E0.7791
G1  X50.457 
G1  Y241.957 
G1  X14.543  E1.3650
G1  Y220.543  E0.8139
G1  X50.457  E1.3650
G1  Y241.957  E0.8139
G1  X50.914 
G1  Y242.414 
G1  X14.086  E1.3997
G1  Y220.086  E0.8486
G1  X50.914  E1.3997
G1  Y242.414  E0.8486
G1  X51.371 
G1  Y242.871 
G1  X13.629  E1.4345
G1  Y219.629  E0.8834
G1  X51.371  E1.4345
G1  Y242.871  E0.8834
G1  X51.828 
G1  Y243.328 
G1  X13.172  E1.4692
G1  Y219.172  E0.9181
G1  X51.828  E1.4692
G1  Y243.328  E0.9181
G1  X52.285 
G1  Y243.785 
G1  X12.715  E1.5039
G1  Y218.715  E0.9528
G1  X52.285  E1.5039
G1  Y243.785  E0.9528
; WIPE_TOWER_END

; WIPE_START
G1 F1800
G1 X50.285 Y243.785 E-.76
; WIPE_END
G1 E-.04
G1 X54.556 Y237.46 Z.78 F42000
G1 X128.13 Y128.48 Z.78
G1 Z.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.639667
; LAYER_HEIGHT: 0.2
G1 F6032.707
G1 X127.976 Y128.126 E.01881
G3 X128.151 Y127.739 I.773 J.118 E.02091
; LINE_WIDTH: 0.597549
G1 F6490.829
G1 X128.263 Y127.565 E.00934
; LINE_WIDTH: 0.555431
G1 F7024.248
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.513312
G1 F7653.191
G1 X128.567 Y127.255 E.00906
; LINE_WIDTH: 0.481656
G1 F8205.4
G1 X128.761 Y127.119 E.00845
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X129.271 Y126.999 E.01739
G1 X129.718 Y127.05 E.01491
G3 X130.788 Y127.964 I-.396 J1.547 E.04835
M73 P36 R14
G1 X130.919 Y128.476 E.01752
; LINE_WIDTH: 0.438148
G1 F9108.666
G1 X130.948 Y128.798 E.01041
; LINE_WIDTH: 0.408021
G1 F9860.285
G1 X130.975 Y129.233 E.01296
; LINE_WIDTH: 0.37992
G1 F10682.508
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351818
G1 F11654.332
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341233
G1 F12067.861
G1 X131.063 Y131.439 E.02188
; LINE_WIDTH: 0.388777
G1 F10108.282
G1 X131.042 Y131.506 E.00198
; LINE_WIDTH: 0.43632
G1 F9069.841
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483864
G1 F8164.311
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531407
G1 F7369.695
G1 X130.977 Y131.707 E.0028
; LINE_WIDTH: 0.578951
G1 F6716.036
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.626494
G1 F6168.884
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.578951
G1 F6716.036
G1 X130.877 Y131.707 E.00316
; LINE_WIDTH: 0.531407
G1 F7369.695
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483864
G1 F8164.311
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.43632
G1 F9095.04
G1 X130.793 Y131.507 E.00232
; LINE_WIDTH: 0.388777
G1 F10075.996
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.341233
G1 F12067.861
G1 X130.77 Y130.523 E.02231
; LINE_WIDTH: 0.350607
G1 F11700.221
G1 X130.712 Y130.026 E.01254
; LINE_WIDTH: 0.382174
G1 F10611.518
G3 X130.657 Y129.312 I2.704 J-.568 E.01987
; LINE_WIDTH: 0.397367
G1 F10156.667
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.42443
G1 F9436.188
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X130.284 Y128.337 E.01695
G1 X129.854 Y128.062 E.01696
G1 X129.312 Y127.964 E.01826
G1 X129.072 Y128.012 E.00811
; LINE_WIDTH: 0.497416
G1 F7920.861
G1 X128.961 Y128.025 E.00413
; LINE_WIDTH: 0.544833
G1 F7172.558
G1 X128.851 Y128.038 E.00456
; LINE_WIDTH: 0.59225
G1 F6553.438
G1 X128.74 Y128.051 E.005
; LINE_WIDTH: 0.639667
G1 F6032.707
G1 X128.629 Y128.065 E.00543
G1 X128.176 Y128.442 E.02864
; WIPE_START
G1 X127.976 Y128.126 E-.14233
G1 X128.04 Y127.913 E-.08435
G1 X128.151 Y127.739 E-.07853
G1 X128.263 Y127.565 E-.07853
G1 X128.374 Y127.391 E-.07853
G1 X128.567 Y127.255 E-.08986
G1 X128.761 Y127.119 E-.08986
G1 X129.063 Y127.048 E-.11801
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.547 Z.78 F42000
G1 Z.38
G1 E.8 F1800
; LINE_WIDTH: 0.360925
G1 F11320.576
G1 X128.141 Y129.811 E.00777
G1 X128.14 Y130.329 E.01344
G1 X127.752 Y129.822 E.01654
G1 X127.958 Y129.591 E.00803
G1 X128.354 Y129.443 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.531918
G1 F7361.993
G1 X128.386 Y129.506 E.00282
; LINE_WIDTH: 0.494612
G1 F7970.038
G1 X128.418 Y129.569 E.00261
; LINE_WIDTH: 0.457306
G1 F8687.565
G1 X128.449 Y129.63 E.0023
G1 X128.45 Y129.632 E.00009
; LINE_WIDTH: 0.419999
G1 F8901.62
G1 X128.465 Y129.64 E.00051
G1 F9547.071
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00167
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391126
G1 F10338.707
G1 X128.192 Y131.19 E.00978
; LINE_WIDTH: 0.429401
G1 F9314.822
G1 X128.206 Y131.272 E.00261
; LINE_WIDTH: 0.47441
G1 F8343.191
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519419
G1 F7555.114
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564428
G1 F6903.069
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609436
G1 F6354.631
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.628701
G1 F6145.642
G1 X128.535 Y131.815 E.0167
G1 X128.596 Y132.399 E.02803
G1 X128.468 Y132.596 E.01122
G1 X128.466 Y132.677 E.00385
; LINE_WIDTH: 0.584157
G1 F6651.439
G1 X128.464 Y132.751 E.00328
G1 X128.464 Y132.758 E.00027
; LINE_WIDTH: 0.539612
G1 F7247.958
G1 X128.463 Y132.804 E.0019
G1 X128.462 Y132.838 E.00136
; LINE_WIDTH: 0.495067
G1 F7479.812
G1 X128.462 Y132.858 E.00072
G1 F7962.012
G1 X128.461 Y132.919 E.00225
; LINE_WIDTH: 0.450523
G1 F8140.305
G1 X128.46 Y132.933 E.00048
G1 F8832.137
G1 X128.459 Y132.999 E.0022
; LINE_WIDTH: 0.405978
G1 F9913.596
G1 X128.457 Y133.08 E.00239
; LINE_WIDTH: 0.404099
G1 F9967.381
G1 X128.466 Y133.165 E.00252
; LINE_WIDTH: 0.446764
G1 F8914.348
G1 X128.475 Y133.25 E.00281
; LINE_WIDTH: 0.489429
G1 F8062.556
G1 X128.482 Y133.327 E.00283
G1 F7453.147
G1 X128.483 Y133.335 E.00029
; LINE_WIDTH: 0.532094
G1 F7359.35
G1 X128.489 Y133.389 E.00213
G1 X128.492 Y133.42 E.00128
; LINE_WIDTH: 0.574759
G1 F6768.968
G1 X128.493 Y133.427 E.00027
G1 X128.501 Y133.505 E.00344
; LINE_WIDTH: 0.617424
G1 F6266.275
G1 X128.509 Y133.591 E.004
; LINE_WIDTH: 0.63524
G1 F6077.796
G1 X128.726 Y133.776 E.01377
G2 X128.807 Y134.294 I2.048 J-.053 E.0254
; LINE_WIDTH: 0.588513
G1 F6598.325
G1 X128.847 Y134.455 E.00735
; LINE_WIDTH: 0.541786
G1 F7216.366
G1 X128.886 Y134.615 E.00672
; LINE_WIDTH: 0.506928
G1 F7758.486
G2 X128.983 Y135.412 I4.466 J-.135 E.03039
; LINE_WIDTH: 0.463464
G1 F8560.352
G1 X129.032 Y135.684 E.00947
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.73 E.01698
G1 X127.906 Y138.099 E.0175
G1 X127.433 Y138.353 E.0165
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445317
G1 F8946.388
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 F8742.575
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 F8055.969
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 F7469.355
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559985
G1 F6962.375
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517857
G1 F7579.958
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475729
G1 F8317.77
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 F9214.702
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449174
G1 F8861.457
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.492971
G1 F7999.102
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536768
G1 F7289.704
G1 X123.893 Y132.382 E.00837
; LINE_WIDTH: 0.580564
G1 F6695.881
G2 X123.905 Y132.007 I-1.257 J-.227 E.01648
; LINE_WIDTH: 0.566568
G1 F6874.847
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523626
G1 F7488.994
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480683
G1 F8223.634
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.43774
G1 F9118.079
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 F8318.295
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 F7591.893
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558519
G1 F6982.17
G2 X123.864 Y129.986 I-.603 J-.154 E.01351
; LINE_WIDTH: 0.517616
G1 F7583.8
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.476713
G1 F8298.889
G1 X123.82 Y129.689 E.00531
; LINE_WIDTH: 0.43581
G1 F9162.87
G1 X123.8 Y129.383 E.00981
; LINE_WIDTH: 0.395628
G1 F10206.742
G1 X123.78 Y129.078 E.0088
; LINE_WIDTH: 0.402722
G1 F10005.503
G1 X123.803 Y128.571 E.01486
; LINE_WIDTH: 0.44679
G1 F8913.76
G1 X123.825 Y128.425 E.00487
; LINE_WIDTH: 0.490858
G1 F8036.826
G1 X123.847 Y128.279 E.0054
; LINE_WIDTH: 0.534926
G1 F7316.984
G1 X123.869 Y128.132 E.00594
; LINE_WIDTH: 0.578994
G1 F6715.491
G1 X123.891 Y127.986 E.00647
G1 X123.886 Y125.054 E.12806
; LINE_WIDTH: 0.573605
G1 F6783.685
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X123.913 Y119.844 E.12893
; LINE_WIDTH: 0.540006
G1 F7242.208
G1 X123.936 Y117.891 E.07913
; LINE_WIDTH: 0.52265
G1 F7504.221
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.248 Y117.532 E.00656
G1 X124.387 Y117.645 E.007
G1 X124.412 Y117.894 E.00976
; LINE_WIDTH: 0.540006
G1 F7242.208
G1 X124.41 Y119.846 E.07906
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X124.412 Y122.885 E.12887
; LINE_WIDTH: 0.573605
G1 F6783.685
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578994
G1 F6715.491
G2 X124.427 Y128.102 I1658.562 J-4.308 E.13318
G2 X124.291 Y128.3 I.154 J.251 E.01083
; LINE_WIDTH: 0.534926
G1 F7316.984
G1 X124.241 Y128.419 E.00517
; LINE_WIDTH: 0.490858
G1 F8036.826
G1 X124.191 Y128.538 E.0047
; LINE_WIDTH: 0.44679
G1 F8913.76
G1 X124.141 Y128.657 E.00424
; LINE_WIDTH: 0.402722
G1 F10005.503
G1 X124.093 Y129.054 E.01173
; LINE_WIDTH: 0.386049
G1 F10491.68
G1 X124.136 Y129.427 E.01049
; LINE_WIDTH: 0.426
G1 F9397.521
G1 X124.177 Y129.54 E.00377
; LINE_WIDTH: 0.465951
G1 F8510.025
G1 X124.217 Y129.654 E.00416
; LINE_WIDTH: 0.505902
G1 F7775.692
G1 X124.258 Y129.767 E.00455
; LINE_WIDTH: 0.545852
G1 F7158.025
G1 X124.299 Y129.881 E.00495
; LINE_WIDTH: 0.564785
G1 F6898.336
G1 X124.528 Y130.101 E.01352
G2 X124.358 Y130.326 I.158 J.295 E.01236
; LINE_WIDTH: 0.529841
G1 F7393.406
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.494896
G1 F7965.031
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 F8632.452
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 F9263.882
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.43774
G1 F9118.079
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480683
G1 F8223.634
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523626
G1 F7488.994
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 F6874.847
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.60144
G1 F6445.606
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.257 J.427 E.01605
; LINE_WIDTH: 0.560146
G1 F6960.207
G1 X124.33 Y132.505 E.00614
; LINE_WIDTH: 0.518852
G1 F7564.106
G1 X124.265 Y132.635 E.00565
; LINE_WIDTH: 0.477558
G1 F8282.755
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441468
G1 F9032.8
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 F9634.015
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464393
G1 F8541.485
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512189
G1 F7671.511
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559985
G1 F6962.375
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 F6592.61
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 F7050.482
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 F7576.703
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 F8187.81
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 F8817.759
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445317
G1 F8946.388
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.781 E.01295
G1 X128.209 Y135.663 E.00458
; LINE_WIDTH: 0.450562
G1 F8831.278
G1 X128.328 Y135.431 E.00866
; LINE_WIDTH: 0.481125
G1 F8215.333
G1 X128.448 Y135.199 E.00931
; LINE_WIDTH: 0.489445
G1 F8062.258
G1 X128.458 Y134.786 E.01503
; LINE_WIDTH: 0.538044
G1 F7270.915
G1 X128.425 Y134.624 E.00669
; LINE_WIDTH: 0.586642
G1 F6621.035
G1 X128.392 Y134.461 E.00734
; LINE_WIDTH: 0.63524
G1 F6077.796
G1 X128.359 Y134.299 E.008
G1 X128.143 Y134.035 E.01645
; LINE_WIDTH: 0.621854
G1 F6218.325
G1 X127.902 Y133.865 E.01392
; LINE_WIDTH: 0.617424
G1 F6266.275
G1 X128.059 Y133.633 E.01312
G1 X128.073 Y133.533 E.00476
; LINE_WIDTH: 0.568208
G1 F6853.391
G1 X128.085 Y133.445 E.0038
G1 X128.086 Y133.432 E.00055
; LINE_WIDTH: 0.518991
G1 F7561.9
G1 X128.095 Y133.364 E.00264
G1 X128.1 Y133.331 E.0013
; LINE_WIDTH: 0.469775
G1 F8433.793
G1 X128.109 Y133.26 E.00248
G1 X128.113 Y133.23 E.00105
; LINE_WIDTH: 0.420558
G1 F9532.949
G1 X128.127 Y133.13 E.00313
; LINE_WIDTH: 0.414235
G1 F9695.29
G1 X128.145 Y133.038 E.00282
; LINE_WIDTH: 0.457128
G1 F8691.292
G1 X128.149 Y133.013 E.00085
G1 X128.162 Y132.947 E.00229
; LINE_WIDTH: 0.500021
G1 F7875.721
G1 X128.166 Y132.93 E.00064
G1 X128.18 Y132.855 E.00283
; LINE_WIDTH: 0.542915
G1 F7200.081
G1 X128.182 Y132.846 E.00037
G1 X128.198 Y132.764 E.00343
; LINE_WIDTH: 0.585808
G1 F6631.206
G1 X128.216 Y132.672 E.00412
; LINE_WIDTH: 0.628701
G1 F6145.642
G1 X128.233 Y132.581 E.00445
G1 X128.073 Y132.231 E.01837
G1 X127.872 Y132.013 E.01413
; LINE_WIDTH: 0.609436
G1 F6354.631
G1 X127.633 Y131.826 E.01403
G1 X127.761 Y131.69 E.00863
G1 X127.778 Y131.622 E.00322
; LINE_WIDTH: 0.582189
G1 F6675.71
G1 X127.795 Y131.555 E.00306
; LINE_WIDTH: 0.554941
G1 F7030.962
G1 X127.81 Y131.428 E.00533
G1 X127.814 Y131.39 E.00159
; LINE_WIDTH: 0.510478
G1 F7468.078
G1 X127.818 Y131.353 E.00141
G1 F7699.588
G1 X127.833 Y131.225 E.00491
; LINE_WIDTH: 0.466014
G1 F8508.747
G1 X127.851 Y131.06 E.00572
; LINE_WIDTH: 0.421551
G1 F8837.92
G1 X127.854 Y131.034 E.00079
G1 F9507.95
G1 X127.87 Y130.895 E.00433
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.789 Y130.449 E.01392
G1 X127.559 Y130.113 E.01254
G1 X127.283 Y129.906 E.01059
G1 X127.303 Y129.795 E.00348
; LINE_WIDTH: 0.467422
G1 F8480.525
G1 X127.411 Y129.662 E.00592
G1 F7708.081
G1 X127.415 Y129.656 E.00023
; LINE_WIDTH: 0.514845
G1 F7628.33
G1 X127.527 Y129.518 E.00684
; LINE_WIDTH: 0.562268
G1 F6931.768
G1 X127.602 Y129.424 E.00511
G1 X127.638 Y129.38 E.00242
; LINE_WIDTH: 0.609691
G1 F6351.772
G1 X127.64 Y129.377 E.00013
G1 X127.75 Y129.241 E.00808
; LINE_WIDTH: 0.61446
G1 F6298.772
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 F6745.291
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538792
G1 F7259.948
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500957
G1 F7859.627
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 F8621.557
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.722 Y127.48 E.01583
G1 X128.003 Y127.143 E.0135
G1 X128.365 Y126.872 E.01388
G1 X128.801 Y126.685 E.01458
G1 X129.231 Y126.609 E.01341
G1 X129.693 Y126.636 E.01422
G1 X130.15 Y126.778 E.01472
G1 X130.503 Y126.985 E.01257
G1 X130.873 Y127.338 E.0157
G1 X131.116 Y127.724 E.01403
G1 X131.209 Y127.978 E.00831
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.057 J-2.285 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00163
G1 X130.307 Y133.638 E.00462
G1 X130.446 Y133.509 E.00583
G1 X130.472 Y133.485 E.00107
G1 X130.508 Y133.375 E.00355
G3 X130.452 Y131.818 I27.169 J-1.755 E.04788
G1 X130.408 Y131.713 E.00352
G1 X130.361 Y131.686 E.00165
G1 X130.229 Y131.612 E.00466
G1 X130.378 Y131.493 E.00584
G1 X130.406 Y131.471 E.0011
G1 X130.447 Y131.361 E.00363
G1 X130.443 Y130.518 E.02588
G1 X130.318 Y129.635 E.02741
G1 X130.301 Y129.627 E.00059
G1 X130.251 Y129.602 E.00169
G1 X130.094 Y129.524 E.00539
G2 X130.306 Y129.332 I-.156 J-.386 E.00898
G1 X130.224 Y128.918 E.01298
G1 X129.994 Y128.599 E.01207
G1 X129.688 Y128.417 E.01095
G1 X129.274 Y128.354 E.01288
G1 X128.892 Y128.467 E.01224
G1 X128.717 Y128.606 E.00688
; LINE_WIDTH: 0.466196
G1 F8505.094
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 F7668.18
G1 X128.547 Y128.795 E.00441
G1 F7255.072
G1 X128.531 Y128.812 E.0009
; LINE_WIDTH: 0.55859
G1 F6981.22
G1 X128.49 Y128.858 E.00259
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604786
G1 F6407.222
G1 X128.437 Y128.916 E.00003
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 F6459.068
G1 X128.336 Y129.283 E.00733
; LINE_WIDTH: 0.566097
G1 F6881.036
G1 X128.347 Y129.383 E.00433
M204 S6000
; WIPE_START
G1 X128.354 Y129.443 E-.02282
G1 X128.386 Y129.506 E-.02689
G1 X128.418 Y129.569 E-.02691
G1 X128.449 Y129.63 E-.02594
G1 X128.45 Y129.632 E-.00097
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.019
G1 X128.665 Y129.736 E-.06527
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02059
G1 X128.463 Y129.933 E-.01702
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.026 E-.06823
; WIPE_END
G1 E-.04 F1800
G1 X130.933 Y131.841 Z.78 F42000
G1 Z.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.630496
G1 F6126.867
G1 X130.951 Y132.465 E.02988
; LINE_WIDTH: 0.646516
G1 F5964.255
G1 X130.995 Y133.338 E.043
; LINE_WIDTH: 0.648174
G1 F5947.916
G1 X131.045 Y133.849 E.02533
G1 X131.218 Y134.637 E.03979
; LINE_WIDTH: 0.601268
G1 F6447.592
G1 X131.31 Y134.865 E.01118
; LINE_WIDTH: 0.573201
G1 F6788.854
G1 X131.401 Y135.093 E.01062
; WIPE_START
G1 X131.31 Y134.865 E-.09339
G1 X131.218 Y134.637 E-.09339
G1 X131.045 Y133.849 E-.30657
G1 X130.995 Y133.338 E-.19513
G1 X130.985 Y133.15 E-.07152
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z.78 F42000
G1 Z.38
G1 E.8 F1800
; LINE_WIDTH: 0.5305
G1 F7383.404
G1 X124.46 Y136.735 E.01599
; LINE_WIDTH: 0.54767
G1 F7132.243
G1 X124.716 Y137.195 E.02164
; LINE_WIDTH: 0.580034
G1 F6702.487
G1 X125.093 Y137.589 E.02389
; LINE_WIDTH: 0.601592
G1 F6443.853
G1 X125.476 Y137.831 E.02058
; LINE_WIDTH: 0.612736
G1 F6317.829
G1 X125.897 Y137.99 E.02094
; LINE_WIDTH: 0.61663
G1 F6274.947
G1 X126.343 Y138.061 E.02108
G1 X126.866 Y138.018 E.02453
; LINE_WIDTH: 0.613206
G1 F6312.623
G1 X127.431 Y137.815 E.0279
; LINE_WIDTH: 0.614712
G1 F6295.996
G1 X127.944 Y137.445 E.02947
; LINE_WIDTH: 0.625278
G1 F6181.765
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.62131
G1 F6224.174
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599714
G1 F6465.587
G1 X128.571 Y135.93 E.01203
; WIPE_START
G1 X128.562 Y136.195 E-.10079
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19507
G1 X127.684 Y137.632 E-.12144
; WIPE_END
G1 E-.04 F1800
G1 X128.664 Y130.062 Z.78 F42000
G1 X128.989 Y127.548 Z.78
G1 Z.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.591106
G1 F6567.114
G1 X129.362 Y127.484 E.01691
; LINE_WIDTH: 0.587526
G1 F6610.29
G1 X129.619 Y127.538 E.01168
; LINE_WIDTH: 0.557025
G1 F7002.468
G1 X129.877 Y127.592 E.01102
; LINE_WIDTH: 0.527831
G1 F7424.05
G1 X129.969 Y127.643 E.00418
; LINE_WIDTH: 0.499944
G1 F7877.057
G1 X130.062 Y127.695 E.00394
; CHANGE_LAYER
; Z_HEIGHT: 0.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7877.057
G1 X129.969 Y127.643 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/50
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
M106 S158.1
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z0.98 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z0.98
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    
      M400
      G90
      M83
      M204 S5000
      G0 Z2 F4000
      G0 X261 Y250 F20000
      M400 P200
      G39 S1
      G0 Z2 F4000
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623


; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
;--------------------
; CP TOOLCHANGE START
; toolchange #1
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; filament end gcode 
M106 P3 S0

G1 E-1.2 F1800
;===== A1 20240913 =======================
M1007 S0 ; turn off mass estimation
G392 S0
M620 S3A
M204 S9000

G17
G2 Z0.98 I0.86 J0.86 P1 F10000 ; spiral lift a little from second lift

G1 Z3.58 F1200

M400
M106 P1 S0
M106 P2 S0

M104 S220


G1 X267 F18000


M620.11 S0

M400

M620.1 E F299 T240
M620.10 A0 F299
T3
M620.1 E F299 T240
M620.10 A1 F299 L148.008 H0.4 T240

G1 Y128 F9000




M620.11 S0


M400
G92 E0
M628 S0


; FLUSH_START
; always use highest temperature to flush
M400
M1002 set_filament_type:UNKNOWN
M109 S240
M106 P1 S60

G1 E23.7 F299 ; do not need pulsatile flushing for start part
G1 E0.512717 F50
G1 E5.89625 F299
G1 E0.512717 F50
G1 E5.89625 F299
G1 E0.512717 F50
G1 E5.89625 F299
G1 E0.512717 F50
G1 E5.89625 F299

; FLUSH_END
G1 E-2 F1800
G1 E2 F300
M400
M1002 set_filament_type:PLA



; WIPE
M400
M106 P1 S178
M400 S3
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
M106 P1 S0



M106 P1 S60
; FLUSH_START
G1 E8.88046 F299
G1 E0.986717 F50
G1 E8.88046 F299
G1 E0.986717 F50
G1 E8.88046 F299
G1 E0.986717 F50
G1 E8.88046 F299
M73 P40 R13
G1 E0.986717 F50
G1 E8.88046 F299
G1 E0.986717 F50
; FLUSH_END
G1 E-2 F1800
G1 E2 F300



; WIPE
M400
M106 P1 S178
M400 S3
M73 P41 R13
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
M106 P1 S0



M106 P1 S60
; FLUSH_START
G1 E8.88046 F299
G1 E0.986717 F50
G1 E8.88046 F299
G1 E0.986717 F50
G1 E8.88046 F299
M73 P42 R13
G1 E0.986717 F50
G1 E8.88046 F299
G1 E0.986717 F50
G1 E8.88046 F299
G1 E0.986717 F50
; FLUSH_END
G1 E-2 F1800
G1 E2 F300






M629

M400
M106 P1 S60
M109 S220
G1 E6 F299 ;Compensate for filament spillage during waiting temperature
M400
G92 E0
G1 E-2 F1800
M400
M106 P1 S178
M400 S3
M73 P42 R12
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M73 P43 R12
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
G1 Z3.58
M106 P1 S0

M204 S6000



M622.1 S0
M9833 F5 A0.3 ; cali dynamic extrusion compensation
M1002 judge_flag filament_need_cali_flag
M622 J1
  G92 E0
  G1 E-2 F1800
  M400
  
  M106 P1 S178
  M400 S4
  G1 X-38.2 F18000
  G1 X-48.2 F3000
  G1 X-38.2 F18000 ;wipe and shake
  G1 X-48.2 F3000
  G1 X-38.2 F12000 ;wipe and shake
  G1 X-48.2 F3000
  M400
  M106 P1 S0 
M623

M621 S3A
G392 S0

M1007 S1
M106 S158.1
M106 P2 S178
G1 X50 Y241.5 F42000
G1 Z3.98
M73 P44 R12
G1 Z.58
G1 E2 F1800

; filament start gcode
M106 P3 S255
;Prevent PLA from jamming



G4 S0
G1  X15.000 Y241.500  E1.3302
G1  Y221.000  E0.7791
G1  X50.000  E1.3302
G1  Y241.500  E0.7791
G1  X15.000 Y221.000  
G1  X15.500 Y221.500  
; CP TOOLCHANGE WIPE
G1  X49.500  E1.2922 F1584
G1  Y222.833  E0.0507
G1  X15.500  E1.2922 F1800
M73 P45 R12
G1  Y224.167  E0.0507
G1  X49.500  E1.2922 F2198
G1  Y225.500  E0.0507
G1  X15.500  E1.2922 F4200
G1  Y226.833  E0.0507
G1  X49.500  E1.2922 F4250
G1  Y228.167  E0.0507
G1  X15.500  E1.2922 F4300
G1  Y229.500  E0.0507
G1  X49.500  E1.2922 F4350
G1  Y230.833  E0.0507
G1  X15.500  E1.2922 F4400
G1  Y232.167  E0.0507
G1  X49.500  E1.2922 F4450
G1  Y233.500  E0.0507
G1  X15.500  E1.2922 F4500
G1  Y234.833  E0.0507
G1  X49.500  E1.2922 F4550
G1  Y236.167  E0.0507
G1  X15.500  E1.2922 F4600
G1  Y237.500  E0.0507
G1  X49.500  E1.2922 F4650
G1  Y238.833  E0.0507
G1  X15.500  E1.2922 F4700
G1  Y240.167  E0.0507
G1  X49.500  E1.2922 F4750
; WIPE_TOWER_END
M220 R
G1 F42000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y241.000  
; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1 F5400
G1  X50.457 
G1  Y241.957 
G1  X14.543  E1.3650
G1  Y220.543  E0.8139
G1  X50.457  E1.3650
G1  Y241.957  E0.8139
G1  X50.914 
M73 P46 R12
G1  Y242.414 
G1  X14.086  E1.3997
G1  Y220.086  E0.8486
G1  X50.914  E1.3997
G1  Y242.414  E0.8486
G1  X51.371 
G1  Y242.871 
G1  X13.629  E1.4345
G1  Y219.629  E0.8834
G1  X51.371  E1.4345
G1  Y242.871  E0.8834
G1  X51.828 
G1  Y243.328 
G1  X13.172  E1.4692
G1  Y219.172  E0.9181
G1  X51.828  E1.4692
G1  Y243.328  E0.9181
; WIPE_TOWER_END

; WIPE_START
G1 F7877.057
G1 X49.828 Y243.328 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X54.128 Y237.022 Z.98 F42000
G1 X128.13 Y128.481 Z.98
G1 Z.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638774
; LAYER_HEIGHT: 0.2
G1 F6041.749
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 F6499.556
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 F7032.431
G1 X128.374 Y127.391 E.00864
; LINE_WIDTH: 0.512864
G1 F7660.487
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 F8209.591
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438165
G1 F9108.275
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 F9861.204
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.37991
G1 F10682.825
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351832
G1 F11653.803
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332812
G1 F12418.417
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.38176
G1 F10312.544
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430707
G1 F9214.284
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 F8243.004
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528602
G1 F7412.268
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 F6733.646
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 F6168.862
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.0031
; LINE_WIDTH: 0.587472
G1 F6610.939
G1 X130.868 Y131.728 E.0029
; LINE_WIDTH: 0.548448
G1 F7121.268
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509424
G1 F7716.975
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.4704
G1 F8421.446
G1 X130.799 Y131.497 E.00411
; LINE_WIDTH: 0.424538
G1 F8966.701
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378675
G1 F9529.045
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332812
G1 F12418.417
G1 X130.77 Y130.513 E.02132
; LINE_WIDTH: 0.350613
G1 F11699.974
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382246
G1 F10609.267
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 F10157.039
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 F9436.807
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 F7924.755
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544387
G1 F7178.944
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591581
G1 F6561.437
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638774
G1 F6041.749
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.789 Z.98 F42000
G1 Z.58
G1 E.8 F1800
; LINE_WIDTH: 0.360701
G1 F11328.556
G1 X128.125 Y129.854 E.00173
G1 X128.129 Y130.341 E.01263
G1 X127.755 Y129.822 E.01657
G1 X127.998 Y129.546 E.00953
G1 X128.111 Y129.737 E.00573
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F7378.304
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 F7982.775
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 F8695.127
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 F8909.497
G1 X128.465 Y129.64 E.00051
G1 F9547.071
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391222
G1 F10335.859
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429846
G1 F9304.12
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474698
G1 F8337.621
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519551
G1 F7553.025
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564403
G1 F6903.395
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609255
G1 F6356.661
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.628622
G1 F6146.471
G1 X128.535 Y131.815 E.0167
G3 X128.602 Y132.459 I-24.91 J2.905 E.0309
G1 X128.466 Y132.599 E.00934
G1 X128.464 Y132.678 E.00378
; LINE_WIDTH: 0.583994
G1 F6653.434
G1 X128.463 Y132.758 E.00349
; LINE_WIDTH: 0.539366
G1 F7251.544
G1 X128.462 Y132.813 E.00225
G1 X128.461 Y132.837 E.00095
; LINE_WIDTH: 0.494738
G1 F7583.956
G1 X128.461 Y132.865 E.00103
G1 F7967.81
G1 X128.46 Y132.916 E.00189
; LINE_WIDTH: 0.45011
G1 F8301.268
G1 X128.459 Y132.942 E.00089
G1 F8841.081
G1 X128.458 Y132.995 E.00174
; LINE_WIDTH: 0.405482
G1 F9902.005
G1 X128.457 Y133.074 E.00234
; LINE_WIDTH: 0.403648
G1 F9979.828
G1 X128.465 Y133.16 E.00254
; LINE_WIDTH: 0.446442
G1 F8921.461
G1 X128.474 Y133.246 E.00284
; LINE_WIDTH: 0.489235
G1 F8066.052
G1 X128.482 Y133.326 E.00294
G1 F7425.646
G1 X128.483 Y133.332 E.0002
; LINE_WIDTH: 0.532029
G1 F7360.327
G1 X128.488 Y133.385 E.00216
G1 X128.491 Y133.418 E.00128
; LINE_WIDTH: 0.574823
G1 F6768.16
G1 X128.492 Y133.424 E.00029
G1 X128.5 Y133.503 E.00345
; LINE_WIDTH: 0.617616
G1 F6264.182
G1 X128.508 Y133.589 E.00404
; LINE_WIDTH: 0.635311
G1 F6077.067
G1 X128.724 Y133.774 E.0137
G2 X128.807 Y134.297 I2.112 J-.068 E.02561
; LINE_WIDTH: 0.588663
G1 F6596.52
G1 X128.846 Y134.453 E.00719
; LINE_WIDTH: 0.542014
G1 F7213.075
G1 X128.886 Y134.61 E.00657
; LINE_WIDTH: 0.506522
G1 F7765.282
G2 X128.983 Y135.411 I4.565 J-.146 E.0305
; LINE_WIDTH: 0.463261
G1 F8564.485
G1 X129.032 Y135.684 E.00953
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 F8946.367
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 F8742.575
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489793
G1 F8055.987
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524888
G1 F7469.386
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559982
G1 F6962.415
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517854
G1 F7580
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475726
G1 F8317.814
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 F9214.75
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 F8861.097
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493005
G1 F7998.498
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536819
G1 F7288.944
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580633
G1 F6695.022
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566566
G1 F6874.874
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523624
G1 F7489.022
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 F8223.659
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 F8318.314
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 F7591.925
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G1 F6982.211
G2 X123.864 Y129.986 I-.603 J-.154 E.01351
; LINE_WIDTH: 0.517682
G1 F7582.757
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.476847
G1 F8296.334
G1 X123.82 Y129.689 E.00531
; LINE_WIDTH: 0.436012
G1 F9158.161
G1 X123.8 Y129.386 E.00973
; LINE_WIDTH: 0.395794
G1 F10201.956
G1 X123.78 Y129.083 E.00873
; LINE_WIDTH: 0.401079
G1 F10051.402
G1 X123.802 Y128.579 E.01471
; LINE_WIDTH: 0.445559
G1 F8941.023
G1 X123.824 Y128.431 E.00491
; LINE_WIDTH: 0.490038
G1 F8051.566
G1 X123.846 Y128.284 E.00545
; LINE_WIDTH: 0.534518
G1 F7323.063
G1 X123.869 Y128.136 E.00599
; LINE_WIDTH: 0.578997
G1 F6715.453
G1 X123.891 Y127.988 E.00653
G1 X123.886 Y125.054 E.12814
; LINE_WIDTH: 0.573605
G1 F6783.685
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 F7245.822
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 F7505.567
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 F7245.822
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573605
G1 F6783.685
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578997
G1 F6715.453
G2 X124.427 Y128.103 I1657.729 J-4.304 E.13322
G2 X124.292 Y128.302 I.159 J.254 E.01085
; LINE_WIDTH: 0.534518
G1 F7323.063
G1 X124.241 Y128.422 E.00522
; LINE_WIDTH: 0.490038
G1 F8051.566
G1 X124.191 Y128.542 E.00474
; LINE_WIDTH: 0.445559
G1 F8941.023
G1 X124.14 Y128.662 E.00427
; LINE_WIDTH: 0.401079
G1 F10051.402
G1 X124.093 Y129.06 E.01167
; LINE_WIDTH: 0.385416
G1 F10511.071
G1 X124.135 Y129.422 E.01019
; LINE_WIDTH: 0.425186
G1 F9417.544
G1 X124.175 Y129.536 E.00377
; LINE_WIDTH: 0.464955
G1 F8530.109
G1 X124.216 Y129.65 E.00416
; LINE_WIDTH: 0.504724
G1 F7795.52
G1 X124.257 Y129.764 E.00455
; LINE_WIDTH: 0.544493
G1 F7177.42
G1 X124.297 Y129.878 E.00494
; LINE_WIDTH: 0.564883
G1 F6897.041
G1 X124.528 Y130.101 E.01365
G2 X124.358 Y130.326 I.158 J.295 E.01236
; LINE_WIDTH: 0.529906
G1 F7392.415
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.494929
G1 F7964.454
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 F8632.452
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 F9263.882
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 F8223.659
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523624
G1 F7489.022
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566566
G1 F6874.874
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 F6445.56
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 F6960.118
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 F7563.957
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 F8282.526
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 F9032.675
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 F9634.015
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 F8541.506
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512187
G1 F7671.544
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559982
G1 F6962.415
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 F6592.622
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 F7050.492
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 F7576.709
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 F8187.81
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 F8817.759
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 F8946.367
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.805 Y137.552 E.01521
G1 X127.282 Y137.365 E.01573
G1 X127.676 Y137.043 E.01563
G1 X127.94 Y136.667 E.0141
G1 X128.099 Y136.202 E.01513
G1 X128.118 Y135.781 E.01295
G1 X128.282 Y135.566 E.00831
; LINE_WIDTH: 0.450575
G1 F8830.997
G1 X128.365 Y135.38 E.00675
; LINE_WIDTH: 0.481151
G1 F8214.846
G1 X128.448 Y135.195 E.00726
; LINE_WIDTH: 0.489652
G1 F8058.523
G1 X128.457 Y134.78 E.01511
; LINE_WIDTH: 0.538205
G1 F7268.542
G1 X128.426 Y134.621 E.00654
; LINE_WIDTH: 0.586758
G1 F6619.618
G1 X128.394 Y134.462 E.00718
; LINE_WIDTH: 0.635311
G1 F6077.067
G1 X128.362 Y134.303 E.00782
G1 X128.146 Y134.038 E.01653
; LINE_WIDTH: 0.62255
G1 F6210.858
G1 X127.903 Y133.866 E.01403
; LINE_WIDTH: 0.617616
G1 F6264.182
G1 X128.059 Y133.634 E.01309
G1 X128.073 Y133.532 E.0048
; LINE_WIDTH: 0.568233
G1 F6853.059
G1 X128.084 Y133.445 E.00378
G1 X128.086 Y133.431 E.00061
; LINE_WIDTH: 0.51885
G1 F7564.144
G1 X128.095 Y133.366 E.00251
G1 X128.1 Y133.329 E.00146
; LINE_WIDTH: 0.469467
G1 F8421.108
G1 X128.109 Y133.26 E.00241
G1 F8439.88
G1 X128.113 Y133.227 E.00116
; LINE_WIDTH: 0.420084
G1 F9544.941
G1 X128.127 Y133.126 E.00315
; LINE_WIDTH: 0.413687
G1 F9709.603
G1 X128.145 Y133.036 E.00278
; LINE_WIDTH: 0.456674
G1 F8700.823
G1 X128.149 Y133.012 E.0008
G1 X128.163 Y132.945 E.0023
; LINE_WIDTH: 0.499661
G1 F7881.928
G1 X128.166 Y132.93 E.00057
G1 X128.181 Y132.855 E.00285
; LINE_WIDTH: 0.542648
G1 F7203.919
G1 X128.182 Y132.848 E.00029
G1 X128.198 Y132.765 E.00345
; LINE_WIDTH: 0.585635
G1 F6633.316
G1 X128.216 Y132.675 E.00406
; LINE_WIDTH: 0.628622
G1 F6146.471
G1 X128.234 Y132.585 E.00439
G1 X128.067 Y132.223 E.01903
G1 X127.874 Y132.015 E.01358
; LINE_WIDTH: 0.609255
G1 F6356.661
G1 X127.632 Y131.826 E.01412
G1 X127.761 Y131.689 E.00866
G1 X127.779 Y131.621 E.00328
; LINE_WIDTH: 0.581761
G1 F6681.006
G1 X127.797 Y131.552 E.00312
; LINE_WIDTH: 0.554267
G1 F7040.229
G1 X127.812 Y131.419 E.00556
G1 X127.815 Y131.387 E.00134
; LINE_WIDTH: 0.509988
G1 F7587.172
G1 X127.821 Y131.341 E.00176
G1 F7707.67
G1 X127.834 Y131.222 E.00455
; LINE_WIDTH: 0.465708
G1 F8514.916
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 F8546.191
G1 X127.852 Y131.055 E.00008
G1 F8781.156
G1 X127.854 Y131.037 E.00056
G1 F9511.033
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 F9547.071
M73 P46 R11
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 F8480.516
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 F7628.314
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 F6931.748
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 F6351.749
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 F6298.772
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 F6745.296
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 F7259.958
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500956
G1 F7859.644
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 F8621.566
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.066 J-2.285 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G3 X132.064 Y136.129 I-.368 J.091 E.01181
G1 X131.869 Y136.169 E.0061
G1 X131.644 Y136.089 E.00734
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.818 I27.169 J-1.755 E.04788
G1 X130.408 Y131.712 E.00352
G1 X130.361 Y131.686 E.00164
G1 X130.229 Y131.612 E.00466
G1 X130.378 Y131.493 E.00584
G1 X130.406 Y131.471 E.00109
G1 X130.447 Y131.361 E.00363
G1 X130.443 Y130.518 E.02588
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466197
G1 F8505.084
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512394
G1 F7668.164
G1 X128.547 Y128.795 E.00443
G1 F7250.971
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558591
G1 F6981.198
G1 X128.49 Y128.858 E.0026
M73 P47 R11
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604788
G1 F6407.199
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 F6459.056
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 F6888.146
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06985
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z.98 F42000
G1 Z.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573198
G1 F6788.892
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601262
G1 F6447.662
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 F5947.916
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646518
G1 F5964.235
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 F6126.867
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 X130.951 Y132.465 E-.23722
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19058
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z.98 F42000
G1 Z.58
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F7384.04
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.54903
G1 F7113.078
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581118
G1 F6688.988
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583734
G1 F6656.633
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 F6453.88
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.62308
G1 F6205.185
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.621048
G1 F6226.995
G1 X127.974 Y137.416 E.03178
G1 X128.322 Y136.937 E.02787
; LINE_WIDTH: 0.601558
G1 F6444.245
G1 X128.534 Y136.351 E.0284
; LINE_WIDTH: 0.5854
G1 F6636.19
G1 X128.571 Y135.93 E.01867
; WIPE_START
G1 X128.534 Y136.351 E-.16052
G1 X128.322 Y136.937 E-.23706
G1 X127.974 Y137.416 E-.2248
G1 X127.682 Y137.631 E-.13761
; WIPE_END
G1 E-.04 F1800
G1 X128.661 Y130.061 Z.98 F42000
G1 X128.986 Y127.549 Z.98
G1 Z.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F6579.092
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 F6618.943
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 F6975.115
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 F7384.843
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500907
G1 F7860.485
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 0.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.485
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/50
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
M106 S201.45
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z1.18 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z1.18
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.18 F4000
            G39.3 S1
            G0 Z1.18 F4000
            G392 S0
          
        M623
    
    M623
M623


G1 X49.5 Y241 F42000
G1 Z1.58
G1 Z.78
G1 E.8 F1800
; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1  X49.500 Y241.000 F5400
G1  X15.500  E1.2922
G1  Y221.500  E0.7411
G1  X49.500  E1.2922
G1  Y241.000  E0.7411
G1  X16.500 Y221.500  
;--------------------
; CP EMPTY GRID START
; layer #5
G1  Y241.000  E0.7411
G1  X24.500 
G1  Y221.500  E0.7411
G1  X32.500 
G1  Y241.000  E0.7411
G1  X40.500 
G1  Y221.500  E0.7411
G1  X48.500 
G1  Y241.000  E0.7411
; CP EMPTY GRID END
;------------------






G1  X50.000 
G1  Y241.500 
G1  X15.000  E1.3302
G1  Y221.000  E0.7791
G1  X50.000  E1.3302
G1  Y241.500  E0.7791
G1  X50.457 
G1  Y241.957 
G1  X14.543  E1.3650
G1  Y220.543  E0.8139
G1  X50.457  E1.3650
G1  Y241.957  E0.8139
G1  X50.914 
G1  Y242.414 
G1  X14.086  E1.3997
G1  Y220.086  E0.8486
G1  X50.914  E1.3997
G1  Y242.414  E0.8486
G1  X51.371 
G1  Y242.871 
G1  X13.629  E1.4345
G1  Y219.629  E0.8834
G1  X51.371  E1.4345
G1  Y242.871  E0.8834
; WIPE_TOWER_END

; WIPE_START
G1 F7860.485
G1 X49.371 Y242.871 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X53.701 Y236.586 Z1.18 F42000
G1 X128.136 Y128.524 Z1.18
G1 Z.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638638
; LAYER_HEIGHT: 0.2
G1 F6043.128
G1 X127.975 Y128.126 E.02082
G3 X128.151 Y127.74 I.745 J.106 E.02086
; LINE_WIDTH: 0.598064
G1 F6484.808
G1 X128.263 Y127.566 E.00936
; LINE_WIDTH: 0.55749
G1 F6996.142
G1 X128.375 Y127.392 E.00868
; LINE_WIDTH: 0.516915
G1 F7595.016
G1 X128.566 Y127.256 E.00908
; LINE_WIDTH: 0.483457
G1 F8171.844
G1 X128.758 Y127.119 E.00844
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 F9108.298
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 F9861.204
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.37991
G1 F10682.81
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 F11653.768
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332811
G1 F12418.461
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 F10312.249
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430705
G1 F9213.991
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479652
G1 F8243.051
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528599
G1 F7412.313
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577546
G1 F6733.69
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626492
G1 F6168.905
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.0031
; LINE_WIDTH: 0.58748
G1 F6610.851
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548467
G1 F7121.006
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509454
G1 F7716.483
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470441
G1 F8420.639
G1 X130.799 Y131.497 E.00411
; LINE_WIDTH: 0.424565
G1 F8965.78
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378688
G1 F9528.017
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332811
G1 F12418.461
G1 X130.77 Y130.513 E.02132
; LINE_WIDTH: 0.350614
G1 F11699.953
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G1 F10609.235
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 F10157.039
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 F9436.807
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X130.285 Y128.338 E.01695
G1 X129.854 Y128.062 E.01698
G1 X129.312 Y127.964 E.01826
G1 X129.069 Y128.013 E.00821
; LINE_WIDTH: 0.49744
G1 F7920.456
G1 X128.961 Y128.024 E.00404
; LINE_WIDTH: 0.54488
G1 F7171.893
G1 X128.852 Y128.036 E.00446
; LINE_WIDTH: 0.59232
G1 F6552.606
G1 X128.744 Y128.048 E.00488
; LINE_WIDTH: 0.63976
G1 F6031.767
G1 X128.636 Y128.059 E.0053
G1 X128.414 Y128.241 E.01393
; LINE_WIDTH: 0.638638
G1 F6043.128
G1 X128.178 Y128.481 E.01635
; WIPE_START
G1 X127.975 Y128.126 E-.15531
G1 X128.038 Y127.914 E-.08412
G1 X128.151 Y127.74 E-.07863
G1 X128.263 Y127.566 E-.07863
G1 X128.375 Y127.392 E-.07863
G1 X128.566 Y127.256 E-.0893
G1 X128.758 Y127.119 E-.0893
G1 X129.029 Y127.055 E-.10607
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.55 Z1.18 F42000
G1 Z.78
G1 E.8 F1800
; LINE_WIDTH: 0.364601
G1 F11191.211
G1 X128.139 Y129.79 E.00729
G1 X128.122 Y129.858 E.00185
G1 X128.144 Y130.323 E.01221
G1 X127.756 Y129.817 E.01671
G1 X127.958 Y129.595 E.00787
G1 X128.353 Y129.439 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.533772
G1 F7334.186
G1 X128.354 Y129.44 E.00004
G1 X128.386 Y129.504 E.00285
; LINE_WIDTH: 0.495848
G1 F7948.289
G1 X128.418 Y129.568 E.00266
; LINE_WIDTH: 0.457924
G1 F8674.629
G1 X128.449 Y129.629 E.00233
G1 X128.45 Y129.632 E.00011
; LINE_WIDTH: 0.419999
G1 F8888.713
G1 X128.465 Y129.64 E.00051
G1 F9547.071
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 F10335.888
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429812
G1 F9304.937
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.47463
G1 F8338.935
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519449
G1 F7554.642
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564267
G1 F6905.196
G1 X128.246 Y131.518 E.00352
; LINE_WIDTH: 0.609085
G1 F6358.571
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.6286
G1 F6146.701
G1 X128.535 Y131.815 E.0167
G3 X128.602 Y132.459 I-24.803 J2.895 E.03091
G1 X128.477 Y132.578 E.00821
G1 X128.462 Y132.641 E.0031
; LINE_WIDTH: 0.598319
G1 F6481.832
G1 X128.447 Y132.704 E.00294
; LINE_WIDTH: 0.568037
G1 F6855.616
G1 X128.45 Y132.776 E.00307
; LINE_WIDTH: 0.526905
G1 F7438.254
G1 X128.452 Y132.848 E.00283
; LINE_WIDTH: 0.485773
G1 F8012.362
G1 X128.454 Y132.895 E.0017
G1 F8129.123
G1 X128.454 Y132.919 E.00089
; LINE_WIDTH: 0.44464
G1 F8946.728
G1 X128.457 Y132.983 E.00209
G1 F8961.47
G1 X128.457 Y132.991 E.00026
; LINE_WIDTH: 0.403508
G1 F9927.781
G1 X128.459 Y133.063 E.00211
; LINE_WIDTH: 0.40495
G1 F9943.945
G1 X128.467 Y133.15 E.00259
; LINE_WIDTH: 0.447524
G1 F8897.596
G1 X128.475 Y133.238 E.0029
; LINE_WIDTH: 0.490098
G1 F8050.486
G1 X128.484 Y133.325 E.0032
; LINE_WIDTH: 0.532673
G1 F7350.654
G1 X128.489 Y133.387 E.00246
G1 X128.492 Y133.413 E.00105
; LINE_WIDTH: 0.575247
G1 F6762.764
G1 X128.493 Y133.425 E.00053
G1 X128.5 Y133.501 E.00328
; LINE_WIDTH: 0.617821
G1 F6261.948
G1 X128.508 Y133.588 E.00412
; LINE_WIDTH: 0.635377
G1 F6076.391
G1 X128.722 Y133.773 E.01368
G2 X128.807 Y134.299 I2.138 J-.076 E.0258
; LINE_WIDTH: 0.588808
G1 F6594.76
G1 X128.846 Y134.452 E.00702
; LINE_WIDTH: 0.542239
G1 F7209.819
G1 X128.885 Y134.605 E.00642
; LINE_WIDTH: 0.506127
G1 F7771.903
G2 X128.982 Y135.409 I4.664 J-.157 E.0306
; LINE_WIDTH: 0.463063
G1 F8568.511
G1 X129.032 Y135.684 E.00958
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 F8946.367
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 F8742.575
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 F8055.969
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 F7469.355
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559985
G1 F6962.375
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 F7579.969
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 F8317.795
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 F9214.75
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.44919
G1 F8861.107
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493005
G1 F7998.498
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.53682
G1 F7288.935
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580634
G1 F6695.009
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566567
G1 F6874.86
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 F7489.011
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 F8223.653
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 F8318.314
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 F7591.925
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G1 F6982.211
G2 X123.864 Y129.986 I-.604 J-.155 E.01351
; LINE_WIDTH: 0.517745
G1 F7581.746
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.476974
G1 F8293.911
G1 X123.821 Y129.689 E.00531
; LINE_WIDTH: 0.436202
G1 F9153.737
G1 X123.8 Y129.388 E.00965
; LINE_WIDTH: 0.395951
G1 F10197.404
G1 X123.78 Y129.088 E.00867
; LINE_WIDTH: 0.400332
G1 F10072.409
G1 X123.802 Y128.584 E.0147
; LINE_WIDTH: 0.444999
G1 F8953.481
G1 X123.824 Y128.435 E.00493
; LINE_WIDTH: 0.489665
G1 F8058.298
G1 X123.846 Y128.286 E.00548
; LINE_WIDTH: 0.534331
G1 F7325.846
G1 X123.868 Y128.137 E.00603
; LINE_WIDTH: 0.578997
G1 F6715.453
G1 X123.891 Y127.988 E.00658
G1 X123.886 Y125.054 E.12815
; LINE_WIDTH: 0.573605
G1 F6783.685
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X123.913 Y119.884 E.12723
; LINE_WIDTH: 0.540358
G1 F7237.083
G1 X123.936 Y117.891 E.0808
; LINE_WIDTH: 0.522564
G1 F7505.567
M73 P48 R11
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01007
; LINE_WIDTH: 0.540358
G1 F7237.083
G1 X124.41 Y119.885 E.08074
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X124.412 Y122.885 E.12717
; LINE_WIDTH: 0.573605
G1 F6783.685
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578997
G1 F6715.453
G2 X124.427 Y128.103 I1663.939 J-4.326 E.13323
G2 X124.292 Y128.303 I.16 J.254 E.01088
; LINE_WIDTH: 0.534331
G1 F7325.846
G1 X124.241 Y128.424 E.00525
; LINE_WIDTH: 0.489665
G1 F8058.298
G1 X124.19 Y128.545 E.00478
; LINE_WIDTH: 0.444999
G1 F8953.481
G1 X124.139 Y128.666 E.0043
; LINE_WIDTH: 0.400332
G1 F10072.409
G1 X124.093 Y129.065 E.0117
; LINE_WIDTH: 0.38478
G1 F10530.627
G1 X124.134 Y129.418 E.0099
; LINE_WIDTH: 0.424386
G1 F9437.282
G1 X124.174 Y129.533 E.00377
; LINE_WIDTH: 0.463992
G1 F8549.616
G1 X124.215 Y129.647 E.00416
; LINE_WIDTH: 0.503598
G1 F7814.582
G1 X124.255 Y129.761 E.00455
; LINE_WIDTH: 0.543203
G1 F7195.927
G1 X124.296 Y129.875 E.00494
; LINE_WIDTH: 0.564973
G1 F6895.852
G1 X124.528 Y130.101 E.01378
G2 X124.358 Y130.326 I.157 J.295 E.01235
; LINE_WIDTH: 0.529966
G1 F7391.504
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.494959
G1 F7963.926
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 F8632.452
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 F9263.893
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 F8223.653
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 F7489.011
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566567
G1 F6874.86
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 F6445.56
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 F6960.122
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518861
G1 F7563.969
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477569
G1 F8282.545
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441472
G1 F9032.698
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 F9634.015
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464393
G1 F8541.485
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512189
G1 F7671.511
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559985
G1 F6962.375
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 F6592.61
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 F7050.478
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 F7576.693
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 F8187.791
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 F8817.748
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 F8946.367
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.805 Y137.552 E.01521
G1 X127.282 Y137.365 E.01573
G1 X127.682 Y137.034 E.01596
G1 X127.94 Y136.667 E.01378
G1 X128.099 Y136.202 E.01511
G1 X128.118 Y135.781 E.01295
G1 X128.283 Y135.564 E.00836
; LINE_WIDTH: 0.450584
G1 F8830.802
G1 X128.366 Y135.378 E.00678
; LINE_WIDTH: 0.481169
G1 F8214.508
G1 X128.449 Y135.191 E.00729
; LINE_WIDTH: 0.489862
G1 F8054.736
G1 X128.456 Y134.774 E.01519
; LINE_WIDTH: 0.538367
G1 F7266.165
G1 X128.426 Y134.619 E.0064
; LINE_WIDTH: 0.586872
G1 F6618.231
G1 X128.395 Y134.463 E.00702
; LINE_WIDTH: 0.635377
G1 F6076.391
G1 X128.364 Y134.308 E.00765
G1 X128.148 Y134.04 E.01661
; LINE_WIDTH: 0.623218
G1 F6203.709
G1 X127.905 Y133.867 E.01413
; LINE_WIDTH: 0.617821
G1 F6261.948
G1 X128.059 Y133.634 E.01307
G1 X128.071 Y133.541 E.00441
; LINE_WIDTH: 0.57016
G1 F6828.015
G1 X128.084 Y133.448 E.00404
; LINE_WIDTH: 0.522499
G1 F7506.597
G1 X128.093 Y133.376 E.00283
G1 X128.096 Y133.354 E.00085
; LINE_WIDTH: 0.474837
G1 F8334.938
G1 X128.107 Y133.271 E.00295
G1 X128.109 Y133.261 E.00036
; LINE_WIDTH: 0.427176
G1 F9368.769
G1 X128.121 Y133.168 E.00295
; LINE_WIDTH: 0.429332
G1 F9316.501
G1 X128.144 Y133.052 E.00372
; LINE_WIDTH: 0.479149
G1 F8252.558
G1 X128.158 Y132.98 E.00262
G1 F7942.821
G1 X128.167 Y132.936 E.00157
; LINE_WIDTH: 0.528966
G1 F7406.713
G1 X128.177 Y132.884 E.00212
G1 X128.189 Y132.82 E.00255
; LINE_WIDTH: 0.578783
G1 F6718.138
G1 X128.192 Y132.808 E.00057
G1 X128.212 Y132.705 E.00458
; LINE_WIDTH: 0.6286
G1 F6146.701
G1 X128.235 Y132.589 E.00563
G1 X128.062 Y132.216 E.0196
G1 X127.875 Y132.015 E.01311
; LINE_WIDTH: 0.609085
G1 F6358.571
G1 X127.632 Y131.826 E.0142
G1 X127.761 Y131.689 E.0087
G1 X127.779 Y131.62 E.00326
; LINE_WIDTH: 0.581675
G1 F6682.073
G1 X127.797 Y131.552 E.00311
; LINE_WIDTH: 0.554265
G1 F7040.257
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509986
G1 F7513.735
G1 X127.82 Y131.347 E.00152
G1 F7707.698
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465706
G1 F8514.946
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421427
G1 F8546.569
G1 X127.852 Y131.055 E.00008
G1 F8780.964
G1 X127.854 Y131.037 E.00056
G1 F9511.065
G1 X127.87 Y130.893 E.00448
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.283 Y129.906 E.01059
G1 X127.303 Y129.792 E.00355
; LINE_WIDTH: 0.467423
G1 F8480.521
G1 X127.357 Y129.726 E.00295
G1 X127.415 Y129.655 E.00319
; LINE_WIDTH: 0.514846
G1 F7628.323
G1 X127.526 Y129.517 E.00682
; LINE_WIDTH: 0.562269
G1 F6931.759
G1 X127.603 Y129.422 E.00515
G1 X127.638 Y129.379 E.00236
; LINE_WIDTH: 0.609692
G1 F6351.761
G1 X127.64 Y129.376 E.00017
G1 X127.75 Y129.241 E.00803
G1 X127.755 Y128.896 E.01595
; LINE_WIDTH: 0.569749
G1 F6833.337
G1 X127.733 Y128.85 E.0022
; LINE_WIDTH: 0.524743
G1 F7433.214
G1 X127.71 Y128.804 E.00201
; LINE_WIDTH: 0.479736
G1 F8058.325
G1 X127.687 Y128.758 E.00182
; LINE_WIDTH: 0.434729
G1 F9188.151
G1 X127.598 Y128.455 E.01007
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.431 Y128.189 E.00968
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.07 J-2.285 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.818 I27.171 J-1.755 E.04788
G1 X130.408 Y131.712 E.00352
G1 X130.362 Y131.686 E.00164
G1 X130.229 Y131.611 E.00467
G1 X130.378 Y131.493 E.00583
G1 X130.406 Y131.471 E.00109
G1 X130.447 Y131.361 E.00363
G1 X130.443 Y130.518 E.02588
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.593 Y128.721 E.01205
; LINE_WIDTH: 0.465503
G1 F8519.036
G1 X128.524 Y128.823 E.00425
; LINE_WIDTH: 0.511007
G1 F7690.878
G1 X128.454 Y128.925 E.00471
; LINE_WIDTH: 0.556511
G1 F7009.469
G1 X128.385 Y129.027 E.00517
; LINE_WIDTH: 0.602015
G1 F6438.977
G1 X128.316 Y129.129 E.00562
G1 X128.334 Y129.284 E.00712
; LINE_WIDTH: 0.567894
G1 F6857.489
G1 X128.346 Y129.38 E.00412
M204 S6000
; WIPE_START
G1 X128.354 Y129.44 E-.02314
G1 X128.386 Y129.504 E-.02704
G1 X128.418 Y129.568 E-.02739
G1 X128.449 Y129.629 E-.02616
G1 X128.45 Y129.632 E-.00123
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.022 E-.06679
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z1.18 F42000
G1 Z.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5732
G1 F6788.866
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601266
G1 F6447.615
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 F5947.896
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 F5964.255
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 F6126.867
G1 X130.933 Y131.841 E.0299
; WIPE_START
G1 X130.951 Y132.465 E-.23729
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19051
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z1.18 F42000
G1 Z.78
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F7384.04
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.54903
G1 F7113.078
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581114
G1 F6689.038
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583734
G1 F6656.633
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600722
G1 F6453.903
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 F6205.163
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.623408
G1 F6201.678
G1 X127.983 Y137.406 E.03252
G1 X128.323 Y136.936 E.02742
; LINE_WIDTH: 0.601352
G1 F6446.622
G1 X128.534 Y136.351 E.02834
; LINE_WIDTH: 0.585382
G1 F6636.41
G1 X128.571 Y135.929 E.01869
; WIPE_START
G1 X128.534 Y136.351 E-.16067
G1 X128.323 Y136.936 E-.23666
G1 X127.983 Y137.406 E-.22031
G1 X127.682 Y137.63 E-.14236
; WIPE_END
G1 E-.04 F1800
G1 X128.662 Y130.06 Z1.18 F42000
G1 X128.987 Y127.548 Z1.18
G1 Z.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590184
G1 F6578.179
G1 X129.358 Y127.485 E.0168
; LINE_WIDTH: 0.586815
G1 F6618.925
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 F6975.109
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 F7384.835
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 F7860.459
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 0.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.459
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/50
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
M106 S173.4
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z1.38 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z1.38
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.38 F4000
            G39.3 S1
            G0 Z1.38 F4000
            G392 S0
          
        M623
    
    M623
M623


; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
;--------------------
; CP TOOLCHANGE START
; toolchange #2
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; filament end gcode 
M106 P3 S0

G1 E-1.2 F1800
;===== A1 20240913 =======================
M1007 S0 ; turn off mass estimation
G392 S0
M620 S0A
M204 S9000

G17
G2 Z1.38 I0.86 J0.86 P1 F10000 ; spiral lift a little from second lift

G1 Z3.98 F1200

M400
M106 P1 S0
M106 P2 S0

M104 S220


G1 X267 F18000


M620.11 S0

M400

M620.1 E F299 T240
M620.10 A0 F299
T0
M620.1 E F299 T240
M620.10 A1 F299 L87.7236 H0.4 T240

G1 Y128 F9000




M620.11 S0


M400
G92 E0
M628 S0


; FLUSH_START
; always use highest temperature to flush
M400
M1002 set_filament_type:UNKNOWN
M109 S240
M106 P1 S60

G1 E23.7 F299 ; do not need pulsatile flushing for start part
G1 E0.403236 F50
G1 E4.63722 F299
G1 E0.403236 F50
G1 E4.63722 F299
G1 E0.403236 F50
G1 E4.63722 F299
G1 E0.403236 F50
G1 E4.63722 F299

; FLUSH_END
G1 E-2 F1800
G1 E2 F300
M400
M1002 set_filament_type:PLA





M106 P1 S60
; FLUSH_START
G1 E7.89512 F299
G1 E0.877236 F50
G1 E7.89512 F299
G1 E0.877236 F50
G1 E7.89512 F299
G1 E0.877236 F50
G1 E7.89512 F299
G1 E0.877236 F50
G1 E7.89512 F299
G1 E0.877236 F50
; FLUSH_END
G1 E-2 F1800
G1 E2 F300










M629

M400
M106 P1 S60
M109 S220
G1 E6 F299 ;Compensate for filament spillage during waiting temperature
M400
G92 E0
G1 E-2 F1800
M400
M106 P1 S178
M400 S3
M73 P52 R10
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
G1 Z3.98
M106 P1 S0

M204 S6000



M622.1 S0
M9833 F5 A0.3 ; cali dynamic extrusion compensation
M1002 judge_flag filament_need_cali_flag
M622 J1
  G92 E0
M73 P53 R10
  G1 E-2 F1800
  M400
  
  M106 P1 S178
  M400 S4
  G1 X-38.2 F18000
  G1 X-48.2 F3000
  G1 X-38.2 F18000 ;wipe and shake
  G1 X-48.2 F3000
  G1 X-38.2 F12000 ;wipe and shake
  G1 X-48.2 F3000
  M400
  M106 P1 S0 
M623

M621 S0A
G392 S0

M1007 S1
M106 S173.4
M106 P2 S178
G1 X15 Y221 F42000
G1 Z4.38
G1 Z.98
G1 E2 F1800

; filament start gcode
M106 P3 S255
;Prevent PLA from jamming



G4 S0
G1  X50.000 Y221.000  E1.3302
G1  Y241.500  E0.7791
G1  X15.000  E1.3302
G1  Y221.000  E0.7791
G1  X15.500 Y221.500  
; CP TOOLCHANGE WIPE
M73 P54 R10
G1  X49.500  E1.2922 F1584
G1  Y222.833  E0.0507
G1  X15.500  E1.2922 F1800
G1  Y224.167  E0.0507
G1  X49.500  E1.2922 F2198
G1  Y225.500  E0.0507
G1  X15.500  E1.2922 F4200
G1  Y226.833  E0.0507
G1  X49.500  E1.2922 F4250
G1  Y228.167  E0.0507
G1  X15.500  E1.2922 F4300
G1  Y229.500  E0.0507
G1  X49.500  E1.2922 F4350
G1  Y230.833  E0.0507
G1  X15.500  E1.2922 F4400
G1  Y232.167  E0.0507
G1  X49.500  E1.2922 F4450
G1  Y233.500  E0.0507
G1  X15.500  E1.2922 F4500
G1  Y234.833  E0.0507
G1  X49.500  E1.2922 F4550
M73 P55 R10
G1  Y236.167  E0.0507
G1  X15.500  E1.2922 F4600
G1  Y237.500  E0.0507
G1  X49.500  E1.2922 F4650
G1  Y238.833  E0.0507
G1  X15.500  E1.2922 F4700
G1  Y240.167  E0.0507
G1  X49.500  E1.2922 F4750
; WIPE_TOWER_END
M220 R
G1 F42000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y241.000  
; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1 F5400
G1  X50.457 
G1  Y241.957 
G1  X14.543  E1.3650
G1  Y220.543  E0.8139
G1  X50.457  E1.3650
G1  Y241.957  E0.8139
G1  X50.914 
G1  Y242.414 
G1  X14.086  E1.3997
G1  Y220.086  E0.8486
G1  X50.914  E1.3997
G1  Y242.414  E0.8486
; WIPE_TOWER_END

; WIPE_START
G1 F7860.459
G1 X48.914 Y242.414 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X53.272 Y236.148 Z1.38 F42000
G1 X128.136 Y128.514 Z1.38
M73 P55 R9
G1 Z.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638635
; LAYER_HEIGHT: 0.2
G1 F6043.159
G1 X127.961 Y128.123 E.02078
G3 X128.151 Y127.74 I.952 J.233 E.02092
; LINE_WIDTH: 0.598086
G1 F6484.55
G1 X128.263 Y127.566 E.00936
; LINE_WIDTH: 0.557537
G1 F6995.502
G1 X128.375 Y127.392 E.00868
; LINE_WIDTH: 0.516987
G1 F7593.863
M73 P56 R9
G1 X128.566 Y127.256 E.00908
; LINE_WIDTH: 0.483493
G1 F8171.177
G1 X128.758 Y127.119 E.00844
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 F9108.298
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407986
G1 F9861.231
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379909
G1 F10682.842
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351832
G1 F11653.803
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332812
G1 F12418.417
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 F10311.917
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430704
G1 F9213.695
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.47965
G1 F8243.079
G1 X131 Y131.625 E.00267
; LINE_WIDTH: 0.528596
G1 F7412.349
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577542
G1 F6733.73
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626488
G1 F6168.947
G1 X130.933 Y131.84 E.00357
G1 X130.901 Y131.784 E.0031
; LINE_WIDTH: 0.587486
G1 F6610.77
G1 X130.868 Y131.727 E.00289
; LINE_WIDTH: 0.548484
G1 F7120.761
G1 X130.836 Y131.671 E.00269
; LINE_WIDTH: 0.509482
G1 F7716.016
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.47048
G1 F8419.87
G1 X130.799 Y131.496 E.0041
; LINE_WIDTH: 0.424591
G1 F8964.91
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378702
G1 F9527.042
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332812
G1 F12418.417
G1 X130.77 Y130.513 E.02132
; LINE_WIDTH: 0.350614
G1 F11699.953
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G1 F10609.235
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 F10157.039
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 F9436.807
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X130.285 Y128.338 E.01695
G1 X129.854 Y128.062 E.01698
G1 X129.312 Y127.964 E.01826
G1 X129.069 Y128.013 E.00821
; LINE_WIDTH: 0.497442
G1 F7920.422
G1 X128.961 Y128.024 E.00404
; LINE_WIDTH: 0.544884
G1 F7171.836
G1 X128.852 Y128.036 E.00446
; LINE_WIDTH: 0.592326
G1 F6552.534
G1 X128.744 Y128.048 E.00488
; LINE_WIDTH: 0.639768
G1 F6031.686
G1 X128.636 Y128.059 E.0053
G1 X128.414 Y128.241 E.01394
; LINE_WIDTH: 0.638635
G1 F6043.159
G1 X128.179 Y128.472 E.01599
; WIPE_START
G1 X127.961 Y128.123 E-.15624
G1 X128.038 Y127.914 E-.08477
G1 X128.151 Y127.74 E-.07863
G1 X128.263 Y127.566 E-.07863
G1 X128.375 Y127.392 E-.07863
G1 X128.566 Y127.256 E-.0893
G1 X128.758 Y127.119 E-.0893
G1 X129.025 Y127.056 E-.1045
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z1.38 F42000
G1 Z.98
G1 E.8 F1800
; LINE_WIDTH: 0.360701
G1 F11328.556
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X127.823 Y129.886 E.0142
G1 X127.755 Y129.822 E.00243
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530838
G1 F7378.289
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 F7982.763
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 F8695.119
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 F8909.355
G1 X128.465 Y129.64 E.00051
G1 F9547.071
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 F10335.888
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429778
G1 F9305.745
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474563
G1 F8340.234
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519348
G1 F7556.24
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564133
G1 F6906.976
G1 X128.246 Y131.518 E.00352
; LINE_WIDTH: 0.608917
G1 F6360.458
G1 X128.259 Y131.6 E.00382
; LINE_WIDTH: 0.628625
G1 F6146.439
G1 X128.535 Y131.815 E.01671
G3 X128.602 Y132.46 I-25.141 J2.929 E.03093
G1 X128.475 Y132.581 E.00836
G1 X128.461 Y132.644 E.00311
; LINE_WIDTH: 0.597158
G1 F6495.405
G1 X128.447 Y132.708 E.00294
; LINE_WIDTH: 0.565691
G1 F6886.381
G1 X128.449 Y132.777 E.00296
; LINE_WIDTH: 0.524979
G1 F7467.968
G1 X128.452 Y132.847 E.00273
; LINE_WIDTH: 0.484267
G1 F8094.165
G1 X128.454 Y132.898 E.00184
G1 F8156.855
G1 X128.454 Y132.916 E.00066
; LINE_WIDTH: 0.443555
G1 F8932.315
G1 X128.457 Y132.977 E.00198
G1 F8985.748
G1 X128.457 Y132.986 E.00029
; LINE_WIDTH: 0.402843
G1 F9922.551
G1 X128.459 Y133.055 E.00204
; LINE_WIDTH: 0.404782
G1 F9948.568
G1 X128.467 Y133.144 E.00262
; LINE_WIDTH: 0.447433
G1 F8899.605
G1 X128.475 Y133.233 E.00293
; LINE_WIDTH: 0.490084
G1 F8050.746
G1 X128.483 Y133.321 E.00324
; LINE_WIDTH: 0.532735
G1 F7349.718
G1 X128.489 Y133.385 E.00257
G1 X128.491 Y133.41 E.00098
; LINE_WIDTH: 0.575386
G1 F6760.998
G1 X128.492 Y133.424 E.00063
G1 X128.499 Y133.498 E.00323
; LINE_WIDTH: 0.618037
G1 F6259.596
G1 X128.507 Y133.587 E.00417
; LINE_WIDTH: 0.635416
G1 F6075.991
G1 X128.72 Y133.772 E.01365
G2 X128.808 Y134.301 I2.156 J-.083 E.02596
; LINE_WIDTH: 0.588958
G1 F6592.948
G1 X128.846 Y134.45 E.00685
; LINE_WIDTH: 0.5425
G1 F7206.053
G1 X128.884 Y134.599 E.00627
; LINE_WIDTH: 0.505731
G1 F7778.553
G2 X128.982 Y135.407 I4.775 J-.17 E.03073
; LINE_WIDTH: 0.462865
G1 F8572.551
G1 X129.032 Y135.684 E.00964
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 F8946.367
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 F8742.554
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 F8055.974
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524888
G1 F7469.381
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559982
G1 F6962.415
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517854
G1 F7580
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475726
G1 F8317.814
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 F9214.75
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 F8861.075
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 F7998.462
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 F7288.899
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G1 F6694.972
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 F6874.847
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 F7489
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 F8223.646
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 F8318.307
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 F7591.915
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G1 F6982.198
G2 X123.864 Y129.986 I-.604 J-.155 E.01351
; LINE_WIDTH: 0.517801
G1 F7580.852
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.477085
G1 F8291.791
G1 X123.821 Y129.689 E.00531
; LINE_WIDTH: 0.436368
G1 F9149.875
G1 X123.8 Y129.391 E.00957
; LINE_WIDTH: 0.39611
G1 F10192.828
G1 X123.78 Y129.093 E.00859
; LINE_WIDTH: 0.399592
G1 F10093.308
G1 X123.801 Y128.588 E.0147
; LINE_WIDTH: 0.444444
G1 F8965.851
G1 X123.824 Y128.438 E.00496
; LINE_WIDTH: 0.489295
G1 F8064.968
G1 X123.846 Y128.288 E.00552
; LINE_WIDTH: 0.534147
G1 F7328.595
G1 X123.868 Y128.138 E.00607
; LINE_WIDTH: 0.578998
G1 F6715.441
G1 X123.891 Y127.988 E.00662
G1 X123.886 Y125.054 E.12816
; LINE_WIDTH: 0.573606
G1 F6783.672
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X123.913 Y119.904 E.12639
; LINE_WIDTH: 0.540535
G1 F7234.508
G1 X123.936 Y117.891 E.08164
; LINE_WIDTH: 0.522564
G1 F7505.567
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01007
; LINE_WIDTH: 0.540535
G1 F7234.508
G1 X124.41 Y119.905 E.08158
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X124.412 Y122.885 E.12633
; LINE_WIDTH: 0.573606
G1 F6783.672
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578998
G1 F6715.441
G2 X124.427 Y128.103 I1654.658 J-4.293 E.13323
G2 X124.292 Y128.305 I.161 J.255 E.01092
; LINE_WIDTH: 0.534147
G1 F7328.595
G1 X124.242 Y128.423 E.00514
G1 X124.241 Y128.426 E.00015
; LINE_WIDTH: 0.489295
G1 F8064.968
G1 X124.189 Y128.548 E.00481
; LINE_WIDTH: 0.444444
G1 F8965.851
G1 X124.138 Y128.67 E.00432
; LINE_WIDTH: 0.399592
G1 F10093.308
G1 X124.094 Y129.072 E.01175
; LINE_WIDTH: 0.384203
G1 F10548.43
G1 X124.133 Y129.415 E.0096
; LINE_WIDTH: 0.423633
G1 F9455.943
G1 X124.173 Y129.529 E.00376
; LINE_WIDTH: 0.463063
G1 F8568.511
G1 X124.214 Y129.643 E.00415
; LINE_WIDTH: 0.502493
G1 F7833.358
G1 X124.254 Y129.758 E.00454
; LINE_WIDTH: 0.541923
G1 F7214.386
G1 X124.294 Y129.872 E.00493
; LINE_WIDTH: 0.56506
G1 F6894.703
G1 X124.528 Y130.101 E.01391
G2 X124.358 Y130.326 I.157 J.295 E.01235
; LINE_WIDTH: 0.530024
G1 F7390.624
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.494988
G1 F7963.415
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 F8632.452
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 F9263.882
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 F8223.646
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 F7489
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 F6874.847
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601446
G1 F6445.537
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 F6960.099
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 F7563.947
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 F8282.526
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 F9032.675
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 F9634.015
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 F8541.506
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512187
G1 F7671.544
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559982
G1 F6962.415
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 F6592.61
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 F7050.473
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 F7576.682
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 F8187.772
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451189
G1 F8817.727
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 F8946.367
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01295
G1 X128.284 Y135.563 E.00842
; LINE_WIDTH: 0.461438
G1 F8601.781
G1 X128.378 Y135.338 E.0083
; LINE_WIDTH: 0.502877
G1 F7826.818
G1 X128.471 Y135.113 E.00912
; LINE_WIDTH: 0.551668
G1 F7076.202
G1 X128.433 Y134.757 E.01487
; LINE_WIDTH: 0.600458
G1 F6456.959
G1 X128.419 Y134.626 E.00595
G1 X128.395 Y134.4 E.01035
; LINE_WIDTH: 0.635416
G1 F6075.991
G1 X128.215 Y134.115 E.01626
G1 X127.906 Y133.868 E.01911
; LINE_WIDTH: 0.618037
G1 F6259.596
G1 X128.058 Y133.635 E.01305
G1 X128.071 Y133.543 E.00433
; LINE_WIDTH: 0.570716
G1 F6820.822
G1 X128.083 Y133.451 E.00397
; LINE_WIDTH: 0.523395
G1 F7492.599
G1 X128.093 Y133.38 E.00283
G1 X128.095 Y133.36 E.00079
; LINE_WIDTH: 0.476073
G1 F8311.154
G1 X128.107 Y133.274 E.00307
G1 X128.108 Y133.268 E.00019
; LINE_WIDTH: 0.428752
G1 F9330.5
G1 X128.12 Y133.177 E.00291
; LINE_WIDTH: 0.430869
G1 F9279.571
G1 X128.143 Y133.06 E.00376
; LINE_WIDTH: 0.480308
G1 F8230.678
G1 X128.159 Y132.98 E.0029
G1 F7851.547
G1 X128.166 Y132.943 E.00135
; LINE_WIDTH: 0.529747
G1 F7394.824
G1 X128.178 Y132.886 E.00231
G1 X128.189 Y132.826 E.00241
; LINE_WIDTH: 0.579186
G1 F6713.087
G1 X128.192 Y132.812 E.00064
G1 X128.213 Y132.71 E.00456
; LINE_WIDTH: 0.628625
G1 F6146.439
G1 X128.236 Y132.593 E.00568
G1 X128.057 Y132.21 E.02017
G1 X127.876 Y132.016 E.01264
; LINE_WIDTH: 0.608917
G1 F6360.458
G1 X127.632 Y131.827 E.01428
G1 X127.761 Y131.688 E.00874
G1 X127.779 Y131.62 E.00325
; LINE_WIDTH: 0.581594
G1 F6683.083
G1 X127.797 Y131.552 E.00309
; LINE_WIDTH: 0.55427
G1 F7040.188
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 F7513.567
G1 X127.82 Y131.347 E.00152
G1 F7707.633
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 F8514.885
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 F8545.978
G1 X127.852 Y131.055 E.00007
G1 F8781.242
G1 X127.854 Y131.037 E.00056
G1 F9511.015
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 F8480.516
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 F7628.314
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 F6931.748
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 F6351.749
G2 X127.757 Y129.094 I-.148 J-.186 E.01276
; LINE_WIDTH: 0.602393
G1 F6434.627
G1 X127.722 Y128.954 E.00657
G1 X127.717 Y128.934 E.00093
; LINE_WIDTH: 0.556795
G1 F7005.602
G1 X127.705 Y128.883 E.0022
G1 X127.678 Y128.774 E.0047
; LINE_WIDTH: 0.511196
G1 F7024.889
G1 X127.677 Y128.773 E.00006
G1 F7687.773
G1 X127.638 Y128.615 E.00622
; LINE_WIDTH: 0.465598
G1 F8517.132
G1 X127.598 Y128.455 E.00567
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.431 Y128.189 E.00967
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.07 J-2.285 E.15108
G2 X131.672 Y134.53 I9.527 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.00579
G1 X130.472 Y133.485 E.00103
G1 X130.508 Y133.375 E.00355
G3 X130.452 Y131.818 I27.496 J-1.763 E.04789
G1 X130.408 Y131.712 E.00352
G1 X130.362 Y131.686 E.00163
G1 X130.229 Y131.611 E.00468
G1 X130.378 Y131.493 E.00583
G1 X130.406 Y131.471 E.00109
G1 X130.447 Y131.36 E.00363
G1 X130.443 Y130.518 E.02588
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.465598
G1 F8517.132
G1 X128.669 Y128.669 E.00272
G1 X128.617 Y128.737 E.00297
; LINE_WIDTH: 0.511196
G1 F7687.773
G1 X128.516 Y128.868 E.00631
; LINE_WIDTH: 0.556795
G1 F7005.602
G1 X128.442 Y128.966 E.00514
G1 X128.416 Y128.999 E.00178
; LINE_WIDTH: 0.602393
G1 F6434.627
G1 X128.409 Y129.009 E.00052
G1 X128.315 Y129.131 E.00701
G1 X128.335 Y129.288 E.00723
; LINE_WIDTH: 0.566616
G1 F6874.224
G1 X128.347 Y129.386 E.0042
M204 S6000
; WIPE_START
G1 X128.387 Y129.508 E-.04869
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06982
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z1.38 F42000
G1 Z.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573204
G1 F6788.815
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601274
G1 F6447.523
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648194
G1 F5947.719
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02532
; LINE_WIDTH: 0.646716
G1 F5962.279
G1 X130.951 Y132.465 E.04302
; LINE_WIDTH: 0.630494
G1 F6126.888
G1 X130.933 Y131.84 E.02991
; WIPE_START
G1 X130.951 Y132.465 E-.23737
G1 X130.995 Y133.338 E-.33228
G1 X131.044 Y133.837 E-.19035
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z1.38 F42000
G1 Z.98
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F7384.04
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.54903
G1 F7113.078
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581118
G1 F6688.988
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583736
G1 F6656.608
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 F6453.88
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 F6205.163
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.615308
G1 F6289.44
G1 X127.944 Y137.445 E.02953
; LINE_WIDTH: 0.62528
G1 F6181.744
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621312
G1 F6224.153
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599718
G1 F6465.541
G1 X128.571 Y135.929 E.0121
; WIPE_START
G1 X128.562 Y136.195 E-.10137
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19509
G1 X127.686 Y137.631 E-.12083
; WIPE_END
G1 E-.04 F1800
G1 X128.663 Y130.062 Z1.38 F42000
G1 X128.987 Y127.548 Z1.38
G1 Z.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590185
G1 F6578.166
G1 X129.358 Y127.485 E.0168
; LINE_WIDTH: 0.586816
G1 F6618.919
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559043
G1 F6975.088
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530407
G1 F7384.812
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 F7860.451
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 1.18
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.451
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/50
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
M106 S201.45
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z1.58 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z1.58
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.58 F4000
            G39.3 S1
            G0 Z1.58 F4000
            G392 S0
          
        M623
    
    M623
M623


G1 X49.5 Y241 F42000
G1 Z1.98
G1 Z1.18
G1 E.8 F1800
; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1  X49.500 Y241.000 F5400
G1  X15.500  E1.2922
G1  Y221.500  E0.7411
G1  X49.500  E1.2922
G1  Y241.000  E0.7411
G1  X16.500 Y221.500  
;--------------------
; CP EMPTY GRID START
; layer #7
G1  Y241.000  E0.7411
G1  X24.500 
G1  Y221.500  E0.7411
G1  X32.500 
G1  Y241.000  E0.7411
G1  X40.500 
G1  Y221.500  E0.7411
G1  X48.500 
G1  Y241.000  E0.7411
; CP EMPTY GRID END
;------------------






G1  X50.000 
G1  Y241.500 
G1  X15.000  E1.3302
G1  Y221.000  E0.7791
G1  X50.000  E1.3302
G1  Y241.500  E0.7791
G1  X50.457 
G1  Y241.957 
G1  X14.543  E1.3650
G1  Y220.543  E0.8139
G1  X50.457  E1.3650
G1  Y241.957  E0.8139
; WIPE_TOWER_END

; WIPE_START
G1 F7860.451
G1 X48.457 Y241.957 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X52.843 Y235.711 Z1.58 F42000
G1 X128.13 Y128.481 Z1.58
G1 Z1.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638771
; LAYER_HEIGHT: 0.2
G1 F6041.779
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596802
G1 F6499.588
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554832
G1 F7032.464
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512862
G1 F7660.52
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 F8209.609
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438158
G1 F9108.435
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407995
G1 F9860.988
M73 P57 R9
G1 X130.975 Y129.232 E.01295
; LINE_WIDTH: 0.379915
G1 F10682.652
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351835
G1 F11653.691
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 F12418.504
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 F10313.053
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 F9214.738
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 F8243.004
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528602
G1 F7412.257
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.57755
G1 F6733.629
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 F6168.841
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587434
G1 F6611.41
G1 X130.868 Y131.728 E.0029
; LINE_WIDTH: 0.548369
G1 F7122.387
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509304
G1 F7718.966
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470239
G1 F8424.62
G1 X130.798 Y131.497 E.0041
; LINE_WIDTH: 0.42443
G1 F8969.919
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.37862
G1 F9532.301
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 F12418.504
G1 X130.77 Y130.513 E.02132
; LINE_WIDTH: 0.350655
G1 F11698.376
G1 X130.712 Y130.021 E.01241
; LINE_WIDTH: 0.38233
G1 F10606.641
G3 X130.657 Y129.311 I2.665 J-.563 E.01976
; LINE_WIDTH: 0.397376
G1 F10156.408
G1 X130.611 Y129.038 E.008
; LINE_WIDTH: 0.42441
G1 F9436.683
G1 X130.564 Y128.765 E.00861
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497192
G1 F7924.767
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544385
G1 F7178.965
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591578
G1 F6561.465
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638771
G1 F6041.779
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z1.58 F42000
G1 Z1.18
G1 E.8 F1800
; LINE_WIDTH: 0.360698
G1 F11328.664
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530838
G1 F7378.289
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 F7982.763
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 F8695.119
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 F8909.442
G1 X128.465 Y129.64 E.00051
G1 F9547.071
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.524 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 F10335.888
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429744
G1 F9306.558
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474494
G1 F8341.559
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.519244
G1 F7557.881
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.563994
G1 F6908.808
G1 X128.246 Y131.518 E.00352
; LINE_WIDTH: 0.608744
G1 F6362.403
G1 X128.259 Y131.599 E.00382
; LINE_WIDTH: 0.628699
G1 F6145.663
G1 X128.535 Y131.815 E.01672
G3 X128.602 Y132.46 I-25.654 J2.981 E.03095
G1 X128.462 Y132.609 E.00976
; LINE_WIDTH: 0.623847
G1 F6196.992
G1 X128.462 Y132.682 E.00346
; LINE_WIDTH: 0.580166
G1 F6700.845
G1 X128.461 Y132.755 E.0032
; LINE_WIDTH: 0.536485
G1 F7293.882
G1 X128.461 Y132.815 E.00242
G1 X128.461 Y132.828 E.00052
; LINE_WIDTH: 0.492803
G1 F7793.732
G1 X128.46 Y132.87 E.00152
G1 F8002.081
G1 X128.46 Y132.901 E.00115
; LINE_WIDTH: 0.449122
G1 F8385.964
G1 X128.46 Y132.932 E.00101
G1 F8862.593
G1 X128.46 Y132.974 E.0014
; LINE_WIDTH: 0.405441
G1 F9840.778
G1 X128.459 Y133.047 E.00216
; LINE_WIDTH: 0.40451
G1 F9956.027
G1 X128.467 Y133.137 E.00265
; LINE_WIDTH: 0.447261
G1 F8903.375
G1 X128.475 Y133.227 E.00297
; LINE_WIDTH: 0.490012
G1 F8052.034
G1 X128.483 Y133.317 E.00328
; LINE_WIDTH: 0.532763
G1 F7349.293
G1 X128.489 Y133.384 E.0027
G1 X128.49 Y133.406 E.0009
; LINE_WIDTH: 0.575514
G1 F6759.37
G1 X128.492 Y133.423 E.00074
G1 X128.498 Y133.496 E.00317
; LINE_WIDTH: 0.618265
G1 F6257.116
G1 X128.506 Y133.586 E.00422
; LINE_WIDTH: 0.635437
G1 F6075.775
G1 X128.719 Y133.771 E.01362
G2 X128.808 Y134.303 I2.172 J-.089 E.02614
; LINE_WIDTH: 0.589074
G1 F6591.551
G1 X128.846 Y134.449 E.00668
; LINE_WIDTH: 0.542711
G1 F7203.02
G1 X128.884 Y134.594 E.00612
; LINE_WIDTH: 0.505336
G1 F7785.198
G2 X128.982 Y135.406 I4.88 J-.182 E.03084
; LINE_WIDTH: 0.462668
G1 F8576.584
G1 X129.032 Y135.684 E.00969
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 F8946.41
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 F8742.554
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 F8055.962
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 F7469.36
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G1 F6962.388
G2 X123.896 Y133.914 I-.945 J-.176 E.01652
; LINE_WIDTH: 0.515636
G1 F7615.571
G1 X123.872 Y133.725 E.00736
; LINE_WIDTH: 0.471288
G1 F8404.001
G1 X123.848 Y133.535 E.00667
; LINE_WIDTH: 0.426939
G1 F9374.536
G1 X123.833 Y133.003 E.01666
; LINE_WIDTH: 0.449191
G1 F8861.097
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 F7998.48
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 F7288.913
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G1 F6694.984
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566567
G1 F6874.86
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 F7489.011
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 F8223.653
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 F8318.314
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 F7591.925
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G1 F6982.211
G2 X123.864 Y129.986 I-.605 J-.155 E.01351
; LINE_WIDTH: 0.517853
G1 F7580.022
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.47719
G1 F8289.786
G1 X123.821 Y129.689 E.00531
; LINE_WIDTH: 0.436526
G1 F9146.202
G1 X123.8 Y129.394 E.00949
; LINE_WIDTH: 0.39625
G1 F10188.789
G1 X123.78 Y129.098 E.00852
; LINE_WIDTH: 0.398855
G1 F10114.206
G1 X123.801 Y128.592 E.01469
; LINE_WIDTH: 0.443891
G1 F8978.211
G1 X123.823 Y128.442 E.00499
; LINE_WIDTH: 0.488927
G1 F8071.63
G1 X123.846 Y128.291 E.00555
; LINE_WIDTH: 0.533963
G1 F7331.345
G1 X123.868 Y128.14 E.00611
; LINE_WIDTH: 0.578998
G1 F6715.441
G1 X123.891 Y127.989 E.00667
G1 X123.886 Y125.054 E.12818
; LINE_WIDTH: 0.573606
G1 F6783.672
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X123.913 Y119.924 E.12554
; LINE_WIDTH: 0.540712
G1 F7231.936
G1 X123.936 Y117.891 E.08248
; LINE_WIDTH: 0.522564
G1 F7505.567
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01007
; LINE_WIDTH: 0.540712
G1 F7231.936
G1 X124.41 Y119.925 E.08242
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X124.412 Y122.885 E.12548
; LINE_WIDTH: 0.573606
G1 F6783.672
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578998
G1 F6715.441
G2 X124.427 Y128.103 I1661.133 J-4.316 E.13324
G2 X124.292 Y128.306 I.162 J.255 E.01096
; LINE_WIDTH: 0.533963
G1 F7331.345
G1 X124.243 Y128.422 E.00503
G1 X124.24 Y128.428 E.00029
; LINE_WIDTH: 0.488927
G1 F8071.63
G1 X124.189 Y128.551 E.00484
; LINE_WIDTH: 0.443891
G1 F8978.211
G1 X124.137 Y128.674 E.00435
; LINE_WIDTH: 0.398855
G1 F10114.206
G1 X124.094 Y129.077 E.01177
; LINE_WIDTH: 0.383581
G1 F10567.692
G1 X124.132 Y129.411 E.00932
; LINE_WIDTH: 0.422849
G1 F9475.467
G1 X124.172 Y129.525 E.00376
; LINE_WIDTH: 0.462116
G1 F8587.868
G1 X124.213 Y129.64 E.00415
; LINE_WIDTH: 0.501384
G1 F7852.316
G1 X124.253 Y129.755 E.00454
; LINE_WIDTH: 0.540651
G1 F7232.822
G1 X124.293 Y129.87 E.00493
; LINE_WIDTH: 0.565145
G1 F6893.58
G1 X124.527 Y130.102 E.01403
G2 X124.358 Y130.326 I.157 J.294 E.01234
; LINE_WIDTH: 0.530081
G1 F7389.763
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.495016
G1 F7962.916
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 F8632.452
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 F9263.882
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 F8223.653
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 F7489.011
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566567
G1 F6874.86
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 F6445.548
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 F6960.113
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518861
G1 F7563.963
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477569
G1 F8282.545
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441472
G1 F9032.698
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.426939
G1 F9374.536
G1 X124.23 Y133.508 E.01455
; LINE_WIDTH: 0.471288
G1 F8404.001
G1 X124.274 Y133.645 E.00505
; LINE_WIDTH: 0.515636
G1 F7615.571
G1 X124.318 Y133.783 E.00557
; LINE_WIDTH: 0.559984
G1 F6962.388
G1 X124.362 Y133.921 E.00609
; LINE_WIDTH: 0.588986
G1 F6592.61
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 F7050.478
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 F7576.693
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 F8187.791
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 F8817.737
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 F8946.41
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01296
G1 X128.285 Y135.561 E.00847
; LINE_WIDTH: 0.461207
G1 F8606.53
G1 X128.378 Y135.335 E.00833
; LINE_WIDTH: 0.502415
G1 F7834.688
G1 X128.471 Y135.109 E.00916
; LINE_WIDTH: 0.549888
G1 F7101.047
G1 X128.433 Y134.757 E.01464
; LINE_WIDTH: 0.59736
G1 F6493.038
G1 X128.42 Y134.635 E.00554
G1 X128.395 Y134.404 E.01047
; LINE_WIDTH: 0.635437
G1 F6075.775
G1 X128.214 Y134.114 E.0165
G1 X127.908 Y133.869 E.01897
; LINE_WIDTH: 0.618265
G1 F6257.116
G1 X128.058 Y133.635 E.01303
G1 X128.07 Y133.545 E.00425
; LINE_WIDTH: 0.57128
G1 F6813.539
G1 X128.082 Y133.455 E.0039
; LINE_WIDTH: 0.524295
G1 F7478.583
G1 X128.092 Y133.384 E.00282
G1 X128.094 Y133.365 E.00074
; LINE_WIDTH: 0.47731
G1 F8287.495
G1 X128.106 Y133.276 E.00318
G1 X128.106 Y133.276 E.00003
; LINE_WIDTH: 0.430325
G1 F9292.62
G1 X128.118 Y133.186 E.00286
; LINE_WIDTH: 0.431441
G1 F9265.918
G1 X128.141 Y133.065 E.0039
; LINE_WIDTH: 0.479543
G1 F8245.114
G1 X128.159 Y132.967 E.00354
G1 F7712.012
G1 X128.163 Y132.944 E.00084
; LINE_WIDTH: 0.527644
G1 F7426.91
G1 X128.177 Y132.868 E.00304
G1 F7293.093
G1 X128.185 Y132.823 E.00183
; LINE_WIDTH: 0.575746
G1 F6756.436
G1 X128.19 Y132.794 E.00124
G1 X128.207 Y132.701 E.0041
; LINE_WIDTH: 0.623847
G1 F6196.992
G1 X128.23 Y132.58 E.00583
; LINE_WIDTH: 0.628699
G1 F6145.663
G1 X128.049 Y132.196 E.02029
G1 X127.878 Y132.017 E.01178
; LINE_WIDTH: 0.608744
G1 F6362.403
G1 X127.632 Y131.827 E.01437
G1 X127.761 Y131.688 E.00877
G1 X127.779 Y131.62 E.00324
; LINE_WIDTH: 0.581507
G1 F6684.163
G1 X127.797 Y131.552 E.00308
; LINE_WIDTH: 0.554269
G1 F7040.201
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509989
G1 F7513.677
G1 X127.82 Y131.347 E.00152
G1 F7707.644
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 F8514.896
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 F8546.196
G1 X127.852 Y131.055 E.00008
G1 F8781.135
G1 X127.854 Y131.037 E.00056
G1 F9511.021
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 F8480.516
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 F7628.314
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 F6931.748
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 F6351.749
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 F6298.772
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 F6745.291
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538792
G1 F7259.948
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500957
G1 F7859.627
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 F8621.557
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.034 J-2.284 E.15108
G2 X131.672 Y134.53 I9.527 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.486 E.00101
G1 X130.508 Y133.375 E.00357
G3 X130.452 Y131.819 I27.163 J-1.755 E.04787
G1 X130.408 Y131.713 E.00352
G1 X130.361 Y131.686 E.00166
G1 X130.233 Y131.612 E.00455
G1 X130.379 Y131.492 E.00581
G1 X130.406 Y131.471 E.00104
G1 X130.447 Y131.36 E.00363
G1 X130.443 Y130.518 E.02588
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.00169
G1 X130.093 Y129.525 E.0054
G2 X130.237 Y129.414 I-.092 J-.27 E.0057
G1 X130.282 Y129.361 E.00214
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01296
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466197
G1 F8505.084
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512394
G1 F7668.164
G1 X128.547 Y128.795 E.00443
G1 F7251.03
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558591
G1 F6981.198
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604788
G1 F6407.199
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 F6459.056
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565558
G1 F6888.14
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06529
G1 X128.524 Y129.856 E-.07001
G1 X128.491 Y129.898 E-.02056
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06985
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z1.58 F42000
G1 Z1.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573198
G1 F6788.892
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601264
G1 F6447.638
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 F5947.916
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 F5964.255
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 F6126.867
G1 X130.933 Y131.841 E.02988
; WIPE_START
G1 X130.951 Y132.465 E-.23717
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19064
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.936 Z1.58 F42000
G1 Z1.18
G1 E.8 F1800
; LINE_WIDTH: 0.599718
G1 F6465.541
G1 X128.562 Y136.195 E.01178
; LINE_WIDTH: 0.621314
G1 F6224.131
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.625284
G1 F6181.701
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.61531
G1 F6289.418
G1 X127.431 Y137.816 E.02952
; LINE_WIDTH: 0.623082
G1 F6205.163
G1 X126.81 Y138.032 E.03111
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600726
G1 F6453.857
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583736
G1 F6656.608
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581116
G1 F6689.013
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.549032
G1 F7113.05
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530458
G1 F7384.04
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 X124.459 Y136.736 E-.15299
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z1.58 F42000
G1 X128.986 Y127.549 Z1.58
G1 Z1.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.59011
G1 F6579.067
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586815
G1 F6618.931
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.55904
G1 F6975.129
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 F7384.85
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.50091
G1 F7860.442
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 1.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.442
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/50
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
M106 S153
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z1.78 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z1.78
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.78 F4000
            G39.3 S1
            G0 Z1.78 F4000
            G392 S0
          
        M623
    
    M623
M623


; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
;--------------------
; CP TOOLCHANGE START
; toolchange #3
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; filament end gcode 
M106 P3 S0

G1 E-1.2 F1800
;===== A1 20240913 =======================
M1007 S0 ; turn off mass estimation
G392 S0
M620 S2A
M204 S9000

G17
G2 Z1.78 I0.86 J0.86 P1 F10000 ; spiral lift a little from second lift

G1 Z4.38 F1200

M400
M106 P1 S0
M106 P2 S0

M104 S220


G1 X267 F18000


M620.11 S0

M400

M620.1 E F299 T240
M620.10 A0 F299
T2
M620.1 E F548 T240
M620.10 A1 F548 L277.306 H0.4 T240

G1 Y128 F9000




M620.11 S0


M400
G92 E0
M628 S0


; FLUSH_START
; always use highest temperature to flush
M400
M1002 set_filament_type:UNKNOWN
M109 S240
M106 P1 S60

G1 E23.7 F299 ; do not need pulsatile flushing for start part
G1 E0.912532 F50
G1 E10.4941 F299
G1 E0.912532 F50
G1 E10.4941 F548
G1 E0.912532 F50
G1 E10.4941 F548
G1 E0.912532 F50
G1 E10.4941 F548

; FLUSH_END
G1 E-2 F1800
G1 E2 F300
M400
M1002 set_filament_type:PLA



; WIPE
M400
M106 P1 S178
M400 S3
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
M106 P1 S0



M106 P1 S60
; FLUSH_START
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
; FLUSH_END
G1 E-2 F1800
G1 E2 F300



; WIPE
M400
M106 P1 S178
M400 S3
M73 P61 R8
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
M106 P1 S0



M106 P1 S60
; FLUSH_START
G1 E12.4788 F548
G1 E1.38653 F50
M73 P62 R8
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
; FLUSH_END
G1 E-2 F1800
G1 E2 F300



; WIPE
M400
M106 P1 S178
M400 S3
G1 X-38.2 F18000
M73 P63 R8
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
M106 P1 S0



M106 P1 S60
; FLUSH_START
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
M73 P64 R8
G1 E12.4788 F548
G1 E1.38653 F50
G1 E12.4788 F548
G1 E1.38653 F50
; FLUSH_END


M629

M400
M106 P1 S60
M109 S220
G1 E6 F548 ;Compensate for filament spillage during waiting temperature
M400
G92 E0
G1 E-2 F1800
M400
M106 P1 S178
M400 S3
G1 X-38.2 F18000
M73 P64 R7
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
G1 Z4.38
M106 P1 S0

M204 S6000



M622.1 S0
M9833 F5 A0.3 ; cali dynamic extrusion compensation
M1002 judge_flag filament_need_cali_flag
M622 J1
  G92 E0
M73 P65 R7
  G1 E-2 F1800
  M400
  
  M106 P1 S178
  M400 S4
  G1 X-38.2 F18000
  G1 X-48.2 F3000
  G1 X-38.2 F18000 ;wipe and shake
  G1 X-48.2 F3000
  G1 X-38.2 F12000 ;wipe and shake
  G1 X-48.2 F3000
  M400
  M106 P1 S0 
M623

M621 S2A
G392 S0

M1007 S1
M106 S153
M106 P2 S178
G1 X50 Y241.5 F42000
G1 Z4.78
G1 Z1.38
M73 P66 R7
G1 E2 F1800

; filament start gcode
M106 P3 S200



G4 S0
G1  X15.000 Y241.500  E1.3302
G1  Y221.000  E0.7791
G1  X50.000  E1.3302
G1  Y241.500  E0.7791
G1  X15.000 Y221.000  
G1  X15.500 Y221.500  
; CP TOOLCHANGE WIPE
G1  X49.500  E1.2922 F1584
G1  Y222.833  E0.0507
G1  X15.500  E1.2922 F1800
G1  Y224.167  E0.0507
G1  X49.500  E1.2922 F2198
G1  Y225.500  E0.0507
M73 P67 R7
G1  X15.500  E1.2922 F4200
G1  Y226.833  E0.0507
G1  X49.500  E1.2922 F4250
G1  Y228.167  E0.0507
G1  X15.500  E1.2922 F4300
G1  Y229.500  E0.0507
G1  X49.500  E1.2922 F4350
G1  Y230.833  E0.0507
G1  X15.500  E1.2922 F4400
G1  Y232.167  E0.0507
G1  X49.500  E1.2922 F4450
G1  Y233.500  E0.0507
G1  X15.500  E1.2922 F4500
G1  Y234.833  E0.0507
G1  X49.500  E1.2922 F4550
G1  Y236.167  E0.0507
G1  X15.500  E1.2922 F4600
G1  Y237.500  E0.0507
G1  X49.500  E1.2922 F4650
G1  Y238.833  E0.0507
G1  X15.500  E1.2922 F4700
G1  Y240.167  E0.0507
G1  X49.500  E1.2922 F4750
; WIPE_TOWER_END
M220 R
G1 F42000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y241.000  
; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1 F5400
; WIPE_TOWER_END

; WIPE_START
G1 F7860.442
M73 P68 R7
G1 X47.77 Y239.997 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X52.232 Y233.805 Z1.78 F42000
G1 X128.13 Y128.481 Z1.78
G1 Z1.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F11076.558
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 F11915.874
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 F12892.816
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 F14044.257
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 F15050.934
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 F16213.067
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 F16698.546
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 F18000
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.37991
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351832
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332807
G1 X131.067 Y131.41 E.02094
; LINE_WIDTH: 0.381756
G1 X131.044 Y131.482 E.00208
; LINE_WIDTH: 0.430705
G1 F16420.563
G1 X131.022 Y131.554 E.00238
; LINE_WIDTH: 0.479654
G1 F14831.222
G1 X131 Y131.626 E.00268
; LINE_WIDTH: 0.528603
G1 F13530.105
G1 X130.978 Y131.698 E.00298
; LINE_WIDTH: 0.577552
G1 F12344.959
G1 X130.955 Y131.769 E.00328
; LINE_WIDTH: 0.6265
G1 F11309.503
G1 X130.933 Y131.841 E.00358
G1 X130.9 Y131.784 E.00311
; LINE_WIDTH: 0.587352
G1 F12122.732
G1 X130.868 Y131.728 E.00291
; LINE_WIDTH: 0.548204
G1 F13061.975
G1 X130.835 Y131.671 E.0027
; LINE_WIDTH: 0.509056
G1 F14119.548
G1 X130.802 Y131.614 E.00249
; LINE_WIDTH: 0.469907
G1 F15246.196
G1 X130.794 Y131.548 E.00234
; LINE_WIDTH: 0.424207
G1 F16416.068
G1 X130.785 Y131.481 E.00209
; LINE_WIDTH: 0.378507
G1 F17629.177
G1 X130.777 Y131.415 E.00184
; LINE_WIDTH: 0.332807
G1 F18000
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350608
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382236
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 F17300.813
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 F16213.067
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 F14528.724
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 F13161.411
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 F12029.319
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 F11076.558
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 X127.975 Y128.126 E-.1425
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z1.78 F42000
G1 Z1.38
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F18000
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X127.755 Y129.822 E.01657
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F12000
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429709
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474424
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.51914
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.563855
G1 X128.246 Y131.517 E.00352
; LINE_WIDTH: 0.60857
G1 F11667.993
G1 X128.259 Y131.599 E.00382
; LINE_WIDTH: 0.628822
G1 F11264.683
G1 X128.535 Y131.815 E.01673
G3 X128.602 Y132.46 I-26.599 J3.076 E.03098
G1 X128.463 Y132.614 E.00986
; LINE_WIDTH: 0.6169
G1 F11498.659
G1 X128.463 Y132.685 E.00332
; LINE_WIDTH: 0.574301
G1 F12000
G1 X128.462 Y132.756 E.00308
; LINE_WIDTH: 0.531702
G1 X128.461 Y132.82 E.00255
G1 X128.461 Y132.827 E.00028
; LINE_WIDTH: 0.489103
G1 X128.461 Y132.874 E.00174
G1 X128.46 Y132.898 E.00085
; LINE_WIDTH: 0.446504
M73 P69 R7
G1 X128.46 Y132.938 E.00132
G1 X128.46 Y132.969 E.00102
; LINE_WIDTH: 0.403905
G1 X128.459 Y133.04 E.00209
; LINE_WIDTH: 0.404173
G1 X128.467 Y133.131 E.00268
; LINE_WIDTH: 0.447039
G1 X128.474 Y133.221 E.003
; LINE_WIDTH: 0.489906
G1 X128.482 Y133.312 E.00332
; LINE_WIDTH: 0.532772
G1 X128.488 Y133.382 E.00281
G1 X128.49 Y133.403 E.00083
; LINE_WIDTH: 0.575639
G1 X128.491 Y133.422 E.00084
G1 X128.498 Y133.494 E.00312
; LINE_WIDTH: 0.618505
G1 F11466.595
G1 X128.505 Y133.585 E.00427
; LINE_WIDTH: 0.633991
G1 F11166.171
G1 X128.718 Y133.769 E.01355
G2 X128.801 Y134.241 I2.7 J-.237 E.02312
; LINE_WIDTH: 0.588953
G1 F12000
G1 X128.841 Y134.407 E.00757
; LINE_WIDTH: 0.543915
G1 X128.88 Y134.572 E.00695
; LINE_WIDTH: 0.504985
G2 X128.982 Y135.404 I5.227 J-.22 E.03159
; LINE_WIDTH: 0.462492
G1 X129.032 Y135.684 E.00974
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.476 Y138.33 E.01549
G3 X126.629 Y138.539 I-1.265 J-3.298 E.02688
G1 X126.074 Y138.517 E.01709
G1 X125.539 Y138.377 E.017
G1 X125.045 Y138.127 E.017
G1 X124.616 Y137.778 E.017
G1 X124.3 Y137.383 E.01553
G1 X124.063 Y136.927 E.01581
G1 X123.98 Y136.669 E.00832
G1 X123.867 Y136.047 E.01943
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01656
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489793
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524888
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.861 Y129.965 I-.642 J-.159 E.01439
; LINE_WIDTH: 0.511296
G1 X123.836 Y129.796 E.00653
; LINE_WIDTH: 0.464076
G1 X123.811 Y129.627 E.00587
; LINE_WIDTH: 0.416855
G1 X123.795 Y129.365 E.00799
; LINE_WIDTH: 0.386476
G1 X123.78 Y129.103 E.00734
; LINE_WIDTH: 0.398123
G1 X123.801 Y128.597 E.01468
; LINE_WIDTH: 0.443342
G1 X123.823 Y128.445 E.00501
; LINE_WIDTH: 0.488561
G1 X123.846 Y128.293 E.00558
; LINE_WIDTH: 0.53378
G1 X123.868 Y128.141 E.00615
; LINE_WIDTH: 0.578998
G1 X123.891 Y127.989 E.00671
G1 X123.886 Y125.054 E.12819
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578998
G2 X124.427 Y128.103 I1652.223 J-4.285 E.13325
G2 X124.292 Y128.307 I.163 J.256 E.01099
; LINE_WIDTH: 0.53378
G1 X124.244 Y128.42 E.00492
G1 X124.24 Y128.43 E.00044
; LINE_WIDTH: 0.488561
G1 X124.188 Y128.554 E.00487
; LINE_WIDTH: 0.443342
G1 X124.136 Y128.677 E.00437
; LINE_WIDTH: 0.398123
G1 X124.094 Y129.083 E.0118
; LINE_WIDTH: 0.396719
G1 X124.15 Y129.48 E.01157
; LINE_WIDTH: 0.444275
G1 X124.198 Y129.609 E.00449
; LINE_WIDTH: 0.49183
G1 X124.245 Y129.738 E.00502
; LINE_WIDTH: 0.539385
G1 X124.292 Y129.867 E.00555
; LINE_WIDTH: 0.565229
G1 X124.527 Y130.102 E.01416
G2 X124.358 Y130.326 I.157 J.294 E.01234
; LINE_WIDTH: 0.530137
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.495044
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 F11816.838
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 F12000
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518861
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477569
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.51806
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482597
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.472 Y135.862 E.01328
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01115
G1 X124.814 Y136.471 E.01128
G1 X125.038 Y136.888 E.01454
G1 X125.396 Y137.255 E.01575
G1 X125.829 Y137.491 E.01516
G1 X126.235 Y137.577 E.01275
G1 X126.804 Y137.552 E.0175
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01296
G1 X128.286 Y135.559 E.00852
; LINE_WIDTH: 0.450603
G1 X128.368 Y135.37 E.00688
; LINE_WIDTH: 0.481207
G1 X128.451 Y135.18 E.0074
; LINE_WIDTH: 0.490562
G1 X128.453 Y134.756 E.01545
; LINE_WIDTH: 0.532992
G1 X128.425 Y134.615 E.00574
; LINE_WIDTH: 0.575422
G1 X128.396 Y134.474 E.00624
; LINE_WIDTH: 0.617851
G1 F11479.638
G1 X128.368 Y134.333 E.00673
; LINE_WIDTH: 0.633991
G1 F11166.171
G1 X128.221 Y134.119 E.01249
G1 X127.909 Y133.87 E.01926
; LINE_WIDTH: 0.618505
G1 F11466.595
G1 X128.058 Y133.636 E.01301
M73 P69 R6
G1 X128.07 Y133.547 E.00417
; LINE_WIDTH: 0.571839
G1 F12000
G1 X128.082 Y133.459 E.00384
; LINE_WIDTH: 0.525173
G1 X128.091 Y133.388 E.00282
G1 X128.094 Y133.371 E.00068
; LINE_WIDTH: 0.478506
G1 X128.105 Y133.283 E.00316
; LINE_WIDTH: 0.43184
G1 X128.117 Y133.195 E.00282
; LINE_WIDTH: 0.42877
G1 X128.138 Y133.075 E.00382
; LINE_WIDTH: 0.472367
G1 X128.156 Y132.971 E.0037
G1 X128.159 Y132.955 E.00055
; LINE_WIDTH: 0.515963
G1 X128.172 Y132.876 E.0031
G1 X128.179 Y132.836 E.00158
; LINE_WIDTH: 0.55956
G1 X128.185 Y132.806 E.00128
G1 X128.2 Y132.716 E.00383
; LINE_WIDTH: 0.603156
G1 F11780.75
G1 X128.221 Y132.596 E.00554
; LINE_WIDTH: 0.628822
G1 F11264.683
G1 X128.043 Y132.188 E.02127
G1 X127.88 Y132.019 E.01123
; LINE_WIDTH: 0.60857
G1 F11667.993
G1 X127.631 Y131.827 E.01446
G1 X127.762 Y131.687 E.0088
G1 X127.779 Y131.62 E.00323
; LINE_WIDTH: 0.581418
G1 F12000
G1 X127.797 Y131.552 E.00307
; LINE_WIDTH: 0.554266
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509987
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 F11644.874
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 F11547.748
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 F12000
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500956
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.002 J-2.283 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.819 I27.161 J-1.754 E.04786
G1 X130.408 Y131.713 E.00352
G1 X130.363 Y131.687 E.00159
G1 X130.231 Y131.611 E.0047
G1 X130.378 Y131.492 E.00581
G1 X130.406 Y131.47 E.00108
G1 X130.447 Y131.36 E.00363
G1 X130.443 Y130.518 E.02586
G1 X130.317 Y129.634 E.02743
G1 X130.301 Y129.626 E.00057
G1 X130.25 Y129.602 E.00171
G1 X130.094 Y129.527 E.00534
G2 X130.242 Y129.41 I-.102 J-.281 E.00589
G1 X130.282 Y129.361 E.00195
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604787
G1 F11746.552
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 F11841.602
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 F12000
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z1.78 F42000
G1 Z1.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.532566
G1 F13479.125
G1 X124.456 Y136.735 E.01599
; LINE_WIDTH: 0.544146
G1 F13167.713
G1 X124.743 Y137.228 E.02328
; LINE_WIDTH: 0.56584
G1 F12621.433
G1 X125.165 Y137.642 E.02521
; LINE_WIDTH: 0.587058
G1 F12129.276
G1 X125.616 Y137.899 E.02302
; LINE_WIDTH: 0.617062
G1 F11495.415
G1 X126.119 Y138.036 E.0244
G1 X126.401 Y138.055 E.0132
; LINE_WIDTH: 0.613938
G1 F11558.305
G1 X126.922 Y138.006 E.02437
; LINE_WIDTH: 0.61336
G1 F11570.016
G1 X127.507 Y137.775 E.02924
; LINE_WIDTH: 0.61833
G1 F11470.082
G1 X128.003 Y137.387 E.02953
G1 X128.356 Y136.869 E.02941
; LINE_WIDTH: 0.597954
G1 F11891.164
G1 X128.534 Y136.351 E.02476
; LINE_WIDTH: 0.58543
G1 F12165.675
G1 X128.57 Y135.936 E.01843
; WIPE_START
G1 X128.534 Y136.351 E-.15846
G1 X128.356 Y136.869 E-.20804
G1 X128.003 Y137.387 E-.23831
G1 X127.681 Y137.639 E-.15519
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z1.78 F42000
G1 Z1.38
G1 E.8 F1800
; LINE_WIDTH: 0.573202
G1 F12446.208
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60127
G1 F11820.542
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 F10904.513
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 F10934.467
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 F11232.59
G1 X130.933 Y131.841 E.02986
; WIPE_START
G1 X130.951 Y132.465 E-.23702
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19078
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z1.78 F42000
G1 Z1.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F12061.669
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586813
G1 F12134.74
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559039
G1 F12787.748
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530404
G1 F13538.92
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500907
G1 F14410.905
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 1.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F14410.905
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/50
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
M106 S201.45
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z1.98 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z1.98
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.98 F4000
            G39.3 S1
            G0 Z1.98 F4000
            G392 S0
          
        M623
    
    M623
M623


G1 X49.5 Y241 F42000
G1 Z2.38
G1 Z1.58
G1 E.8 F1800
; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1  X49.500 Y241.000 F5400
G1  X15.500  E1.2922
G1  Y221.500  E0.7411
G1  X49.500  E1.2922
G1  Y241.000  E0.7411
G1  X16.500 Y221.500  
;--------------------
; CP EMPTY GRID START
; layer #9
G1  Y241.000  E0.7411
G1  X24.500 
G1  Y221.500  E0.7411
G1  X32.500 
G1  Y241.000  E0.7411
G1  X40.500 
G1  Y221.500  E0.7411
G1  X48.500 
G1  Y241.000  E0.7411
; CP EMPTY GRID END
;------------------






G1  X50.000 
G1  Y241.500 
G1  X15.000  E1.3302
G1  Y221.000  E0.7791
G1  X50.000  E1.3302
G1  Y241.500  E0.7791
; WIPE_TOWER_END

; WIPE_START
G1 F14410.905
G1 X48 Y241.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X52.414 Y235.274 Z1.98 F42000
G1 X128.13 Y128.481 Z1.98
G1 Z1.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F11076.576
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 F11915.889
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 F12892.825
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 F14044.257
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 F15050.934
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 F16213.067
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438165
G1 F16698.504
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 F18000
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.37991
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351832
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332809
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381757
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 F16418.159
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 F14828.959
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528602
G1 F13527.956
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.57755
G1 F12344.99
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 F11309.543
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587431
G1 F12120.985
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548363
G1 F13057.865
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509295
G1 F14113.052
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470227
G1 F15445.569
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424421
G1 F16180.808
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378615
G1 F16933.142
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332809
G1 F18000
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 F17300.813
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 F16213.067
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 F14528.732
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 F13161.424
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 F12029.336
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 F11076.576
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z1.98 F42000
G1 Z1.58
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F18000
G1 X128.145 Y130.317 E.01311
G1 X127.886 Y129.978 E.01105
G1 X127.755 Y129.822 E.00528
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530838
G1 F12000
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429674
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474354
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.519035
G1 X128.232 Y131.436 E.00321
; LINE_WIDTH: 0.563715
G1 X128.246 Y131.517 E.00351
; LINE_WIDTH: 0.608395
G1 F11671.604
G1 X128.259 Y131.599 E.00382
; LINE_WIDTH: 0.628991
G1 F11261.434
G1 X128.535 Y131.815 E.01674
G3 X128.602 Y132.461 I-28.164 J3.234 E.031
G2 X128.464 Y132.626 I.168 J.281 E.01047
; LINE_WIDTH: 0.604731
G1 F11747.724
G1 X128.462 Y132.737 E.00508
G1 X128.462 Y132.747 E.00045
; LINE_WIDTH: 0.562404
G1 F12000
G1 X128.461 Y132.781 E.00145
G1 X128.46 Y132.868 E.00367
; LINE_WIDTH: 0.520077
G1 X128.457 Y132.988 E.0047
; LINE_WIDTH: 0.47775
G1 X128.455 Y133.109 E.00428
; LINE_WIDTH: 0.435423
G1 X128.455 Y133.123 E.00045
G1 X128.453 Y133.23 E.00342
; LINE_WIDTH: 0.419999
G1 X128.538 Y133.463 E.00761
G1 X128.833 Y133.713 E.01187
G1 X128.868 Y134.057 E.01064
; LINE_WIDTH: 0.459771
G1 X128.873 Y134.311 E.00862
; LINE_WIDTH: 0.499542
G1 X128.879 Y134.565 E.00944
; LINE_WIDTH: 0.504597
G2 X128.982 Y135.402 I5.382 J-.238 E.03179
; LINE_WIDTH: 0.462298
G1 X129.032 Y135.684 E.00979
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489793
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524888
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.861 Y129.968 I-.635 J-.158 E.01429
; LINE_WIDTH: 0.511802
G1 X123.836 Y129.801 E.00644
; LINE_WIDTH: 0.465088
G1 X123.812 Y129.634 E.0058
; LINE_WIDTH: 0.418373
G1 X123.796 Y129.371 E.00806
; LINE_WIDTH: 0.387296
G1 X123.78 Y129.108 E.00739
; LINE_WIDTH: 0.397394
G1 X123.8 Y128.601 E.01466
; LINE_WIDTH: 0.442796
G1 X123.823 Y128.448 E.00504
; LINE_WIDTH: 0.488197
G1 X123.846 Y128.295 E.00561
; LINE_WIDTH: 0.533599
G1 X123.868 Y128.142 E.00618
; LINE_WIDTH: 0.579
G1 X123.891 Y127.989 E.00676
G1 X123.886 Y125.054 E.1282
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.912 Y119.964 E.12385
; LINE_WIDTH: 0.541066
G1 X123.936 Y117.891 E.08416
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01007
; LINE_WIDTH: 0.541066
G1 X124.41 Y119.965 E.0841
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.12379
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579
G2 X124.427 Y128.103 I1658.839 J-4.308 E.13325
G2 X124.292 Y128.308 I.164 J.256 E.01103
; LINE_WIDTH: 0.533599
G1 X124.245 Y128.419 E.0048
G1 X124.24 Y128.432 E.00059
; LINE_WIDTH: 0.488197
G1 X124.188 Y128.557 E.0049
; LINE_WIDTH: 0.442796
G1 X124.136 Y128.681 E.0044
; LINE_WIDTH: 0.397394
G1 X124.094 Y129.088 E.01182
; LINE_WIDTH: 0.398223
G1 X124.152 Y129.487 E.01167
; LINE_WIDTH: 0.444855
G1 X124.198 Y129.613 E.00438
; LINE_WIDTH: 0.491487
G1 X124.244 Y129.738 E.00489
; LINE_WIDTH: 0.538119
G1 X124.29 Y129.864 E.0054
; LINE_WIDTH: 0.565311
G1 X124.527 Y130.102 E.01428
G2 X124.358 Y130.326 I.157 J.294 E.01233
; LINE_WIDTH: 0.530191
G1 X124.293 Y130.463 E.00604
; LINE_WIDTH: 0.495071
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 F11816.838
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 F12000
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01296
G1 X128.287 Y135.558 E.00858
; LINE_WIDTH: 0.450603
G1 X128.369 Y135.367 E.00691
; LINE_WIDTH: 0.481206
G1 X128.451 Y135.176 E.00743
; LINE_WIDTH: 0.490789
G1 X128.452 Y134.75 E.01553
G1 X128.364 Y134.556 E.00779
; LINE_WIDTH: 0.459965
G1 X128.276 Y134.362 E.00725
; LINE_WIDTH: 0.429141
G1 X128.073 Y134.106 E.01027
; LINE_WIDTH: 0.419999
G1 X127.736 Y133.875 E.01255
G1 X127.847 Y133.765 E.00481
G1 X128.062 Y133.441 E.01196
G1 X128.119 Y133.204 E.00747
; LINE_WIDTH: 0.435423
G1 X128.139 Y133.081 E.00399
; LINE_WIDTH: 0.47775
G1 X128.158 Y132.964 E.0042
G1 X128.159 Y132.958 E.00022
; LINE_WIDTH: 0.520077
G1 X128.174 Y132.867 E.00359
G1 X128.179 Y132.835 E.00126
; LINE_WIDTH: 0.562404
G1 X128.185 Y132.8 E.00148
G1 X128.199 Y132.712 E.0038
; LINE_WIDTH: 0.604731
G1 F11747.724
G1 X128.219 Y132.589 E.00571
; LINE_WIDTH: 0.628991
G1 F11261.434
G1 X128.038 Y132.18 E.02137
G1 X127.881 Y132.02 E.01068
; LINE_WIDTH: 0.608395
G1 F11671.604
G1 X127.631 Y131.827 E.01456
G1 X127.762 Y131.687 E.00883
G1 X127.78 Y131.619 E.00322
; LINE_WIDTH: 0.581331
G1 F12000
G1 X127.797 Y131.552 E.00306
; LINE_WIDTH: 0.554267
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509988
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465708
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 F11644.874
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 F11547.748
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 F12000
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500956
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.035 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00163
G1 X130.307 Y133.638 E.00462
G1 X130.446 Y133.509 E.00583
G1 X130.472 Y133.485 E.00107
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.5 J1.385 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.369 Y131.69 E.0014
G1 X130.229 Y131.61 E.00497
G1 X130.382 Y131.489 E.00598
G1 X130.406 Y131.471 E.00093
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604786
G1 F11746.573
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 F11841.624
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 F12000
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X130.933 Y131.841 Z1.98 F42000
G1 Z1.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.630496
G1 F11232.59
G1 X130.951 Y132.465 E.02989
; LINE_WIDTH: 0.646514
G1 F10934.502
G1 X130.995 Y133.338 E.043
; LINE_WIDTH: 0.648174
G1 F10904.513
G1 X131.045 Y133.849 E.02533
G1 X131.218 Y134.637 E.03979
; LINE_WIDTH: 0.60127
G1 F11820.542
G1 X131.31 Y134.865 E.01118
; LINE_WIDTH: 0.5732
G1 F12446.255
G1 X131.401 Y135.093 E.01062
; WIPE_START
G1 X131.31 Y134.865 E-.09339
G1 X131.218 Y134.637 E-.09339
G1 X131.045 Y133.849 E-.30657
G1 X130.995 Y133.338 E-.19513
G1 X130.985 Y133.15 E-.07152
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.935 Z1.98 F42000
G1 Z1.58
G1 E.8 F1800
; LINE_WIDTH: 0.599718
G1 F11853.491
G1 X128.562 Y136.195 E.01181
; LINE_WIDTH: 0.621312
G1 F11410.947
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.625278
G1 F11333.235
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.61531
G1 F11530.6
G1 X127.431 Y137.816 E.02952
; LINE_WIDTH: 0.623082
G1 F11376.133
G1 X126.81 Y138.032 E.0311
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600724
G1 F11832.113
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583736
G1 F12203.781
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581114
M73 P70 R6
G1 F12263.236
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.549034
G1 F13040.541
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530458
G1 F13537.406
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 X124.459 Y136.736 E-.15298
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z1.98 F42000
G1 X128.986 Y127.549 Z1.98
G1 Z1.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F12061.646
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586815
G1 F12134.695
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 F12787.7
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 F13538.863
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 F14410.842
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 1.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F14410.842
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/50
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
M106 S183.6
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z2.18 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z2.18
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.18 F4000
            G39.3 S1
            G0 Z2.18 F4000
            G392 S0
          
        M623
    
    M623
M623


; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
;--------------------
; CP TOOLCHANGE START
; toolchange #4
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; filament end gcode 
M106 P3 S0

G1 E-1.2 F1800
;===== A1 20240913 =======================
M1007 S0 ; turn off mass estimation
G392 S0
M620 S0A
M204 S9000

G17
G2 Z2.18 I0.86 J0.86 P1 F10000 ; spiral lift a little from second lift

G1 Z4.78 F1200

M400
M106 P1 S0
M106 P2 S0

M104 S220


G1 X267 F18000


M620.11 S1 I2 E-18 F1200

M400

M620.1 E F548 T240
M620.10 A0 F548
T0
M620.1 E F299 T240
M620.10 A1 F299 L59.4525 H0.4 T240

G1 Y128 F9000




M620.11 S1 I2 E18 F548
M628 S1
G92 E0
G1 E18 F548
M400
M629 S1


M400
G92 E0
M628 S0


; FLUSH_START
; always use highest temperature to flush
M400
M1002 set_filament_type:UNKNOWN
M109 S240
M106 P1 S60

G1 E23.7 ; do not need pulsatile flushing for start part
G1 E0.71505 F50
G1 E8.22307 F548
G1 E0.71505 F50
G1 E8.22307 F299
G1 E0.71505 F50
G1 E8.22307 F299
G1 E0.71505 F50
G1 E8.22307 F299

; FLUSH_END
G1 E-2 F1800
G1 E2 F300
M400
M1002 set_filament_type:PLA














M629

M400
M106 P1 S60
M109 S220
G1 E6 F299 ;Compensate for filament spillage during waiting temperature
M400
G92 E0
G1 E-2 F1800
M400
M106 P1 S178
M400 S3
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
G1 Z4.78
M106 P1 S0

M204 S6000



M622.1 S0
M9833 F5 A0.3 ; cali dynamic extrusion compensation
M1002 judge_flag filament_need_cali_flag
M622 J1
  G92 E0
  G1 E-2 F1800
  M400
  
  M106 P1 S178
  M400 S4
  G1 X-38.2 F18000
  G1 X-48.2 F3000
  G1 X-38.2 F18000 ;wipe and shake
  G1 X-48.2 F3000
  G1 X-38.2 F12000 ;wipe and shake
  G1 X-48.2 F3000
  M400
  M106 P1 S0 
M623

M621 S0A
G392 S0

M1007 S1
M106 S183.6
M106 P2 S178
G1 X15 Y221 F42000
G1 Z5.18
G1 Z1.78
M73 P74 R5
G1 E2 F1800

; filament start gcode
M106 P3 S255
;Prevent PLA from jamming



G4 S0
G1  X50.000 Y221.000  E1.3302
G1  Y241.500  E0.7791
G1  X15.000  E1.3302
G1  Y221.000  E0.7791
G1  X15.500 Y221.500  
; CP TOOLCHANGE WIPE
G1  X49.500  E1.2922 F1584
G1  Y222.833  E0.0507
G1  X15.500  E1.2922 F1800
G1  Y224.167  E0.0507
G1  X49.500  E1.2922 F2198
G1  Y225.500  E0.0507
G1  X15.500  E1.2922 F4200
M73 P75 R5
G1  Y226.833  E0.0507
G1  X49.500  E1.2922 F4250
G1  Y228.167  E0.0507
G1  X15.500  E1.2922 F4300
G1  Y229.500  E0.0507
G1  X49.500  E1.2922 F4350
G1  Y230.833  E0.0507
G1  X15.500  E1.2922 F4400
G1  Y232.167  E0.0507
G1  X49.500  E1.2922 F4450
M73 P76 R5
G1  Y233.500  E0.0507
G1  X15.500  E1.2922 F4500
G1  Y234.833  E0.0507
G1  X49.500  E1.2922 F4550
G1  Y236.167  E0.0507
G1  X15.500  E1.2922 F4600
G1  Y237.500  E0.0507
G1  X49.500  E1.2922 F4650
G1  Y238.833  E0.0507
G1  X15.500  E1.2922 F4700
G1  Y240.167  E0.0507
G1  X49.500  E1.2922 F4750
; WIPE_TOWER_END
M220 R
G1 F42000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y241.000  
; LAYER_HEIGHT: 0,200000
; FEATURE: Prime tower
; LINE_WIDTH: 0,500000
; WIPE_TOWER_START
G1 F5400
; WIPE_TOWER_END

; WIPE_START
G1 F14410.842
G1 X47.77 Y239.997 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X52.232 Y233.805 Z2.18 F42000
G1 X128.13 Y128.481 Z2.18
G1 Z1.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F6041.759
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 F6499.56
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554835
G1 F7032.427
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512865
G1 F7660.471
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 F8209.581
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 F9108.298
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 F9861.176
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 F10682.794
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
M73 P77 R5
G1 F11653.768
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332811
G1 F12418.461
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 F10312.926
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430705
G1 F9214.635
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479652
G1 F8243.051
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528599
G1 F7412.313
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577546
G1 F6733.69
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626492
G1 F6168.905
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587427
G1 F6611.491
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548361
G1 F7122.493
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509296
G1 F7719.101
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.47023
G1 F8424.797
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424424
G1 F8970.034
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378618
G1 F9532.362
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332811
G1 F12418.461
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 F11699.953
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G1 F10609.235
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 F10157.025
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 F9436.807
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 F8843.491
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 F7924.759
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 F7178.952
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 F6561.447
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 F6041.759
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z2.18 F42000
G1 Z1.78
G1 E.8 F1800
; LINE_WIDTH: 0.360701
G1 F11328.556
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530841
G1 F7378.244
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493894
G1 F7982.727
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456947
G1 F8695.098
G1 X128.449 Y129.63 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 F8909.386
G1 X128.465 Y129.64 E.00051
G1 F9547.071
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 F10335.888
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429638
G1 F9309.108
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474283
G1 F8345.64
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.518928
G1 F7562.898
G1 X128.232 Y131.435 E.00321
; LINE_WIDTH: 0.563573
G1 F6914.394
G1 X128.246 Y131.517 E.00351
; LINE_WIDTH: 0.608218
G1 F6368.322
G1 X128.259 Y131.599 E.00381
; LINE_WIDTH: 0.62921
G1 F6140.306
G1 X128.535 Y131.815 E.01675
G3 X128.603 Y132.47 I-30.173 J3.442 E.03145
G1 X128.456 Y132.629 E.01035
; LINE_WIDTH: 0.605697
G1 F6396.85
G1 X128.455 Y132.694 E.00297
; LINE_WIDTH: 0.560233
G1 F6959.044
G1 X128.454 Y132.759 E.00273
; LINE_WIDTH: 0.514768
G1 F7629.578
G1 X128.453 Y132.823 E.00249
; LINE_WIDTH: 0.469304
G1 F8433.602
G1 X128.452 Y132.888 E.00225
; LINE_WIDTH: 0.423839
G1 F9277.909
G1 X128.451 Y132.953 E.00201
; LINE_WIDTH: 0.424022
G1 F9446.29
G1 X128.436 Y133.034 E.00257
; LINE_WIDTH: 0.46967
G1 F8435.852
G1 X128.422 Y133.116 E.00288
; LINE_WIDTH: 0.515318
G1 F7620.692
G1 X128.407 Y133.198 E.00319
; LINE_WIDTH: 0.560966
G1 F6949.19
G1 X128.393 Y133.279 E.0035
; LINE_WIDTH: 0.606614
G1 F6386.444
G1 X128.378 Y133.361 E.00381
; LINE_WIDTH: 0.622779
G1 F6208.406
G1 X128.541 Y133.616 E.0143
; LINE_WIDTH: 0.628232
G1 F6150.566
G1 X128.734 Y133.766 E.01166
G2 X128.802 Y134.226 I1.85 J-.038 E.0222
; LINE_WIDTH: 0.585558
G1 F6634.257
G1 X128.84 Y134.391 E.00752
; LINE_WIDTH: 0.542884
G1 F7200.519
G1 X128.878 Y134.557 E.00693
; LINE_WIDTH: 0.504208
G1 F7804.235
G1 X128.932 Y135.117 E.02114
G2 X128.982 Y135.401 I5.488 J-.816 E.01083
; LINE_WIDTH: 0.462104
G1 F8588.125
G1 X129.032 Y135.684 E.00984
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 F8946.367
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 F8742.554
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 F8055.962
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 F7469.36
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G1 F6962.388
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 F7579.974
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 F8317.788
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 F9214.727
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 F8861.097
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 F7998.48
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 F7288.913
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G1 F6694.984
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566564
G1 F6874.9
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 F7489.042
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 F8223.672
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 F8318.307
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 F7591.915
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G1 F6982.198
G2 X123.861 Y129.97 I-.629 J-.157 E.01419
; LINE_WIDTH: 0.512315
G1 F7669.457
G1 X123.837 Y129.806 E.00636
; LINE_WIDTH: 0.466112
G1 F8506.784
G1 X123.812 Y129.641 E.00573
; LINE_WIDTH: 0.419909
G1 F9549.351
G1 X123.796 Y129.377 E.00813
; LINE_WIDTH: 0.388125
G1 F10428.586
G1 X123.78 Y129.113 E.00744
; LINE_WIDTH: 0.39667
G1 F10176.679
G1 X123.8 Y128.605 E.01465
; LINE_WIDTH: 0.442253
G1 F9015.043
G1 X123.823 Y128.451 E.00507
; LINE_WIDTH: 0.487835
G1 F8091.433
G1 X123.845 Y128.297 E.00564
; LINE_WIDTH: 0.533418
G1 F7339.486
G1 X123.868 Y128.143 E.00622
; LINE_WIDTH: 0.579
G1 F6715.416
G1 X123.891 Y127.989 E.0068
G1 X123.886 Y125.054 E.12821
; LINE_WIDTH: 0.573606
G1 F6783.672
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X123.912 Y119.984 E.123
; LINE_WIDTH: 0.541243
G1 F7224.23
G1 X123.936 Y117.891 E.085
; LINE_WIDTH: 0.522564
G1 F7505.567
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01007
; LINE_WIDTH: 0.541243
G1 F7224.23
G1 X124.41 Y119.985 E.08494
; LINE_WIDTH: 0.563164
G1 F6919.83
G1 X124.412 Y122.885 E.12294
; LINE_WIDTH: 0.573606
G1 F6783.672
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579
G1 F6715.416
G2 X124.427 Y128.104 I1665.663 J-4.331 E.13326
G2 X124.291 Y128.309 I.165 J.257 E.01106
; LINE_WIDTH: 0.533418
G1 F7339.486
G1 X124.246 Y128.417 E.00469
G1 X124.239 Y128.434 E.00074
; LINE_WIDTH: 0.487835
G1 F8091.433
G1 X124.187 Y128.56 E.00493
; LINE_WIDTH: 0.442253
G1 F9015.043
G1 X124.135 Y128.685 E.00442
; LINE_WIDTH: 0.39667
G1 F10176.679
G1 X124.094 Y129.094 E.01185
; LINE_WIDTH: 0.399737
G1 F10089.206
G1 X124.155 Y129.495 E.01178
; LINE_WIDTH: 0.44545
G1 F8943.432
G1 X124.199 Y129.617 E.00427
; LINE_WIDTH: 0.491163
G1 F8031.358
G1 X124.244 Y129.739 E.00476
; LINE_WIDTH: 0.536876
G1 F7288.098
G1 X124.289 Y129.861 E.00524
; LINE_WIDTH: 0.565389
G1 F6890.361
G1 X124.527 Y130.102 E.01441
G2 X124.358 Y130.326 I.157 J.294 E.01233
; LINE_WIDTH: 0.530243
G1 F7387.302
G1 X124.293 Y130.463 E.00604
; LINE_WIDTH: 0.495097
G1 F7961.496
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.45995
G1 F8632.472
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 F9263.893
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 F9118.102
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 F8223.672
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 F7489.042
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566564
G1 F6874.9
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 F6445.56
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 F6960.118
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 F7563.957
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 F8282.526
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 F9032.686
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 F9634.015
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 F8541.493
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 F7671.522
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 F6962.388
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 F6592.61
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 F7050.478
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 F7576.693
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 F8187.791
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 F8817.748
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 F8946.367
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01297
G1 X128.288 Y135.556 E.00863
; LINE_WIDTH: 0.450599
G1 F8830.488
G1 X128.37 Y135.364 E.00694
; LINE_WIDTH: 0.481198
G1 F8213.964
G1 X128.452 Y135.172 E.00746
; LINE_WIDTH: 0.491019
G1 F8033.939
G1 X128.451 Y134.744 E.01561
; LINE_WIDTH: 0.532042
G1 F7360.127
G1 X128.42 Y134.603 E.00578
; LINE_WIDTH: 0.573065
G1 F6790.595
G1 X128.389 Y134.461 E.00626
; LINE_WIDTH: 0.614088
G1 F6302.874
G1 X128.358 Y134.32 E.00675
; LINE_WIDTH: 0.621489
G1 F6222.248
G1 X128.191 Y134.091 E.01335
; LINE_WIDTH: 0.622779
G1 F6208.406
G1 X127.913 Y133.87 E.0168
G1 X128.173 Y133.453 E.02321
G1 X128.168 Y133.367 E.00405
; LINE_WIDTH: 0.574021
G1 F6778.374
G1 X128.163 Y133.282 E.00371
; LINE_WIDTH: 0.525263
G1 F7463.575
G1 X128.159 Y133.196 E.00337
; LINE_WIDTH: 0.476505
G1 F8302.882
G1 X128.154 Y133.11 E.00303
; LINE_WIDTH: 0.427747
G1 F9354.873
G1 X128.149 Y133.025 E.00269
; LINE_WIDTH: 0.42433
G1 F9438.666
G1 X128.163 Y132.936 E.00279
; LINE_WIDTH: 0.469672
G1 F8435.821
G1 X128.177 Y132.847 E.00312
; LINE_WIDTH: 0.515014
G1 F7625.61
G1 X128.19 Y132.759 E.00345
; LINE_WIDTH: 0.560356
G1 F6957.393
G1 X128.204 Y132.67 E.00378
; LINE_WIDTH: 0.605697
G1 F6396.85
G1 X128.218 Y132.581 E.00411
; LINE_WIDTH: 0.62921
G1 F6140.306
G1 X128.032 Y132.172 E.02148
G1 X127.883 Y132.021 E.01012
; LINE_WIDTH: 0.608218
G1 F6368.322
G1 X127.631 Y131.827 E.01467
G2 X127.758 Y131.646 I-.15 J-.241 E.01048
; LINE_WIDTH: 0.581244
G1 F6687.422
G1 X127.797 Y131.552 E.00447
; LINE_WIDTH: 0.55427
G1 F7040.188
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 F7513.627
G1 X127.82 Y131.347 E.00152
G1 F7707.633
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 F8514.885
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 F8546.172
G1 X127.852 Y131.055 E.00008
G1 F8781.137
G1 X127.854 Y131.037 E.00056
G1 F9511.015
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 F8480.51
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514847
G1 F7628.306
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562271
G1 F6931.739
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609694
G1 F6351.738
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 F6298.772
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 F6745.3
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 F7259.967
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 F7859.662
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 F8621.578
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 F9547.071
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.031 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.486 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 F8505.094
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 F7668.18
G1 X128.547 Y128.795 E.00443
G1 F7251.01
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 F6981.22
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604786
G1 F6407.222
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 F6459.056
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565559
G1 F6888.12
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.63 E-.02581
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.019
G1 X128.665 Y129.736 E-.06527
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z2.18 F42000
G1 Z1.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573198
G1 F6788.892
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601266
G1 F6447.615
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 F5947.916
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 F5964.255
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 F6126.867
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19059
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z2.18 F42000
G1 Z1.78
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F7384.04
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549034
G1 F7113.022
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 F6689.013
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583736
G1 F6656.608
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 F6453.88
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.62308
G1 F6205.185
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.61531
G1 F6289.418
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 F6181.722
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 F6224.131
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599724
G1 F6465.471
G1 X128.57 Y135.935 E.01183
; WIPE_START
G1 X128.562 Y136.195 E-.09907
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.681 Y137.635 E-.12312
; WIPE_END
G1 E-.04 F1800
G1 X128.66 Y130.066 Z2.18 F42000
G1 X128.986 Y127.549 Z2.18
G1 Z1.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F6579.092
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 F6618.943
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 F6975.115
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 F7384.843
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500907
G1 F7860.485
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 1.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.485
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/50
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
M106 S204
G17
G3 Z2.18 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z2.18
G1 Z1.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.37991
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351832
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332809
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381757
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528602
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.57755
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.58743
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548362
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509294
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470225
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.42442
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378615
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332809
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382248
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z2.38 F42000
G1 Z1.98
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530838
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429602
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474211
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.51882
G1 X128.232 Y131.435 E.00321
; LINE_WIDTH: 0.563429
G1 X128.246 Y131.517 E.00351
; LINE_WIDTH: 0.608038
G1 X128.259 Y131.599 E.00381
; LINE_WIDTH: 0.629474
G1 X128.535 Y131.815 E.01676
G3 X128.602 Y132.468 I-33.551 J3.781 E.03139
G1 X128.459 Y132.622 E.01005
; LINE_WIDTH: 0.607705
G1 X128.455 Y132.692 E.00325
; LINE_WIDTH: 0.55803
G1 X128.451 Y132.763 E.00296
; LINE_WIDTH: 0.508354
G1 X128.448 Y132.833 E.00268
; LINE_WIDTH: 0.458678
G1 X128.444 Y132.904 E.00239
; LINE_WIDTH: 0.450556
G1 X128.429 Y132.995 E.00306
; LINE_WIDTH: 0.492109
G1 X128.415 Y133.086 E.00337
; LINE_WIDTH: 0.533662
G1 X128.414 Y133.093 E.0003
G1 X128.4 Y133.176 E.00338
; LINE_WIDTH: 0.575215
G1 X128.386 Y133.267 E.00399
; LINE_WIDTH: 0.616768
G1 X128.371 Y133.358 E.0043
; LINE_WIDTH: 0.622686
G1 X128.542 Y133.617 E.01465
; LINE_WIDTH: 0.628009
G1 X128.734 Y133.766 E.01158
G2 X128.801 Y134.218 I1.834 J-.04 E.02184
; LINE_WIDTH: 0.585634
G1 X128.839 Y134.384 E.00752
; LINE_WIDTH: 0.543259
G1 X128.877 Y134.549 E.00694
; LINE_WIDTH: 0.50382
G1 X128.932 Y135.114 E.02129
G2 X128.982 Y135.399 I5.653 J-.84 E.01088
; LINE_WIDTH: 0.46191
G1 X129.032 Y135.684 E.00989
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489793
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524888
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.861 Y129.973 I-.622 J-.157 E.01408
; LINE_WIDTH: 0.512831
G1 X123.837 Y129.811 E.00627
; LINE_WIDTH: 0.467145
G1 X123.813 Y129.649 E.00566
; LINE_WIDTH: 0.421459
G1 X123.797 Y129.384 E.0082
; LINE_WIDTH: 0.388961
G1 X123.78 Y129.118 E.0075
; LINE_WIDTH: 0.395949
G1 X123.8 Y128.61 E.01464
; LINE_WIDTH: 0.441712
G1 X123.822 Y128.455 E.00509
; LINE_WIDTH: 0.487475
G1 X123.845 Y128.3 E.00568
; LINE_WIDTH: 0.533238
G1 X123.868 Y128.145 E.00626
; LINE_WIDTH: 0.579
G1 X123.891 Y127.99 E.00685
G1 X123.886 Y125.054 E.12822
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.912 Y120.004 E.12215
; LINE_WIDTH: 0.541419
G1 X123.936 Y117.891 E.08584
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01007
; LINE_WIDTH: 0.541419
G1 X124.41 Y120.005 E.08578
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.12209
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579
G2 X124.427 Y128.104 I1656.896 J-4.301 E.13326
G2 X124.291 Y128.31 I.166 J.257 E.0111
; LINE_WIDTH: 0.533238
G1 X124.247 Y128.415 E.00457
G1 X124.239 Y128.436 E.0009
; LINE_WIDTH: 0.487475
G1 X124.203 Y128.522 E.00335
G1 X124.195 Y128.542 E.00082
G1 X124.186 Y128.562 E.00078
; LINE_WIDTH: 0.441712
G1 X124.134 Y128.689 E.00445
; LINE_WIDTH: 0.395949
G1 X124.094 Y129.1 E.01187
; LINE_WIDTH: 0.401255
G1 X124.157 Y129.502 E.01188
; LINE_WIDTH: 0.446044
G1 X124.2 Y129.621 E.00416
; LINE_WIDTH: 0.490832
G1 X124.244 Y129.74 E.00462
; LINE_WIDTH: 0.53562
G1 X124.287 Y129.858 E.00508
; LINE_WIDTH: 0.565467
G1 X124.527 Y130.102 E.01453
G2 X124.358 Y130.326 I.157 J.294 E.01232
; LINE_WIDTH: 0.530295
G1 X124.293 Y130.463 E.00604
; LINE_WIDTH: 0.495123
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01297
G1 X128.288 Y135.555 E.00868
; LINE_WIDTH: 0.450592
G1 X128.37 Y135.361 E.00698
; LINE_WIDTH: 0.481184
G1 X128.452 Y135.168 E.0075
; LINE_WIDTH: 0.491254
G1 X128.45 Y134.739 E.01569
; LINE_WIDTH: 0.532349
G1 X128.418 Y134.597 E.00581
; LINE_WIDTH: 0.573444
G1 X128.386 Y134.455 E.0063
; LINE_WIDTH: 0.614538
G1 X128.354 Y134.313 E.00678
; LINE_WIDTH: 0.621162
G1 X128.191 Y134.09 E.01297
; LINE_WIDTH: 0.622686
G1 X127.914 Y133.871 E.01671
G2 X128.199 Y133.371 I-4.614 J-2.962 E.0272
; LINE_WIDTH: 0.616768
G1 X128.19 Y133.296 E.0035
; LINE_WIDTH: 0.568752
G1 X128.181 Y133.222 E.00321
; LINE_WIDTH: 0.520735
G1 X128.171 Y133.148 E.00291
; LINE_WIDTH: 0.472718
G1 X128.162 Y133.074 E.00262
; LINE_WIDTH: 0.424701
G1 X128.153 Y132.999 E.00233
; LINE_WIDTH: 0.422889
G1 X128.166 Y132.914 E.00266
; LINE_WIDTH: 0.469093
G1 X128.178 Y132.829 E.00299
; LINE_WIDTH: 0.515297
G1 X128.191 Y132.744 E.00331
; LINE_WIDTH: 0.561501
G1 X128.204 Y132.659 E.00364
; LINE_WIDTH: 0.607705
G1 X128.217 Y132.574 E.00396
; LINE_WIDTH: 0.629474
G1 X128.026 Y132.164 E.02159
G1 X127.885 Y132.022 E.00956
; LINE_WIDTH: 0.608038
G1 X127.63 Y131.827 E.01478
G2 X127.758 Y131.646 I-.151 J-.242 E.01049
; LINE_WIDTH: 0.581153
G1 X127.797 Y131.552 E.00447
; LINE_WIDTH: 0.554268
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509988
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465708
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.031 J-2.284 E.15108
G2 X131.672 Y134.53 I9.527 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.495 J1.385 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604787
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01894
G1 X128.665 Y129.736 E-.06533
G1 X128.525 Y129.856 E-.07001
G1 X128.491 Y129.898 E-.02056
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z2.38 F42000
G1 Z1.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19059
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.935 Z2.38 F42000
G1 Z1.98
G1 E.8 F1800
; LINE_WIDTH: 0.599722
G1 F1200
G1 X128.562 Y136.195 E.01184
; LINE_WIDTH: 0.621314
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.61531
G1 X127.431 Y137.816 E.02952
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0311
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600724
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583738
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581118
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.549032
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530458
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.04
G1 X124.459 Y136.736 E-.15298
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z2.38 F42000
G1 X128.986 Y127.549 Z2.38
G1 Z1.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.50091
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 2.18
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.434
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/50
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z2.38 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z2.38
G1 Z2.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554835
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512865
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.37991
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332811
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381759
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.58743
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548363
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509297
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.47023
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424424
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378618
M73 P77 R4
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332811
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350615
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382249
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397356
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z2.58 F42000
G1 Z2.18
G1 E.8 F1800
; LINE_WIDTH: 0.360699
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530838
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429566
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474138
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.51871
G1 X128.232 Y131.435 E.00321
; LINE_WIDTH: 0.563282
G1 X128.246 Y131.517 E.00351
; LINE_WIDTH: 0.607853
G1 X128.259 Y131.599 E.00381
; LINE_WIDTH: 0.629788
G1 X128.535 Y131.815 E.01678
G3 X128.602 Y132.467 I-37.9 J4.219 E.03132
G1 X128.462 Y132.615 E.00974
; LINE_WIDTH: 0.609553
G1 X128.459 Y132.674 E.00271
; LINE_WIDTH: 0.568231
G1 X128.456 Y132.732 E.00252
; LINE_WIDTH: 0.526909
G1 X128.453 Y132.791 E.00232
; LINE_WIDTH: 0.485586
G1 X128.449 Y132.85 E.00212
; LINE_WIDTH: 0.444264
G1 X128.446 Y132.908 E.00192
; LINE_WIDTH: 0.445123
G1 X128.431 Y132.998 E.00296
; LINE_WIDTH: 0.487304
G1 X128.416 Y133.087 E.00327
; LINE_WIDTH: 0.529485
G1 X128.401 Y133.176 E.00358
; LINE_WIDTH: 0.571666
M73 P78 R4
G1 X128.386 Y133.265 E.00389
; LINE_WIDTH: 0.613847
G1 X128.371 Y133.354 E.0042
; LINE_WIDTH: 0.622573
G1 X128.542 Y133.619 E.01491
; LINE_WIDTH: 0.627784
G1 X128.734 Y133.765 E.0115
G2 X128.8 Y134.21 I1.818 J-.043 E.02147
; LINE_WIDTH: 0.585711
G1 X128.838 Y134.376 E.00753
; LINE_WIDTH: 0.543637
G1 X128.876 Y134.542 E.00695
; LINE_WIDTH: 0.503433
G1 X128.932 Y135.11 E.02143
G2 X128.982 Y135.397 I5.824 J-.864 E.01094
; LINE_WIDTH: 0.461716
G1 X129.032 Y135.684 E.00995
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445317
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.864 Y129.986 I-.606 J-.155 E.01351
; LINE_WIDTH: 0.518041
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.477565
G1 X123.821 Y129.689 E.00532
; LINE_WIDTH: 0.437089
G1 X123.801 Y129.406 E.00911
; LINE_WIDTH: 0.396837
G1 X123.78 Y129.123 E.00818
; LINE_WIDTH: 0.395233
G1 X123.799 Y128.614 E.01463
; LINE_WIDTH: 0.441175
G1 X123.822 Y128.458 E.00512
; LINE_WIDTH: 0.487117
G1 X123.845 Y128.302 E.00571
; LINE_WIDTH: 0.533059
G1 X123.868 Y128.146 E.0063
; LINE_WIDTH: 0.579001
G1 X123.891 Y127.99 E.00689
G1 X123.886 Y125.054 E.12824
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.912 Y120.024 E.12131
; LINE_WIDTH: 0.541596
G1 X123.936 Y117.891 E.08669
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01007
; LINE_WIDTH: 0.541596
G1 X124.41 Y120.025 E.08662
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.12125
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579001
G2 X124.427 Y128.104 I1663.869 J-4.325 E.13327
G2 X124.291 Y128.311 I.167 J.258 E.01113
; LINE_WIDTH: 0.533059
G1 X124.249 Y128.414 E.00445
G1 X124.239 Y128.438 E.00106
; LINE_WIDTH: 0.487117
G1 X124.204 Y128.521 E.00326
G1 X124.186 Y128.565 E.00173
; LINE_WIDTH: 0.441175
G1 X124.133 Y128.692 E.00447
; LINE_WIDTH: 0.395233
G1 X124.094 Y129.105 E.0119
; LINE_WIDTH: 0.380477
G1 X124.127 Y129.391 E.00791
; LINE_WIDTH: 0.418952
G1 X124.167 Y129.507 E.00376
; LINE_WIDTH: 0.457426
G1 X124.207 Y129.623 E.00415
; LINE_WIDTH: 0.4959
G1 X124.246 Y129.739 E.00453
; LINE_WIDTH: 0.534374
G1 X124.286 Y129.856 E.00492
; LINE_WIDTH: 0.565542
G1 X124.527 Y130.102 E.01466
G2 X124.358 Y130.326 I.157 J.293 E.01232
; LINE_WIDTH: 0.530345
G1 X124.293 Y130.463 E.00604
; LINE_WIDTH: 0.495148
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518861
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477569
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441472
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445317
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01297
G1 X128.289 Y135.553 E.00874
; LINE_WIDTH: 0.450584
G1 X128.371 Y135.359 E.00701
; LINE_WIDTH: 0.481168
G1 X128.453 Y135.164 E.00753
; LINE_WIDTH: 0.491494
G1 X128.449 Y134.733 E.01577
; LINE_WIDTH: 0.53266
G1 X128.416 Y134.59 E.00584
; LINE_WIDTH: 0.573825
G1 X128.383 Y134.448 E.00633
; LINE_WIDTH: 0.61499
G1 X128.35 Y134.305 E.00682
; LINE_WIDTH: 0.620844
G1 X128.191 Y134.09 E.01259
; LINE_WIDTH: 0.622573
G1 X127.915 Y133.872 E.01662
G2 X128.199 Y133.366 I-5.294 J-3.306 E.02738
; LINE_WIDTH: 0.613847
G1 X128.19 Y133.292 E.0035
; LINE_WIDTH: 0.565604
G1 X128.18 Y133.217 E.0032
; LINE_WIDTH: 0.517361
G1 X128.17 Y133.143 E.00291
; LINE_WIDTH: 0.469118
G1 X128.161 Y133.068 E.00261
; LINE_WIDTH: 0.420875
G1 X128.151 Y132.994 E.00231
; LINE_WIDTH: 0.420016
G1 X128.164 Y132.908 E.00266
; LINE_WIDTH: 0.4674
G1 X128.177 Y132.823 E.00299
; LINE_WIDTH: 0.514785
G1 X128.19 Y132.737 E.00332
; LINE_WIDTH: 0.562169
G1 X128.203 Y132.652 E.00366
; LINE_WIDTH: 0.609553
G1 X128.215 Y132.566 E.00399
; LINE_WIDTH: 0.629788
G1 X128.021 Y132.156 E.02171
G1 X127.887 Y132.024 E.00899
; LINE_WIDTH: 0.607853
G1 X127.63 Y131.827 E.0149
G2 X127.758 Y131.646 I-.151 J-.242 E.0105
; LINE_WIDTH: 0.581059
G1 X127.797 Y131.552 E.00447
; LINE_WIDTH: 0.554265
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509986
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.033 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.492 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01897
G1 X128.665 Y129.736 E-.0653
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06985
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z2.58 F42000
G1 Z2.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z2.58 F42000
G1 Z2.18
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583738
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.62308
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.615306
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599722
G1 X128.57 Y135.934 E.01186
; WIPE_START
G1 F6465.494
G1 X128.562 Y136.195 E-.09931
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.1951
G1 X127.682 Y137.635 E-.12288
; WIPE_END
G1 E-.04 F1800
G1 X128.66 Y130.065 Z2.58 F42000
G1 X128.986 Y127.549 Z2.58
G1 Z2.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590107
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500906
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 2.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.502
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/50
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z2.58 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z2.58
G1 Z2.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438163
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.40799
G1 X130.975 Y129.232 E.01295
; LINE_WIDTH: 0.379913
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351835
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528602
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.57755
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587429
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.54836
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509291
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470222
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424418
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378614
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350612
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382243
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z2.78 F42000
G1 Z2.38
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X128.092 Y130.278 E.00189
G1 X127.755 Y129.822 E.01469
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429842
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.47469
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519538
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564386
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609234
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.633247
G1 X128.535 Y131.815 E.01682
G1 X128.6 Y132.464 E.03134
G2 X128.451 Y132.641 I.183 J.306 E.01134
; LINE_WIDTH: 0.608694
G1 X128.452 Y132.752 E.00513
G1 X128.453 Y132.808 E.00261
; LINE_WIDTH: 0.560913
G1 X128.455 Y132.976 E.00708
; LINE_WIDTH: 0.513132
G1 X128.458 Y133.144 E.00643
; LINE_WIDTH: 0.465351
G1 X128.459 Y133.204 E.00208
G1 X128.46 Y133.312 E.0037
; LINE_WIDTH: 0.419999
G1 X128.631 Y133.57 E.00951
G1 X128.832 Y133.697 E.0073
G1 X128.853 Y133.909 E.00653
; LINE_WIDTH: 0.464657
G1 X128.885 Y134.454 E.01879
; LINE_WIDTH: 0.502969
G2 X128.982 Y135.395 I4.734 J-.01 E.03552
; LINE_WIDTH: 0.461484
G1 X129.032 Y135.684 E.01
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454701
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489796
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566566
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523624
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.866 Y130.012 I-.531 J-.146 E.0124
; LINE_WIDTH: 0.522449
G1 X123.847 Y129.89 E.00483
; LINE_WIDTH: 0.486381
G1 X123.828 Y129.768 E.00447
; LINE_WIDTH: 0.450312
G1 X123.806 Y129.503 E.00884
; LINE_WIDTH: 0.405935
G1 X123.783 Y129.237 E.00788
; LINE_WIDTH: 0.385423
G1 X123.794 Y128.684 E.01544
; LINE_WIDTH: 0.433818
G1 X123.818 Y128.511 E.00558
; LINE_WIDTH: 0.482212
G1 X123.843 Y128.337 E.00627
; LINE_WIDTH: 0.530607
G1 X123.867 Y128.164 E.00696
; LINE_WIDTH: 0.579001
G1 X123.891 Y127.99 E.00765
G1 X123.886 Y125.054 E.12825
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579001
G2 X124.427 Y128.104 I1655.315 J-4.295 E.13328
G1 X124.279 Y128.28 E.01005
; LINE_WIDTH: 0.53048
G1 X124.226 Y128.438 E.00664
; LINE_WIDTH: 0.482128
G1 X124.174 Y128.597 E.00598
; LINE_WIDTH: 0.433776
G1 X124.121 Y128.756 E.00532
; LINE_WIDTH: 0.385423
G1 X124.098 Y129.173 E.01166
; LINE_WIDTH: 0.388713
G1 X124.138 Y129.374 E.0058
; LINE_WIDTH: 0.417984
G1 X124.179 Y129.576 E.00629
; LINE_WIDTH: 0.466704
G1 X124.238 Y129.703 E.00484
; LINE_WIDTH: 0.515424
G1 X124.298 Y129.83 E.00539
; LINE_WIDTH: 0.564143
G1 X124.357 Y129.956 E.00595
G1 X124.535 Y130.096 E.0096
G2 X124.358 Y130.326 I.161 J.306 E.01274
; LINE_WIDTH: 0.529412
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494681
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523624
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566566
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.776 E.01308
G1 X128.315 Y135.496 E.01053
; LINE_WIDTH: 0.451557
G1 X128.386 Y135.326 E.00613
; LINE_WIDTH: 0.483114
G1 X128.456 Y135.156 E.00661
; LINE_WIDTH: 0.495783
G1 X128.436 Y134.668 E.01801
G1 X128.329 Y134.476 E.00813
; LINE_WIDTH: 0.457891
G1 X128.222 Y134.283 E.00745
; LINE_WIDTH: 0.419999
G1 X127.932 Y133.991 E.01264
G1 X127.707 Y133.876 E.00778
G1 X127.846 Y133.765 E.00546
G1 X128.081 Y133.405 E.01322
G1 X128.109 Y133.197 E.00646
; LINE_WIDTH: 0.391616
G1 X128.137 Y132.989 E.00597
; LINE_WIDTH: 0.394952
G1 X128.158 Y132.931 E.00176
; LINE_WIDTH: 0.426671
G1 X128.179 Y132.874 E.00192
; LINE_WIDTH: 0.467987
G1 X128.184 Y132.797 E.00266
; LINE_WIDTH: 0.509302
G1 X128.189 Y132.72 E.00292
; LINE_WIDTH: 0.550617
G1 X128.194 Y132.644 E.00317
; LINE_WIDTH: 0.591932
G1 X128.199 Y132.567 E.00343
; LINE_WIDTH: 0.633247
G1 X128.204 Y132.491 E.00369
G1 X128.005 Y132.141 E.01936
G1 X127.636 Y131.823 E.02344
; LINE_WIDTH: 0.609234
G2 X127.758 Y131.646 I-.146 J-.232 E.01019
; LINE_WIDTH: 0.581753
G1 X127.797 Y131.552 E.00448
; LINE_WIDTH: 0.554272
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509991
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.46571
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500956
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.028 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00682
G2 X130.422 Y131.721 I-41.488 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02743
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.00169
G1 X130.093 Y129.525 E.00541
G2 X130.238 Y129.414 I-.087 J-.265 E.00573
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06528
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z2.78 F42000
G1 Z2.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630498
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.846
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X128.307 Y133.784 Z2.78 F42000
G1 Z2.38
G1 E.8 F1800
; LINE_WIDTH: 0.460402
G1 F1200
G1 X128.457 Y133.948 E.00756
; WIPE_START
G1 F8623.126
G1 X128.307 Y133.784 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z2.78 F42000
G1 Z2.38
G1 E.8 F1800
; LINE_WIDTH: 0.530456
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581118
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583738
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.61531
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599774
G1 X128.571 Y135.919 E.01254
; WIPE_START
G1 F6464.89
G1 X128.562 Y136.195 E-.10499
G1 X128.452 Y136.634 E-.17157
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.694 Y137.626 E-.1172
; WIPE_END
G1 E-.04 F1800
G1 X128.664 Y130.055 Z2.78 F42000
G1 X128.986 Y127.549 Z2.78
G1 Z2.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590107
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500906
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 2.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.511
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/50
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z2.78 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z2.78
G1 Z2.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512865
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438163
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.40799
G1 X130.975 Y129.232 E.01295
; LINE_WIDTH: 0.379912
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332811
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381759
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587429
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548362
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509295
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470227
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424422
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378617
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332811
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350619
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382258
G3 X130.657 Y129.311 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397357
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424407
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z2.98 F42000
G1 Z2.58
G1 E.8 F1800
; LINE_WIDTH: 0.360782
M73 P79 R4
G1 F1200
G1 X128.141 Y129.811 E.00779
G1 X128.129 Y130.341 E.01374
G1 X128.092 Y130.278 E.00189
G1 X127.755 Y129.822 E.01469
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00258
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.63 E.00229
G1 X128.45 Y129.632 E.00008
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.0005
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.299 E.00573
G1 X128.491 Y129.898 E.00167
G1 X128.463 Y129.933 E.00137
G1 X128.508 Y130.485 E.01702
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429869
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474744
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.51962
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564495
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.60937
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.633125
G1 X128.535 Y131.815 E.01682
G1 X128.6 Y132.462 E.03124
G1 X128.451 Y132.631 E.01086
; LINE_WIDTH: 0.618744
G1 X128.452 Y132.745 E.00532
G1 X128.452 Y132.767 E.00103
; LINE_WIDTH: 0.578305
G1 X128.453 Y132.779 E.00054
G1 X128.454 Y132.902 E.00538
; LINE_WIDTH: 0.537865
G1 X128.456 Y133.038 E.00546
; LINE_WIDTH: 0.497426
G1 X128.457 Y133.173 E.00502
; LINE_WIDTH: 0.456986
G1 X128.458 Y133.189 E.00054
G1 X128.459 Y133.309 E.00403
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00967
G1 X128.832 Y133.697 E.00725
G1 X128.853 Y133.909 E.00653
; LINE_WIDTH: 0.464752
G1 X128.886 Y134.461 E.01902
; LINE_WIDTH: 0.502576
G2 X128.982 Y135.394 I4.723 J-.014 E.03518
; LINE_WIDTH: 0.461288
G1 X129.032 Y135.684 E.01006
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489793
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524888
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536823
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580639
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566564
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515315
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472113
G1 X123.817 Y129.689 E.00526
; LINE_WIDTH: 0.428911
G1 X123.799 Y129.433 E.00806
; LINE_WIDTH: 0.393877
G1 X123.781 Y129.178 E.00733
; LINE_WIDTH: 0.386361
G1 X123.795 Y128.676 E.01403
; LINE_WIDTH: 0.434521
G1 X123.819 Y128.505 E.00553
; LINE_WIDTH: 0.482681
G1 X123.843 Y128.333 E.00621
; LINE_WIDTH: 0.530841
G1 X123.867 Y128.162 E.00689
; LINE_WIDTH: 0.579001
G1 X123.891 Y127.99 E.00757
G1 X123.886 Y125.054 E.12826
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.911 Y120.064 E.11961
; LINE_WIDTH: 0.541949
G1 X123.936 Y117.891 E.08837
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01007
; LINE_WIDTH: 0.541949
G1 X124.41 Y120.065 E.08831
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.11955
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579001
G2 X124.427 Y128.104 I1662.506 J-4.32 E.13328
G1 X124.278 Y128.281 E.01012
; LINE_WIDTH: 0.52972
G1 X124.226 Y128.437 E.00651
; LINE_WIDTH: 0.481934
G1 X124.174 Y128.593 E.00587
; LINE_WIDTH: 0.434148
G1 X124.122 Y128.748 E.00523
; LINE_WIDTH: 0.386361
G1 X124.098 Y129.167 E.01174
; LINE_WIDTH: 0.388079
G1 X124.137 Y129.37 E.00581
; LINE_WIDTH: 0.416983
G1 X124.177 Y129.572 E.0063
; LINE_WIDTH: 0.466011
G1 X124.237 Y129.701 E.00488
; LINE_WIDTH: 0.515039
G1 X124.297 Y129.829 E.00545
; LINE_WIDTH: 0.564067
G1 X124.358 Y129.957 E.00601
G1 X124.536 Y130.095 E.00957
G2 X124.359 Y130.326 I.161 J.307 E.01275
; LINE_WIDTH: 0.529362
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494657
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566564
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.777 E.01306
G1 X128.312 Y135.505 E.01026
; LINE_WIDTH: 0.451338
G1 X128.384 Y135.329 E.00633
; LINE_WIDTH: 0.482677
G1 X128.456 Y135.153 E.00682
; LINE_WIDTH: 0.495311
G1 X128.437 Y134.673 E.0177
G1 X128.331 Y134.48 E.00813
; LINE_WIDTH: 0.457655
G1 X128.224 Y134.287 E.00746
; LINE_WIDTH: 0.419999
G1 X127.934 Y133.992 E.0127
G1 X127.707 Y133.876 E.00784
G1 X127.847 Y133.764 E.00552
G1 X128.083 Y133.402 E.01327
G1 X128.11 Y133.197 E.00635
; LINE_WIDTH: 0.391328
G1 X128.137 Y132.993 E.00586
; LINE_WIDTH: 0.401089
G1 X128.16 Y132.93 E.00195
; LINE_WIDTH: 0.439521
G1 X128.183 Y132.867 E.00216
; LINE_WIDTH: 0.487922
G1 X128.189 Y132.774 E.00337
; LINE_WIDTH: 0.536323
G1 X128.195 Y132.682 E.00374
; LINE_WIDTH: 0.584724
G1 X128.2 Y132.589 E.0041
; LINE_WIDTH: 0.633125
G1 X128.206 Y132.496 E.00447
G1 X128.005 Y132.14 E.01968
G1 X127.636 Y131.823 E.02339
; LINE_WIDTH: 0.60937
G2 X127.758 Y131.646 I-.146 J-.232 E.01018
; LINE_WIDTH: 0.58182
G1 X127.797 Y131.552 E.00448
; LINE_WIDTH: 0.554269
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509989
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01253
G1 X127.317 Y129.929 E.00935
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500954
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.029 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.488 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.526 E.00536
G2 X130.238 Y129.414 I-.097 J-.274 E.00571
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.153
G1 X128.387 Y129.508 E-.04866
G1 X128.419 Y129.57 E-.02664
G1 X128.449 Y129.63 E-.02578
G1 X128.45 Y129.632 E-.00085
G1 X128.465 Y129.64 E-.00624
G1 X128.51 Y129.661 E-.01895
G1 X128.665 Y129.736 E-.06532
G1 X128.525 Y129.856 E-.06993
G1 X128.491 Y129.898 E-.02068
G1 X128.463 Y129.933 E-.01695
G1 X128.508 Y130.485 E-.21054
G1 X128.403 Y130.549 E-.04679
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06991
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z2.98 F42000
G1 Z2.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573201
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19059
; WIPE_END
G1 E-.04 F1800
G1 X128.307 Y133.784 Z2.98 F42000
G1 Z2.58
G1 E.8 F1800
; LINE_WIDTH: 0.458454
G1 F1200
G1 X128.457 Y133.95 E.00759
; WIPE_START
G1 F8663.551
G1 X128.307 Y133.784 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z2.98 F42000
G1 Z2.58
G1 E.8 F1800
; LINE_WIDTH: 0.530454
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583738
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.61531
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.59977
G1 X128.571 Y135.92 E.01251
; WIPE_START
G1 F6464.936
G1 X128.562 Y136.195 E-.10478
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.1951
G1 X127.694 Y137.626 E-.11742
; WIPE_END
G1 E-.04 F1800
G1 X128.664 Y130.056 Z2.98 F42000
G1 X128.986 Y127.549 Z2.98
G1 Z2.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 2.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.459
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/50
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
G17
G3 Z2.98 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z2.98
G1 Z2.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638771
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596802
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554832
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512862
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438163
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351834
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332803
G1 X131.067 Y131.41 E.02094
; LINE_WIDTH: 0.381753
G1 X131.044 Y131.482 E.00208
; LINE_WIDTH: 0.430702
G1 X131.022 Y131.554 E.00238
; LINE_WIDTH: 0.479651
G1 X131 Y131.625 E.00268
; LINE_WIDTH: 0.5286
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.9 Y131.784 E.00311
; LINE_WIDTH: 0.587378
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548257
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509136
G1 X130.803 Y131.614 E.00249
; LINE_WIDTH: 0.470015
G1 X130.794 Y131.547 E.00233
; LINE_WIDTH: 0.424278
G1 X130.785 Y131.481 E.00208
; LINE_WIDTH: 0.378541
G1 X130.777 Y131.414 E.00183
; LINE_WIDTH: 0.332803
G1 X130.77 Y130.513 E.0213
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497192
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544385
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591578
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638771
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.779
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z3.18 F42000
G1 Z2.78
G1 E.8 F1800
; LINE_WIDTH: 0.360706
G1 F1200
G1 X128.141 Y130.333 E.01352
G1 X128.093 Y130.279 E.00186
G1 X127.755 Y129.822 E.01473
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00165
G1 X128.463 Y129.933 E.00139
G1 X128.508 Y130.487 E.01708
G1 X128.395 Y130.558 E.0041
G1 X128.22 Y130.846 E.01036
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00981
; LINE_WIDTH: 0.429896
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474798
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.5197
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564602
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609504
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.632989
G1 X128.535 Y131.815 E.01681
G1 X128.6 Y132.462 E.03124
G1 X128.449 Y132.63 E.01089
; LINE_WIDTH: 0.622388
G1 X128.451 Y132.745 E.00539
G1 X128.451 Y132.766 E.001
; LINE_WIDTH: 0.581143
G1 X128.451 Y132.777 E.00049
G1 X128.453 Y132.901 E.00545
; LINE_WIDTH: 0.539897
G1 X128.455 Y133.037 E.00548
; LINE_WIDTH: 0.498651
G1 X128.457 Y133.172 E.00503
; LINE_WIDTH: 0.457405
G1 X128.457 Y133.192 E.00068
G1 X128.459 Y133.307 E.00389
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.0097
G1 X128.832 Y133.697 E.00725
G1 X128.853 Y133.912 E.00664
; LINE_WIDTH: 0.46484
G1 X128.887 Y134.468 E.01914
; LINE_WIDTH: 0.502183
G2 X128.982 Y135.392 I4.709 J-.017 E.03482
; LINE_WIDTH: 0.461091
G1 X129.032 Y135.684 E.01011
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515305
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472092
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428879
G1 X123.799 Y129.431 E.00814
; LINE_WIDTH: 0.393696
G1 X123.781 Y129.173 E.0074
; LINE_WIDTH: 0.387314
G1 X123.795 Y128.669 E.01415
; LINE_WIDTH: 0.435236
G1 X123.819 Y128.499 E.00547
; LINE_WIDTH: 0.483158
G1 X123.843 Y128.33 E.00614
; LINE_WIDTH: 0.53108
G1 X123.867 Y128.16 E.00681
; LINE_WIDTH: 0.579002
G1 X123.891 Y127.991 E.00748
G1 X123.886 Y125.054 E.12827
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.911 Y120.084 E.11877
; LINE_WIDTH: 0.542126
G1 X123.936 Y117.891 E.08922
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.651 E.00942
G1 X124.079 Y117.531 E.00658
G1 X124.253 Y117.533 E.0068
G1 X124.384 Y117.637 E.00654
G1 X124.412 Y117.893 E.01007
; LINE_WIDTH: 0.542126
G1 X124.41 Y120.085 E.08915
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.11871
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579002
G2 X124.427 Y128.104 I1653.409 J-4.288 E.13329
G1 X124.352 Y128.194 E.0051
; LINE_WIDTH: 0.553982
G1 X124.277 Y128.283 E.00486
; LINE_WIDTH: 0.528962
G1 X124.226 Y128.436 E.00638
; LINE_WIDTH: 0.481746
G1 X124.175 Y128.589 E.00576
; LINE_WIDTH: 0.43453
G1 X124.124 Y128.741 E.00514
; LINE_WIDTH: 0.387314
G1 X124.097 Y129.161 E.01181
; LINE_WIDTH: 0.387442
G1 X124.137 Y129.365 E.00582
; LINE_WIDTH: 0.415978
G1 X124.176 Y129.569 E.00631
; LINE_WIDTH: 0.465316
G1 X124.237 Y129.698 E.00493
; LINE_WIDTH: 0.514653
G1 X124.297 Y129.828 E.00551
; LINE_WIDTH: 0.56399
G1 X124.358 Y129.958 E.00608
G1 X124.536 Y130.095 E.00954
G2 X124.359 Y130.326 I.161 J.307 E.01276
; LINE_WIDTH: 0.52931
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.49463
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.777 E.01305
G1 X128.308 Y135.513 E.01
; LINE_WIDTH: 0.451126
G1 X128.382 Y135.332 E.00653
; LINE_WIDTH: 0.482253
G1 X128.456 Y135.15 E.00703
; LINE_WIDTH: 0.494821
G1 X128.439 Y134.678 E.01738
G1 X128.333 Y134.484 E.00814
; LINE_WIDTH: 0.45741
G1 X128.227 Y134.29 E.00747
; LINE_WIDTH: 0.419999
G1 X127.935 Y133.994 E.01277
G1 X127.706 Y133.876 E.00791
G1 X127.848 Y133.763 E.00558
G1 X128.084 Y133.399 E.01332
G1 X128.111 Y133.196 E.0063
; LINE_WIDTH: 0.39109
G1 X128.138 Y132.992 E.00581
; LINE_WIDTH: 0.396659
G1 X128.159 Y132.936 E.00174
; LINE_WIDTH: 0.431138
G1 X128.181 Y132.88 E.00191
; LINE_WIDTH: 0.471509
G1 X128.186 Y132.804 E.00265
; LINE_WIDTH: 0.511879
G1 X128.191 Y132.728 E.0029
; LINE_WIDTH: 0.552249
G1 X128.197 Y132.653 E.00315
; LINE_WIDTH: 0.592619
G1 X128.202 Y132.577 E.0034
; LINE_WIDTH: 0.632989
G1 X128.207 Y132.501 E.00365
G1 X128.004 Y132.139 E.01997
G1 X127.636 Y131.823 E.02334
; LINE_WIDTH: 0.609504
G2 X127.758 Y131.646 I-.146 J-.231 E.01018
; LINE_WIDTH: 0.581884
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554263
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509985
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465706
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00448
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.027 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.453 J1.383 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.229 Y131.61 E.0048
G1 X130.377 Y131.492 E.00582
G1 X130.406 Y131.47 E.0011
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02586
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.239 Y129.414 I-.098 J-.276 E.00574
G1 X130.282 Y129.361 E.00209
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604787
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.153
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06528
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02045
G1 X128.463 Y129.933 E-.01717
G1 X128.508 Y130.487 E-.21123
G1 X128.395 Y130.558 E-.05072
G1 X128.22 Y130.846 E-.12809
G1 X128.205 Y131.029 E-.06992
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z3.18 F42000
G1 Z2.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60127
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646518
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.33221
G1 X131.044 Y133.837 E-.19059
; WIPE_END
G1 E-.04 F1800
G1 X128.307 Y133.783 Z3.18 F42000
G1 Z2.78
G1 E.8 F1800
; LINE_WIDTH: 0.457028
G1 F1200
G1 X128.457 Y133.95 E.00759
; WIPE_START
G1 F8693.384
G1 X128.307 Y133.783 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.571 Y135.927 Z3.18 F42000
G1 Z2.78
G1 E.8 F1800
; LINE_WIDTH: 0.599762
G1 F1200
G1 X128.562 Y136.195 E.01218
; LINE_WIDTH: 0.621314
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.625284
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.615308
G1 X127.431 Y137.816 E.02952
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0311
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600724
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583736
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581118
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.549034
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530454
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.1
G1 X124.459 Y136.736 E-.15299
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z3.18 F42000
G1 X128.986 Y127.549 Z3.18
G1 Z2.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590111
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586816
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559043
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530409
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500914
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 2.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.374
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/50
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z3.18 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z3.18
G1 Z2.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351835
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332809
G1 X131.067 Y131.41 E.02095
; LINE_WIDTH: 0.381757
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430705
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479653
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587424
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548351
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509278
M73 P80 R4
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470205
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424407
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378608
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332809
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.1425
G1 X128.038 Y127.914 E-.08419
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z3.38 F42000
G1 Z2.98
G1 E.8 F1800
; LINE_WIDTH: 0.360712
G1 F1200
G1 X128.141 Y130.337 E.01363
G1 X128.116 Y130.33 E.00069
G1 X127.755 Y129.822 E.01615
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.524 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.489 E.01715
G1 X128.385 Y130.57 E.00453
G1 X128.22 Y130.845 E.00985
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00984
; LINE_WIDTH: 0.429922
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474851
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519779
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564708
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609636
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632845
G1 X128.535 Y131.815 E.0168
G1 X128.601 Y132.467 E.03151
G2 X128.443 Y132.655 I.197 J.325 E.012
; LINE_WIDTH: 0.608084
G1 X128.446 Y132.764 E.00502
G1 X128.447 Y132.818 E.00247
; LINE_WIDTH: 0.560026
G1 X128.447 Y132.822 E.00016
G1 X128.451 Y132.981 E.0067
; LINE_WIDTH: 0.511967
G1 X128.455 Y133.143 E.00622
; LINE_WIDTH: 0.463909
G1 X128.456 Y133.199 E.0019
G1 X128.459 Y133.306 E.00368
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00974
G1 X128.832 Y133.697 E.00725
G1 X128.854 Y133.917 E.0068
; LINE_WIDTH: 0.463939
G1 X128.86 Y134.198 E.00963
; LINE_WIDTH: 0.507879
G2 X128.931 Y135.096 I5.418 J.021 E.03419
; LINE_WIDTH: 0.501789
G1 X128.982 Y135.39 E.01116
; LINE_WIDTH: 0.460894
G1 X129.032 Y135.684 E.01016
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.4547
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536823
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580638
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.866 Y130.008 I-.54 J-.147 E.01259
; LINE_WIDTH: 0.521289
G1 X123.846 Y129.881 E.005
; LINE_WIDTH: 0.484061
G1 X123.826 Y129.755 E.00461
; LINE_WIDTH: 0.446833
G1 X123.804 Y129.477 E.00918
; LINE_WIDTH: 0.403139
G1 X123.782 Y129.199 E.00819
; LINE_WIDTH: 0.388445
G1 X123.796 Y128.659 E.01519
; LINE_WIDTH: 0.436085
G1 X123.82 Y128.492 E.00541
; LINE_WIDTH: 0.483724
G1 X123.843 Y128.325 E.00606
; LINE_WIDTH: 0.531363
G1 X123.867 Y128.158 E.00672
; LINE_WIDTH: 0.579002
G1 X123.891 Y127.991 E.00737
G1 X123.886 Y125.054 E.12828
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.911 Y120.103 E.11792
; LINE_WIDTH: 0.542303
G1 X123.936 Y117.89 E.09006
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01007
; LINE_WIDTH: 0.542303
G1 X124.41 Y120.105 E.09
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.11786
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579002
G2 X124.427 Y128.104 I1660.671 J-4.313 E.13329
G1 X124.352 Y128.195 E.00514
; LINE_WIDTH: 0.553605
G1 X124.276 Y128.285 E.0049
; LINE_WIDTH: 0.528207
G1 X124.226 Y128.434 E.00623
; LINE_WIDTH: 0.48162
G1 X124.175 Y128.583 E.00563
; LINE_WIDTH: 0.435033
G1 X124.125 Y128.733 E.00504
; LINE_WIDTH: 0.388445
G1 X124.095 Y129.13 E.01121
; LINE_WIDTH: 0.386038
G1 X124.135 Y129.346 E.00615
; LINE_WIDTH: 0.414401
G1 X124.174 Y129.563 E.00666
; LINE_WIDTH: 0.4642
G1 X124.236 Y129.694 E.00499
; LINE_WIDTH: 0.513998
G1 X124.297 Y129.826 E.00558
; LINE_WIDTH: 0.563796
G1 X124.358 Y129.958 E.00617
; LINE_WIDTH: 0.56391
G1 X124.536 Y130.095 E.00953
G2 X124.359 Y130.326 I.161 J.307 E.01276
; LINE_WIDTH: 0.529257
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494604
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.778 E.01303
G1 X128.304 Y135.522 E.00973
; LINE_WIDTH: 0.45092
G1 X128.38 Y135.334 E.00673
; LINE_WIDTH: 0.48184
G1 X128.456 Y135.147 E.00724
; LINE_WIDTH: 0.494161
G1 X128.44 Y134.679 E.0172
G1 X128.336 Y134.486 E.00808
; LINE_WIDTH: 0.460591
G1 X128.232 Y134.292 E.00748
; LINE_WIDTH: 0.42702
G1 X127.937 Y133.995 E.01311
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00797
G1 X127.849 Y133.761 E.00565
G1 X128.086 Y133.396 E.01338
G1 X128.112 Y133.194 E.00625
; LINE_WIDTH: 0.390776
G1 X128.139 Y132.992 E.00577
; LINE_WIDTH: 0.397295
G1 X128.16 Y132.938 E.00168
; LINE_WIDTH: 0.433037
G1 X128.182 Y132.884 E.00184
; LINE_WIDTH: 0.482989
G1 X128.189 Y132.79 E.0034
; LINE_WIDTH: 0.532941
G1 X128.196 Y132.695 E.00379
; LINE_WIDTH: 0.582893
G1 X128.202 Y132.601 E.00417
; LINE_WIDTH: 0.632845
G1 X128.209 Y132.506 E.00456
G1 X128.004 Y132.138 E.02025
G1 X127.636 Y131.823 E.0233
; LINE_WIDTH: 0.609636
G2 X127.758 Y131.646 I-.145 J-.231 E.01017
; LINE_WIDTH: 0.581951
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554265
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509986
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538792
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500957
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.034 J-2.284 E.15108
G2 X131.672 Y134.53 I9.527 J-.918 E.03555
G2 X132.16 Y135.774 I6.89 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.487 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.0048
G1 X130.383 Y131.488 E.00605
G1 X130.406 Y131.471 E.00086
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.153
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.019
G1 X128.665 Y129.736 E-.06528
G1 X128.524 Y129.856 E-.07001
G1 X128.491 Y129.898 E-.02056
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.489 E-.21206
G1 X128.385 Y130.57 E-.05604
G1 X128.22 Y130.845 E-.12177
G1 X128.205 Y131.029 E-.07009
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z3.38 F42000
G1 Z2.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X128.46 Y133.954 Z3.38 F42000
G1 Z2.98
G1 E.8 F1800
; LINE_WIDTH: 0.472264
G1 F1200
G1 X128.305 Y133.793 E.00782
; WIPE_START
G1 F8384.885
G1 X128.46 Y133.954 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z3.38 F42000
G1 Z2.98
G1 E.8 F1800
; LINE_WIDTH: 0.530456
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.54903
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583736
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.03111
; LINE_WIDTH: 0.615308
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599754
G1 X128.571 Y135.928 E.01212
; WIPE_START
G1 F6465.123
G1 X128.562 Y136.195 E-.1015
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.687 Y137.631 E-.12069
; WIPE_END
G1 E-.04 F1800
G1 X128.662 Y130.061 Z3.38 F42000
G1 X128.986 Y127.549 Z3.38
G1 Z2.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586816
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559043
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530408
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500911
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 3.18
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.425
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/50
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z3.38 I-.504 J-1.108 P1  F42000
G1 X128.129 Y128.478 Z3.38
G1 Z3.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.639621
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.976 Y128.126 E.01868
G3 X128.152 Y127.74 I.74 J.105 E.02088
; LINE_WIDTH: 0.6
G1 X128.264 Y127.567 E.0094
; LINE_WIDTH: 0.560379
G1 X128.377 Y127.393 E.00873
; LINE_WIDTH: 0.520758
G1 X128.567 Y127.256 E.00913
; LINE_WIDTH: 0.485379
G1 X128.758 Y127.119 E.00845
; LINE_WIDTH: 0.449999
G1 X129.272 Y126.999 E.01751
G1 X129.718 Y127.049 E.01489
G3 X130.618 Y127.659 I-.493 J1.697 E.03667
G1 X130.788 Y127.965 E.0116
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407989
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379905
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351821
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.34139
G1 X131.063 Y131.439 E.02189
; LINE_WIDTH: 0.388908
G1 X131.042 Y131.506 E.00199
; LINE_WIDTH: 0.436426
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483944
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531462
G1 X130.976 Y131.707 E.0028
; LINE_WIDTH: 0.57898
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.57898
G1 X130.877 Y131.707 E.00316
; LINE_WIDTH: 0.531462
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483944
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.436426
G1 X130.793 Y131.507 E.00232
; LINE_WIDTH: 0.388908
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.34139
G1 X130.77 Y130.523 E.02232
; LINE_WIDTH: 0.350643
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382246
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.251 Y128.311 E.01829
G1 X129.789 Y128.038 E.0178
G1 X129.232 Y127.969 E.01863
; LINE_WIDTH: 0.497405
G1 X129.078 Y127.996 E.00577
; LINE_WIDTH: 0.54481
G1 X128.925 Y128.023 E.00637
; LINE_WIDTH: 0.592216
G1 X128.772 Y128.049 E.00697
; LINE_WIDTH: 0.639621
G1 X128.618 Y128.076 E.00757
G1 X128.176 Y128.44 E.02785
; WIPE_START
G1 F6033.172
G1 X127.976 Y128.126 E-.14147
G1 X128.039 Y127.914 E-.08395
G1 X128.152 Y127.74 E-.07868
G1 X128.264 Y127.567 E-.07868
G1 X128.377 Y127.393 E-.07868
G1 X128.567 Y127.256 E-.08908
G1 X128.758 Y127.119 E-.08908
G1 X129.066 Y127.047 E-.12039
; WIPE_END
G1 E-.04 F1800
G1 X128.147 Y129.8 Z3.58 F42000
G1 Z3.18
G1 E.8 F1800
; LINE_WIDTH: 0.360726
G1 F1200
G1 X128.142 Y130.34 E.014
G3 X127.755 Y129.822 I2.816 J-2.509 E.01678
G1 X127.998 Y129.546 E.00953
G1 X128.117 Y129.748 E.00606
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530838
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.491 E.0172
G1 X128.377 Y130.579 E.00487
G1 X128.22 Y130.845 E.00948
; LINE_WIDTH: 0.391075
G1 X128.192 Y131.19 E.00983
; LINE_WIDTH: 0.430151
G1 X128.205 Y131.273 E.00263
; LINE_WIDTH: 0.475308
G1 X128.219 Y131.355 E.00293
; LINE_WIDTH: 0.520465
G1 X128.232 Y131.437 E.00324
; LINE_WIDTH: 0.565622
G1 X128.246 Y131.519 E.00355
; LINE_WIDTH: 0.610779
G1 X128.259 Y131.601 E.00385
; LINE_WIDTH: 0.631901
G1 X128.535 Y131.815 E.01675
G1 X128.601 Y132.47 E.03159
G2 X128.44 Y132.667 I.224 J.348 E.01242
; LINE_WIDTH: 0.602338
G1 X128.443 Y132.775 E.00494
G1 X128.445 Y132.826 E.00234
; LINE_WIDTH: 0.555621
G1 X128.445 Y132.836 E.0004
G1 X128.449 Y132.986 E.00627
; LINE_WIDTH: 0.508904
G1 X128.454 Y133.145 E.00606
; LINE_WIDTH: 0.462187
G1 X128.455 Y133.192 E.00159
G1 X128.459 Y133.305 E.00387
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00977
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426616
G1 X128.871 Y134.119 E.01323
; LINE_WIDTH: 0.460171
G1 X128.881 Y134.384 E.00903
; LINE_WIDTH: 0.493726
G2 X128.951 Y135.189 I5.42 J-.069 E.02971
; LINE_WIDTH: 0.481399
G1 X128.991 Y135.437 E.00897
; LINE_WIDTH: 0.450699
G1 X129.032 Y135.684 E.00835
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445317
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559985
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517857
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475729
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536823
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580638
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566564
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523622
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.48068
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.866 Y130.006 I-.544 J-.148 E.01265
; LINE_WIDTH: 0.520905
G1 X123.846 Y129.878 E.00505
; LINE_WIDTH: 0.483293
G1 X123.826 Y129.75 E.00465
; LINE_WIDTH: 0.445681
G1 X123.804 Y129.477 E.009
; LINE_WIDTH: 0.402627
G1 X123.782 Y129.204 E.00803
; LINE_WIDTH: 0.389425
G1 X123.796 Y128.651 E.0156
; LINE_WIDTH: 0.43682
G1 X123.82 Y128.486 E.00535
; LINE_WIDTH: 0.484215
G1 X123.844 Y128.321 E.006
; LINE_WIDTH: 0.53161
G1 X123.867 Y128.156 E.00664
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00728
G1 X123.886 Y125.054 E.12829
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.911 Y120.123 E.11707
; LINE_WIDTH: 0.54248
G1 X123.936 Y117.89 E.09091
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01007
; LINE_WIDTH: 0.54248
G1 X124.41 Y120.125 E.09084
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.11701
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1655.588 J-4.295 E.1333
G2 X124.292 Y128.315 I.167 J.257 E.01126
G1 X124.29 Y128.319 E.00021
; LINE_WIDTH: 0.53161
G1 X124.258 Y128.399 E.00341
G1 X124.235 Y128.455 E.00241
; LINE_WIDTH: 0.484215
G1 X124.213 Y128.511 E.00216
G1 X124.181 Y128.59 E.00309
; LINE_WIDTH: 0.43682
G1 X124.126 Y128.726 E.00469
; LINE_WIDTH: 0.389425
G1 X124.095 Y129.135 E.01159
; LINE_WIDTH: 0.385733
G1 X124.134 Y129.347 E.00603
; LINE_WIDTH: 0.413659
G1 X124.173 Y129.56 E.00652
; LINE_WIDTH: 0.463349
G1 X124.234 Y129.692 E.00499
; LINE_WIDTH: 0.513038
G1 X124.296 Y129.824 E.00558
; LINE_WIDTH: 0.562727
G1 X124.357 Y129.956 E.00617
; LINE_WIDTH: 0.563827
G1 X124.536 Y130.095 E.00962
G2 X124.359 Y130.326 I.161 J.308 E.01277
; LINE_WIDTH: 0.529202
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494577
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.48068
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523622
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566564
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518863
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477571
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441474
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464393
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512189
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559985
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445317
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.295 Y137.59 E.01464
G1 X126.776 Y137.555 E.01481
G1 X127.264 Y137.373 E.016
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01301
G1 X128.3 Y135.532 E.00942
; LINE_WIDTH: 0.450699
G1 X128.378 Y135.338 E.00696
; LINE_WIDTH: 0.481399
G1 X128.457 Y135.143 E.00748
; LINE_WIDTH: 0.493726
G1 X128.441 Y134.689 E.0167
G1 X128.338 Y134.492 E.00817
; LINE_WIDTH: 0.460171
G1 X128.234 Y134.295 E.00756
; LINE_WIDTH: 0.426616
G1 X127.939 Y133.996 E.01316
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00804
G1 X127.851 Y133.76 E.00571
G1 X128.087 Y133.392 E.01343
G1 X128.113 Y133.192 E.0062
; LINE_WIDTH: 0.390515
G1 X128.14 Y132.992 E.00572
; LINE_WIDTH: 0.398167
G1 X128.161 Y132.94 E.00164
; LINE_WIDTH: 0.435303
G1 X128.183 Y132.887 E.00181
; LINE_WIDTH: 0.484453
G1 X128.19 Y132.793 E.00339
; LINE_WIDTH: 0.533602
G1 X128.197 Y132.699 E.00377
; LINE_WIDTH: 0.582752
G1 X128.204 Y132.605 E.00415
; LINE_WIDTH: 0.631901
G1 X128.21 Y132.511 E.00453
G1 X128.004 Y132.135 E.02057
G1 X127.637 Y131.823 E.02314
; LINE_WIDTH: 0.610779
G2 X127.759 Y131.647 I-.144 J-.229 E.01017
; LINE_WIDTH: 0.582522
G1 X127.797 Y131.552 E.0045
; LINE_WIDTH: 0.554265
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509986
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.795 Y130.463 E.01343
G1 X127.556 Y130.109 E.01312
G1 X127.317 Y129.929 E.00919
G1 X127.275 Y129.825 E.00344
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00482
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614459
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576624
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538789
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500953
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460476
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.237 Y126.609 E.01406
G1 X129.695 Y126.636 E.01411
G1 X130.137 Y126.771 E.01419
G1 X130.515 Y126.993 E.01347
G1 X130.867 Y127.329 E.01497
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.031 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.89 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.402 J1.381 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.23 Y131.61 E.00478
G1 X130.375 Y131.493 E.00575
G1 X130.406 Y131.468 E.00119
G1 X130.447 Y131.358 E.00363
G1 X130.443 Y130.518 E.02579
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.689 Y128.416 E.01094
G1 X129.269 Y128.354 E.01303
G1 X128.892 Y128.467 E.01211
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.01897
G1 X128.665 Y129.736 E-.0653
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01704
G1 X128.508 Y130.491 E-.21266
G1 X128.377 Y130.579 E-.06025
G1 X128.22 Y130.845 E-.11724
G1 X128.205 Y131.028 E-.06981
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z3.58 F42000
G1 Z3.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573201
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23719
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19062
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.793 Z3.58 F42000
G1 Z3.18
G1 E.8 F1800
; LINE_WIDTH: 0.47241
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8382.034
G1 X128.305 Y133.793 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z3.58 F42000
G1 Z3.18
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549034
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583738
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.59991
G1 X126.22 Y138.051 E.02619
; LINE_WIDTH: 0.623374
G1 X126.813 Y138.032 E.02807
G1 X127.431 Y137.816 E.03099
; LINE_WIDTH: 0.61531
G1 X127.944 Y137.445 E.02951
; LINE_WIDTH: 0.625284
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.59974
G1 X128.57 Y135.93 E.01204
; WIPE_START
G1 F6465.285
G1 X128.562 Y136.195 E-.10081
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.685 Y137.632 E-.12136
; WIPE_END
G1 E-.04 F1800
G1 X128.663 Y130.063 Z3.58 F42000
G1 X128.988 Y127.548 Z3.58
G1 Z3.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.591601
G1 F1200
G1 X129.363 Y127.484 E.01704
; LINE_WIDTH: 0.588551
G1 X129.62 Y127.538 E.01166
; LINE_WIDTH: 0.559864
G1 X129.877 Y127.592 E.01105
; LINE_WIDTH: 0.530122
G1 X129.97 Y127.643 E.00423
; LINE_WIDTH: 0.499325
G1 X130.063 Y127.695 E.00396
; CHANGE_LAYER
; Z_HEIGHT: 3.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7887.74
G1 X129.97 Y127.643 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/50
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
G17
G3 Z3.58 I-.504 J-1.108 P1  F42000
M73 P81 R4
G1 X128.13 Y128.481 Z3.58
G1 Z3.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00864
; LINE_WIDTH: 0.512863
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438163
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407991
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379906
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.35182
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341386
G1 X131.063 Y131.439 E.02189
; LINE_WIDTH: 0.388905
G1 X131.042 Y131.506 E.00199
; LINE_WIDTH: 0.436424
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483942
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531461
G1 X130.976 Y131.707 E.0028
; LINE_WIDTH: 0.57898
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.57898
G1 X130.877 Y131.707 E.00316
; LINE_WIDTH: 0.531461
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483942
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.436424
G1 X130.793 Y131.507 E.00232
; LINE_WIDTH: 0.388905
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.341386
G1 X130.77 Y130.523 E.02232
; LINE_WIDTH: 0.350644
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424407
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z3.78 F42000
G1 Z3.38
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530836
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00167
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429979
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474965
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.519951
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564937
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609922
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632399
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589919
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547439
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504959
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462479
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459592
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493076
G2 X128.951 Y135.185 I5.354 J-.067 E.02928
; LINE_WIDTH: 0.480881
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.45044
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445319
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454701
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559982
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517854
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475726
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.56657
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523626
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475702
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517111
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558519
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515297
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472074
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428851
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393085
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390655
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437743
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.48483
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531917
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1658.565 J-4.306 E.13331
G2 X124.291 Y128.316 I.172 J.26 E.01132
G1 X124.291 Y128.317 E.00005
; LINE_WIDTH: 0.531917
G1 X124.256 Y128.401 E.00363
G1 X124.236 Y128.45 E.0021
; LINE_WIDTH: 0.48483
G1 X124.209 Y128.517 E.00258
G1 X124.182 Y128.583 E.00259
; LINE_WIDTH: 0.437743
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390655
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385319
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412696
G1 X124.172 Y129.556 E.00635
; LINE_WIDTH: 0.462247
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511798
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561349
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563715
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529127
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494539
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523626
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.56657
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512187
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559982
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553525
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518063
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482601
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445319
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.45044
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480881
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493076
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459592
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462479
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504959
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547439
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589919
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632399
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609922
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582094
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554266
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509987
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576627
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538793
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500959
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460479
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.028 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.403 J1.381 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.23 Y131.61 E.00478
G1 X130.384 Y131.485 E.0061
G1 X130.406 Y131.468 E.00084
G1 X130.447 Y131.358 E.00363
G1 X130.443 Y130.518 E.0258
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466197
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512395
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558593
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.60479
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.019
G1 X128.665 Y129.736 E-.06528
G1 X128.525 Y129.856 E-.06998
G1 X128.491 Y129.898 E-.02059
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z3.78 F42000
G1 Z3.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573201
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23719
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19061
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z3.78 F42000
G1 Z3.38
G1 E.8 F1800
; LINE_WIDTH: 0.472528
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8379.733
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z3.78 F42000
G1 Z3.38
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581118
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583734
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600726
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.61531
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599734
G1 X128.57 Y135.932 E.01195
; WIPE_START
G1 F6465.355
G1 X128.562 Y136.195 E-.10005
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.683 Y137.633 E-.12214
; WIPE_END
G1 E-.04 F1800
G1 X128.661 Y130.064 Z3.78 F42000
G1 X128.986 Y127.549 Z3.78
G1 Z3.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590106
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500906
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 3.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.502
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/50
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z3.78 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z3.78
G1 Z3.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407986
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379903
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.35182
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341383
G1 X131.063 Y131.439 E.02189
; LINE_WIDTH: 0.388903
G1 X131.042 Y131.506 E.00199
; LINE_WIDTH: 0.436422
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483942
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531461
G1 X130.976 Y131.707 E.0028
; LINE_WIDTH: 0.578981
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.6265
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.578981
G1 X130.877 Y131.707 E.00316
; LINE_WIDTH: 0.531461
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483942
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.436422
G1 X130.793 Y131.507 E.00232
; LINE_WIDTH: 0.388903
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.341383
G1 X130.77 Y130.523 E.02232
; LINE_WIDTH: 0.350644
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424404
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z3.98 F42000
G1 Z3.58
G1 E.8 F1800
; LINE_WIDTH: 0.360815
G1 F1200
G1 X128.108 Y129.733 E.00561
G1 X128.141 Y129.811 E.00218
G1 X128.14 Y130.329 E.01343
G1 X127.753 Y129.822 E.01653
G1 X127.959 Y129.591 E.00801
G1 X128.355 Y129.444 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.531394
G1 F1200
G1 X128.386 Y129.507 E.0028
; LINE_WIDTH: 0.494263
G1 X128.418 Y129.57 E.00259
; LINE_WIDTH: 0.457131
G1 X128.449 Y129.63 E.0023
G1 X128.45 Y129.632 E.00008
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391229
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.571 E.01088
G1 X128.832 Y133.697 E.00725
G1 X128.854 Y133.919 E.00685
; LINE_WIDTH: 0.46324
G1 X128.861 Y134.205 E.0098
; LINE_WIDTH: 0.506481
G2 X128.926 Y135.021 I4.875 J.022 E.03095
; LINE_WIDTH: 0.497523
G1 X128.972 Y135.279 E.00972
; LINE_WIDTH: 0.458761
G1 X129.017 Y135.538 E.00889
; LINE_WIDTH: 0.419999
G1 X129.033 Y136.133 E.01831
G1 X128.97 Y136.559 E.01323
G1 X128.747 Y137.145 E.01927
G1 X128.459 Y137.58 E.01604
G1 X128.105 Y137.946 E.01562
G1 X127.625 Y138.259 E.01761
G1 X127.093 Y138.457 E.01744
G1 X126.575 Y138.537 E.01611
G1 X126.024 Y138.504 E.01695
G1 X125.41 Y138.314 E.01975
G1 X124.904 Y138.022 E.01796
G1 X124.509 Y137.656 E.01656
G1 X124.297 Y137.382 E.01065
G1 X124.063 Y136.927 E.0157
G1 X123.98 Y136.669 E.00832
G1 X123.867 Y136.047 E.01943
; LINE_WIDTH: 0.445319
G1 X123.874 Y135.542 E.01656
; LINE_WIDTH: 0.4547
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.894 Y133.904 I-.969 J-.178 E.01694
; LINE_WIDTH: 0.51329
G1 X123.869 Y133.705 E.00771
; LINE_WIDTH: 0.466597
G1 X123.844 Y133.505 E.00694
; LINE_WIDTH: 0.419904
G1 X123.833 Y133.003 E.01543
; LINE_WIDTH: 0.449181
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.492986
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536791
G1 X123.893 Y132.382 E.00837
; LINE_WIDTH: 0.580596
G2 X123.905 Y132.007 I-1.256 J-.227 E.01647
; LINE_WIDTH: 0.566567
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480683
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.43774
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515305
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472092
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428879
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393115
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.389498
G1 X123.796 Y128.652 E.01424
; LINE_WIDTH: 0.436875
G1 X123.82 Y128.487 E.00535
; LINE_WIDTH: 0.484252
G1 X123.844 Y128.322 E.00599
; LINE_WIDTH: 0.531629
G1 X123.867 Y128.156 E.00664
; LINE_WIDTH: 0.579005
G1 X123.891 Y127.991 E.00728
G1 X123.886 Y125.054 E.12831
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.911 Y120.163 E.11538
; LINE_WIDTH: 0.542833
G1 X123.936 Y117.89 E.0926
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.542833
G1 X124.41 Y120.165 E.09254
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.11532
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579005
G2 X124.427 Y128.105 I1660.555 J-4.313 E.13331
G1 X124.351 Y128.197 E.00523
; LINE_WIDTH: 0.552777
G1 X124.274 Y128.289 E.00497
; LINE_WIDTH: 0.526549
G1 X124.225 Y128.434 E.00606
; LINE_WIDTH: 0.480866
G1 X124.176 Y128.58 E.00548
; LINE_WIDTH: 0.435182
G1 X124.126 Y128.725 E.00491
; LINE_WIDTH: 0.389498
G1 X124.095 Y129.141 E.01178
; LINE_WIDTH: 0.385338
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.41273
G1 X124.172 Y129.556 E.00635
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511836
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561388
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563727
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529135
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494543
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431525
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.43774
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480683
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566567
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601441
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.257 J.427 E.01605
; LINE_WIDTH: 0.560149
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518856
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477563
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441469
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.417964
G1 X124.217 Y133.455 E.01259
; LINE_WIDTH: 0.465304
G1 X124.265 Y133.611 E.00559
; LINE_WIDTH: 0.512644
G1 X124.314 Y133.766 E.00622
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00684
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445319
G1 X124.274 Y135.508 E.01375
G1 X124.472 Y135.862 E.01328
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01115
G1 X124.814 Y136.471 E.01128
G1 X125.043 Y136.896 E.01482
G1 X125.396 Y137.255 E.01548
G1 X125.829 Y137.491 E.01516
G1 X126.235 Y137.577 E.01274
G1 X126.804 Y137.552 E.0175
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.078 Y136.267 E.01303
G1 X128.118 Y135.779 E.01507
G1 X128.298 Y135.534 E.00934
; LINE_WIDTH: 0.45055
G1 X128.378 Y135.337 E.00707
; LINE_WIDTH: 0.4811
G1 X128.457 Y135.139 E.0076
; LINE_WIDTH: 0.493043
G1 X128.443 Y134.69 E.01647
G1 X128.337 Y134.492 E.00825
; LINE_WIDTH: 0.458725
G1 X128.231 Y134.293 E.00763
; LINE_WIDTH: 0.424406
G1 X127.941 Y133.998 E.01287
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00813
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01015
; LINE_WIDTH: 0.582105
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554271
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509992
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465712
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421432
G1 X127.852 Y131.055 E.00007
G1 X127.854 Y131.037 E.00057
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.283 Y129.906 E.01059
G1 X127.303 Y129.796 E.00346
; LINE_WIDTH: 0.467423
G1 X127.409 Y129.665 E.00581
G1 X127.415 Y129.657 E.00035
; LINE_WIDTH: 0.514847
G1 X127.527 Y129.518 E.00684
; LINE_WIDTH: 0.562271
G1 X127.602 Y129.425 E.0051
G1 X127.638 Y129.38 E.00244
; LINE_WIDTH: 0.609694
G1 X127.64 Y129.378 E.00011
G1 X127.75 Y129.241 E.00811
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576627
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538793
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500959
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460479
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.028 J-2.284 E.15108
G2 X131.672 Y134.53 I9.527 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G3 X132.064 Y136.129 I-.369 J.091 E.0118
G1 X131.87 Y136.169 E.0061
G1 X131.644 Y136.089 E.00735
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.406 J1.381 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.23 Y131.61 E.00478
G1 X130.384 Y131.486 E.00609
G1 X130.406 Y131.468 E.00085
G1 X130.447 Y131.358 E.00363
G1 X130.443 Y130.518 E.0258
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466197
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512394
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558592
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604789
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.283 E.00736
; LINE_WIDTH: 0.565835
G1 X128.348 Y129.384 E.00435
M204 S6000
; WIPE_START
G1 F6884.484
G1 X128.355 Y129.444 E-.02283
G1 X128.386 Y129.507 E-.02673
G1 X128.418 Y129.57 E-.02677
G1 X128.449 Y129.63 E-.02588
G1 X128.45 Y129.632 E-.00089
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13271
G1 X128.205 Y131.027 E-.06868
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z3.98 F42000
G1 Z3.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.532912
G1 F1200
G1 X124.459 Y136.739 E.01618
; LINE_WIDTH: 0.555296
G1 X124.773 Y137.269 E.02573
; LINE_WIDTH: 0.568042
G1 X125.192 Y137.663 E.02462
; LINE_WIDTH: 0.590662
G1 X125.666 Y137.922 E.0241
; LINE_WIDTH: 0.618322
G1 X126.118 Y138.036 E.02187
; LINE_WIDTH: 0.626612
M73 P82 R4
G2 X127.011 Y137.985 I.323 J-2.213 E.04284
; LINE_WIDTH: 0.623788
G1 X127.507 Y137.775 E.0255
; LINE_WIDTH: 0.613628
G1 X127.998 Y137.383 E.02921
; LINE_WIDTH: 0.606214
G1 X128.327 Y136.924 E.02594
G1 X128.517 Y136.43 E.02428
G1 X128.57 Y135.93 E.02306
; WIPE_START
G1 F6390.979
G1 X128.517 Y136.43 E-.19093
G1 X128.327 Y136.924 E-.20099
G1 X127.998 Y137.383 E-.21478
G1 X127.683 Y137.635 E-.1533
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z3.98 F42000
G1 Z3.58
G1 E.8 F1800
; LINE_WIDTH: 0.5732
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60127
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23719
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19061
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z3.98 F42000
G1 Z3.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586817
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.50091
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 3.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.434
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/50
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z3.98 I-.502 J-1.108 P1  F42000
G1 X128.154 Y128.463 Z3.98
G1 Z3.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638764
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.961 Y128.123 E.01898
G3 X128.15 Y127.739 I.967 J.238 E.02096
; LINE_WIDTH: 0.596906
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.555048
G1 X128.374 Y127.391 E.00864
; LINE_WIDTH: 0.51319
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481595
G1 X128.758 Y127.119 E.00841
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379904
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.35182
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341379
G1 X131.063 Y131.439 E.02189
; LINE_WIDTH: 0.388899
G1 X131.042 Y131.506 E.00199
; LINE_WIDTH: 0.436419
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483939
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531459
G1 X130.976 Y131.707 E.0028
; LINE_WIDTH: 0.578979
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.578979
G1 X130.877 Y131.707 E.00316
; LINE_WIDTH: 0.531459
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483939
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.436419
G1 X130.793 Y131.507 E.00232
; LINE_WIDTH: 0.388899
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.341379
G1 X130.77 Y130.523 E.02232
; LINE_WIDTH: 0.350644
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382248
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497191
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544382
G1 X128.925 Y128.021 E.0063
; LINE_WIDTH: 0.591573
G1 X128.773 Y128.046 E.00689
; LINE_WIDTH: 0.638764
G1 X128.621 Y128.072 E.00748
G1 X128.2 Y128.425 E.02667
; WIPE_START
G1 F6041.85
G1 X127.961 Y128.123 E-.14618
G1 X128.038 Y127.914 E-.08502
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08935
G1 X128.758 Y127.119 E-.08935
G1 X129.05 Y127.051 E-.11411
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z4.18 F42000
G1 Z3.78
G1 E.8 F1800
; LINE_WIDTH: 0.36183
G1 F1200
G1 X128.145 Y130.317 E.01316
G1 X128.118 Y130.338 E.00088
G1 X127.837 Y129.914 E.01319
G1 X127.755 Y129.823 E.0032
G1 X127.998 Y129.547 E.00956
G1 X128.112 Y129.758 E.00622
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F1200
G1 X128.387 Y129.508 E.00278
; LINE_WIDTH: 0.493891
G1 X128.418 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.0023
G1 X128.45 Y129.632 E.00006
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.639 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00527
G2 X128.525 Y129.856 I.134 J.299 E.00573
G1 X128.491 Y129.898 E.00167
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01702
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429983
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474972
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.519961
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.56495
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609939
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426107
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459608
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.95 Y135.182 I5.366 J-.068 E.02919
; LINE_WIDTH: 0.481426
G1 X128.991 Y135.47 E.01036
; LINE_WIDTH: 0.450713
G1 X129.032 Y135.757 E.00964
; LINE_WIDTH: 0.419999
G1 X128.999 Y136.412 E.02015
G3 X128.34 Y137.731 I-2.769 J-.558 E.04583
G1 X127.92 Y138.091 E.017
G1 X127.477 Y138.33 E.01548
G3 X126.63 Y138.539 I-1.273 J-3.327 E.02688
G1 X126.074 Y138.517 E.01709
G1 X125.539 Y138.377 E.017
G1 X125.045 Y138.127 E.017
G1 X124.616 Y137.778 E.017
G1 X124.3 Y137.383 E.01553
G1 X124.063 Y136.927 E.01581
G1 X123.98 Y136.669 E.00832
G1 X123.867 Y136.047 E.01943
; LINE_WIDTH: 0.445319
G1 X123.874 Y135.542 E.01656
; LINE_WIDTH: 0.454701
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489796
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566567
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.865 Y130.005 I-.548 J-.148 E.01273
; LINE_WIDTH: 0.520424
G1 X123.845 Y129.875 E.00512
; LINE_WIDTH: 0.482331
G1 X123.825 Y129.745 E.00471
; LINE_WIDTH: 0.444238
G1 X123.803 Y129.477 E.00877
; LINE_WIDTH: 0.401986
G1 X123.782 Y129.21 E.00784
; LINE_WIDTH: 0.387664
G1 X123.796 Y128.667 E.01525
; LINE_WIDTH: 0.435499
G1 X123.819 Y128.498 E.00546
; LINE_WIDTH: 0.483334
G1 X123.843 Y128.329 E.00612
; LINE_WIDTH: 0.531169
G1 X123.867 Y128.16 E.00679
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00745
G1 X123.886 Y125.054 E.12831
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.91 Y120.183 E.11453
; LINE_WIDTH: 0.54301
G1 X123.936 Y117.89 E.09344
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.54301
G1 X124.41 Y120.185 E.09338
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.11447
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.686 J-4.302 E.13331
G1 X124.351 Y128.197 E.00523
; LINE_WIDTH: 0.552754
G1 X124.274 Y128.289 E.00497
; LINE_WIDTH: 0.526504
G1 X124.224 Y128.439 E.00624
; LINE_WIDTH: 0.480224
G1 X124.174 Y128.589 E.00564
; LINE_WIDTH: 0.433944
G1 X124.124 Y128.74 E.00505
; LINE_WIDTH: 0.387664
G1 X124.095 Y129.142 E.01133
; LINE_WIDTH: 0.385315
G1 X124.134 Y129.349 E.00587
; LINE_WIDTH: 0.41273
G1 X124.172 Y129.556 E.00634
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511836
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561389
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563727
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529135
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494543
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566567
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445319
G1 X124.274 Y135.508 E.01375
G1 X124.472 Y135.862 E.01328
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01115
G1 X124.814 Y136.471 E.01128
G1 X125.038 Y136.888 E.01454
G1 X125.396 Y137.255 E.01575
G1 X125.829 Y137.491 E.01516
G1 X126.235 Y137.577 E.01275
M73 P82 R3
G1 X126.804 Y137.552 E.0175
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.078 Y136.266 E.01308
G1 X128.118 Y135.778 E.01505
G1 X128.304 Y135.521 E.00974
; LINE_WIDTH: 0.450713
G1 X128.381 Y135.33 E.00685
; LINE_WIDTH: 0.481426
G1 X128.457 Y135.138 E.00737
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01625
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459608
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426107
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609939
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582105
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554271
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509991
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.46571
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00448
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.558 Y130.12 E.01235
G1 X127.316 Y129.928 E.00949
G1 X127.275 Y129.825 E.00341
G1 X127.452 Y129.648 E.0077
; LINE_WIDTH: 0.467423
G1 X127.526 Y129.546 E.00436
; LINE_WIDTH: 0.514847
G1 X127.601 Y129.445 E.00485
; LINE_WIDTH: 0.562271
G1 X127.675 Y129.343 E.00534
; LINE_WIDTH: 0.609694
G1 X127.75 Y129.241 E.00582
; LINE_WIDTH: 0.616784
G1 X127.783 Y128.895 E.01624
G1 X127.761 Y128.853 E.00222
; LINE_WIDTH: 0.574525
G1 X127.739 Y128.811 E.00205
; LINE_WIDTH: 0.532266
G1 X127.717 Y128.769 E.00189
; LINE_WIDTH: 0.490006
G1 X127.658 Y128.613 E.00609
; LINE_WIDTH: 0.455003
G1 X127.599 Y128.456 E.00562
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00971
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.031 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.412 J1.381 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.229 Y131.61 E.00478
G1 X130.384 Y131.486 E.00609
G1 X130.406 Y131.468 E.00085
G1 X130.447 Y131.358 E.00363
G1 X130.443 Y130.518 E.0258
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.463456
G1 X128.628 Y128.704 E.00453
; LINE_WIDTH: 0.506913
G1 X128.557 Y128.782 E.00401
G1 X128.539 Y128.801 E.00099
; LINE_WIDTH: 0.55037
G1 X128.504 Y128.839 E.00214
G1 X128.45 Y128.899 E.00333
; LINE_WIDTH: 0.593827
G1 X128.36 Y128.996 E.00593
; LINE_WIDTH: 0.60129
G2 X128.335 Y129.286 I.287 J.17 E.01367
; LINE_WIDTH: 0.566064
G1 X128.348 Y129.386 E.0043
M204 S6000
; WIPE_START
G1 F6881.478
G1 X128.387 Y129.508 E-.04863
G1 X128.418 Y129.57 E-.02659
G1 X128.449 Y129.631 E-.02594
G1 X128.45 Y129.632 E-.00064
G1 X128.465 Y129.639 E-.00634
G1 X128.51 Y129.661 E-.01911
G1 X128.665 Y129.736 E-.06518
G1 X128.525 Y129.856 E-.06996
G1 X128.491 Y129.898 E-.02063
G1 X128.463 Y129.933 E-.01709
G1 X128.508 Y130.485 E-.21048
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06989
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z4.18 F42000
G1 Z3.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.537184
G1 F1200
G1 X124.454 Y136.736 E.01617
; LINE_WIDTH: 0.547646
G1 X124.741 Y137.229 E.02346
; LINE_WIDTH: 0.567842
G1 X125.164 Y137.643 E.02532
; LINE_WIDTH: 0.588246
G1 X125.619 Y137.901 E.02321
; LINE_WIDTH: 0.618246
G1 X126.143 Y138.042 E.02546
; LINE_WIDTH: 0.633452
G1 X126.617 Y138.05 E.02282
; LINE_WIDTH: 0.637614
G1 X127.227 Y137.906 E.03034
G1 X127.506 Y137.774 E.01499
; LINE_WIDTH: 0.612778
G1 X128.001 Y137.385 E.02921
G1 X128.342 Y136.906 E.02734
; LINE_WIDTH: 0.606134
G1 X128.517 Y136.429 E.02331
G1 X128.57 Y135.928 E.02312
; WIPE_START
G1 F6391.886
G1 X128.517 Y136.429 E-.19145
G1 X128.342 Y136.906 E-.19301
G1 X128.001 Y137.385 E-.22372
G1 X127.687 Y137.632 E-.15182
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z4.18 F42000
G1 Z3.78
G1 E.8 F1800
; LINE_WIDTH: 0.472576
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.796
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z4.18 F42000
G1 Z3.78
G1 E.8 F1800
; LINE_WIDTH: 0.573201
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23719
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19061
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z4.18 F42000
G1 Z3.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590114
G1 F1200
G1 X129.358 Y127.485 E.01685
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530407
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500908
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 3.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.477
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/50
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z4.18 I-.566 J-1.077 P1  F42000
G1 X128.108 Y128.62 Z4.18
G1 Z3.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.449999
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.861 Y128.125 E.01835
G1 X128.041 Y127.727 E.01449
G1 X128.352 Y127.369 E.01573
G1 X128.758 Y127.119 E.0158
G1 X129.264 Y127 E.01727
G1 X129.771 Y127.066 E.01696
G3 X130.788 Y127.965 I-.411 J1.489 E.04659
G1 X130.913 Y128.477 E.0175
G2 X130.964 Y129.212 I9.293 J-.28 E.02444
; LINE_WIDTH: 0.40091
G1 X131.003 Y129.667 E.01332
; LINE_WIDTH: 0.35182
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341374
G1 X131.063 Y131.439 E.02189
; LINE_WIDTH: 0.388895
G1 X131.042 Y131.506 E.00199
; LINE_WIDTH: 0.436416
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483936
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531457
G1 X130.976 Y131.707 E.0028
; LINE_WIDTH: 0.578978
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.578978
G1 X130.877 Y131.707 E.00316
; LINE_WIDTH: 0.531457
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483936
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.436416
G1 X130.793 Y131.507 E.00232
; LINE_WIDTH: 0.388895
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.341374
G1 X130.77 Y130.523 E.02232
; LINE_WIDTH: 0.350646
G1 X130.712 Y130.027 E.01254
; LINE_WIDTH: 0.382251
G3 X130.654 Y129.53 I2.765 J-.575 E.01384
G1 X130.657 Y129.308 E.00614
; LINE_WIDTH: 0.41044
G1 X130.623 Y129.053 E.00771
; LINE_WIDTH: 0.449999
G1 X130.589 Y128.798 E.00854
G1 X130.28 Y128.333 E.01852
G2 X129.657 Y127.999 I-1.362 J1.789 E.02354
G1 X129.103 Y127.986 E.0184
G1 X128.596 Y128.188 E.0181
G1 X128.153 Y128.58 E.01964
; WIPE_START
G1 F8843.491
G1 X127.861 Y128.125 E-.20545
G1 X128.041 Y127.727 E-.16602
G1 X128.352 Y127.369 E-.18019
G1 X128.758 Y127.119 E-.18104
G1 X128.828 Y127.103 E-.02731
; WIPE_END
G1 E-.04 F1800
G1 X128.146 Y129.8 Z4.38 F42000
G1 Z3.98
G1 E.8 F1800
; LINE_WIDTH: 0.363076
G1 F1200
G1 X128.14 Y130.328 E.01379
G1 X127.772 Y129.836 E.01604
G1 X127.998 Y129.549 E.00954
G1 X128.116 Y129.748 E.00604
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.533175
G1 F1200
G1 X128.386 Y129.504 E.00279
; LINE_WIDTH: 0.49545
G1 X128.418 Y129.568 E.00264
; LINE_WIDTH: 0.457725
G1 X128.449 Y129.63 E.00234
G1 X128.45 Y129.632 E.00008
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.639 E.00052
G1 X128.511 Y129.661 E.00155
G1 X128.665 Y129.736 E.00527
G2 X128.525 Y129.856 I.133 J.299 E.00574
G1 X128.491 Y129.898 E.00167
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01702
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.444 Y132.628 E.01096
G1 X128.447 Y132.743 E.00552
G1 X128.447 Y132.763 E.00096
; LINE_WIDTH: 0.58894
G1 X128.448 Y132.779 E.00067
G1 X128.45 Y132.898 E.00534
; LINE_WIDTH: 0.545453
G1 X128.453 Y133.033 E.00553
; LINE_WIDTH: 0.501966
G1 X128.456 Y133.168 E.00505
; LINE_WIDTH: 0.458479
G1 X128.456 Y133.188 E.00068
G1 X128.458 Y133.303 E.0039
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00981
G1 X128.832 Y133.697 E.00725
G1 X128.855 Y133.928 E.00714
; LINE_WIDTH: 0.463014
G1 X128.862 Y134.211 E.00968
; LINE_WIDTH: 0.506029
G2 X128.931 Y135.089 I5.481 J.008 E.03326
; LINE_WIDTH: 0.500901
G1 X128.981 Y135.377 E.01093
; LINE_WIDTH: 0.46045
G1 X129.03 Y135.666 E.00996
; LINE_WIDTH: 0.419999
G1 X129.032 Y136.185 E.01594
G1 X128.907 Y136.789 E.01898
G1 X128.674 Y137.29 E.01695
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.477 Y138.329 E.01547
G1 X126.964 Y138.492 E.01654
G1 X126.348 Y138.542 E.01898
G1 X125.802 Y138.461 E.01695
G1 X125.285 Y138.265 E.017
G1 X124.86 Y137.99 E.01556
G1 X124.474 Y137.619 E.01645
G1 X124.134 Y137.103 E.01898
G1 X123.943 Y136.586 E.01695
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559986
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517857
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.865 Y130.005 I-.548 J-.148 E.01273
; LINE_WIDTH: 0.520425
G1 X123.845 Y129.875 E.00512
; LINE_WIDTH: 0.482331
G1 X123.825 Y129.745 E.00471
; LINE_WIDTH: 0.444237
G1 X123.803 Y129.477 E.00877
; LINE_WIDTH: 0.401985
G1 X123.782 Y129.21 E.00784
; LINE_WIDTH: 0.386147
G1 X123.795 Y128.681 E.01481
; LINE_WIDTH: 0.434362
G1 X123.819 Y128.508 E.00555
; LINE_WIDTH: 0.482576
G1 X123.843 Y128.336 E.00623
; LINE_WIDTH: 0.53079
G1 X123.867 Y128.164 E.00692
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.0076
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.91 Y120.203 E.11369
; LINE_WIDTH: 0.543187
G1 X123.936 Y117.89 E.09429
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.543187
G1 X124.41 Y120.205 E.09423
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.11363
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.688 J-4.302 E.13331
G1 X124.351 Y128.197 E.00523
; LINE_WIDTH: 0.552755
G1 X124.274 Y128.289 E.00497
; LINE_WIDTH: 0.526506
G1 X124.224 Y128.443 E.0064
; LINE_WIDTH: 0.47972
G1 X124.173 Y128.597 E.00578
; LINE_WIDTH: 0.432934
G1 X124.123 Y128.752 E.00516
; LINE_WIDTH: 0.386147
G1 X124.095 Y129.142 E.01096
; LINE_WIDTH: 0.385295
G1 X124.134 Y129.349 E.00587
; LINE_WIDTH: 0.41273
G1 X124.172 Y129.556 E.00634
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511835
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561387
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563727
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529135
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494543
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518863
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477571
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464393
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.51219
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559986
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.804 Y137.552 E.01516
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.777 E.01306
G1 X128.309 Y135.51 E.01009
; LINE_WIDTH: 0.450862
G1 X128.383 Y135.324 E.00666
; LINE_WIDTH: 0.481724
G1 X128.458 Y135.138 E.00717
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01623
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.115 Y133.19 E.00614
; LINE_WIDTH: 0.39018
G1 X128.141 Y132.992 E.00566
; LINE_WIDTH: 0.397351
G1 X128.162 Y132.943 E.00152
; LINE_WIDTH: 0.434341
G1 X128.183 Y132.895 E.00167
; LINE_WIDTH: 0.483863
G1 X128.19 Y132.801 E.00341
; LINE_WIDTH: 0.533384
G1 X128.198 Y132.706 E.00379
; LINE_WIDTH: 0.582906
G1 X128.205 Y132.612 E.00417
; LINE_WIDTH: 0.632427
G1 X128.213 Y132.517 E.00456
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582102
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554266
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509987
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.558 Y130.124 E.01227
G1 X127.318 Y129.928 E.00952
G1 X127.275 Y129.823 E.00351
G1 X127.431 Y129.66 E.00693
; LINE_WIDTH: 0.467423
G1 X127.511 Y129.555 E.00455
; LINE_WIDTH: 0.514846
G1 X127.59 Y129.451 E.00506
; LINE_WIDTH: 0.56227
G1 X127.594 Y129.445 E.00028
G1 X127.67 Y129.346 E.00529
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00608
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.207 Y127.97 E.00806
G1 X131.31 Y128.475 E.01585
G2 X131.492 Y133.388 I128.028 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.409 J1.381 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.229 Y131.61 E.00478
G1 X130.384 Y131.486 E.00608
G1 X130.406 Y131.469 E.00086
G1 X130.447 Y131.358 E.00363
G1 X130.443 Y130.518 E.0258
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.208 Y128.891 E.0139
G1 X129.993 Y128.598 E.01116
G1 X129.656 Y128.4 E.01199
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
M73 P83 R3
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 X128.335 Y129.281 E.00727
; LINE_WIDTH: 0.566726
G1 X128.347 Y129.383 E.00435
M204 S6000
; WIPE_START
G1 F6872.774
G1 X128.386 Y129.504 E-.04855
G1 X128.418 Y129.568 E-.02718
G1 X128.449 Y129.63 E-.02628
G1 X128.45 Y129.632 E-.0009
G1 X128.465 Y129.639 E-.00637
G1 X128.511 Y129.661 E-.01914
G1 X128.665 Y129.736 E-.06517
G1 X128.525 Y129.856 E-.06998
G1 X128.491 Y129.898 E-.02063
G1 X128.463 Y129.933 E-.01711
G1 X128.508 Y130.485 E-.21045
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.027 E-.0687
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z4.38 F42000
G1 Z3.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.530498
G1 F1200
G1 X124.46 Y136.736 E.01601
; LINE_WIDTH: 0.547968
G1 X124.76 Y137.251 E.02453
; LINE_WIDTH: 0.580486
G1 X125.114 Y137.609 E.02207
; LINE_WIDTH: 0.604468
G1 X125.498 Y137.844 E.02061
; LINE_WIDTH: 0.617364
G1 X125.923 Y137.998 E.02114
; LINE_WIDTH: 0.621672
G1 X126.364 Y138.062 E.021
G1 X126.921 Y138.004 E.02643
; LINE_WIDTH: 0.613358
G1 X127.507 Y137.775 E.02924
; LINE_WIDTH: 0.618328
G1 X128.003 Y137.387 E.02953
G1 X128.356 Y136.869 E.0294
; LINE_WIDTH: 0.597954
G1 X128.531 Y136.35 E.02476
; LINE_WIDTH: 0.583108
G1 X128.57 Y135.926 E.01875
; WIPE_START
G1 F6664.347
G1 X128.531 Y136.35 E-.16186
G1 X128.356 Y136.869 E-.20805
G1 X128.003 Y137.387 E-.2383
G1 X127.688 Y137.633 E-.15179
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z4.38 F42000
G1 Z3.98
G1 E.8 F1800
; LINE_WIDTH: 0.472576
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.796
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z4.38 F42000
G1 Z3.98
G1 E.8 F1800
; LINE_WIDTH: 0.573203
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23719
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19061
; WIPE_END
G1 E-.04 F1800
G1 X128.663 Y127.683 Z4.38 F42000
G1 Z3.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.533645
G1 F1200
G1 X128.875 Y127.597 E.00914
; LINE_WIDTH: 0.562119
G1 X129.087 Y127.512 E.00967
; LINE_WIDTH: 0.593526
G1 X129.358 Y127.497 E.01222
G1 X129.772 Y127.552 E.01872
; LINE_WIDTH: 0.539273
G1 X129.916 Y127.626 E.00655
; LINE_WIDTH: 0.508166
G1 X130.06 Y127.7 E.00614
; CHANGE_LAYER
; Z_HEIGHT: 4.18
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7737.851
G1 X129.916 Y127.626 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/50
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
G17
G3 Z4.38 I-.549 J-1.086 P1  F42000
G1 X128.139 Y128.524 Z4.38
G1 Z4.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638637
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.02091
G3 X128.151 Y127.74 I.745 J.106 E.02086
; LINE_WIDTH: 0.598072
G1 X128.263 Y127.566 E.00936
; LINE_WIDTH: 0.557506
G1 X128.375 Y127.392 E.00868
; LINE_WIDTH: 0.51694
G1 X128.566 Y127.256 E.00908
; LINE_WIDTH: 0.48347
G1 X128.758 Y127.119 E.00844
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.40799
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379906
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351821
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341372
G1 X131.063 Y131.439 E.02189
; LINE_WIDTH: 0.388893
G1 X131.042 Y131.506 E.00199
; LINE_WIDTH: 0.436414
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483934
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531455
G1 X130.976 Y131.707 E.0028
; LINE_WIDTH: 0.578976
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.578976
G1 X130.877 Y131.707 E.00316
; LINE_WIDTH: 0.531455
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483934
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.436414
G1 X130.793 Y131.507 E.00232
; LINE_WIDTH: 0.388893
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.341372
G1 X130.77 Y130.523 E.02232
; LINE_WIDTH: 0.350643
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382245
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.285 Y128.338 E.01694
G1 X129.854 Y128.062 E.01698
G1 X129.312 Y127.964 E.01826
G1 X129.069 Y128.013 E.00821
; LINE_WIDTH: 0.497441
G1 X128.961 Y128.024 E.00404
; LINE_WIDTH: 0.544882
G1 X128.852 Y128.036 E.00446
; LINE_WIDTH: 0.592323
G1 X128.744 Y128.048 E.00488
; LINE_WIDTH: 0.639764
G1 X128.636 Y128.059 E.0053
G1 X128.375 Y128.273 E.0164
; LINE_WIDTH: 0.638637
G1 X128.18 Y128.48 E.01379
; WIPE_START
G1 F6043.138
G1 X127.975 Y128.126 E-.15559
G1 X128.038 Y127.914 E-.08412
G1 X128.151 Y127.74 E-.07863
G1 X128.263 Y127.566 E-.07863
G1 X128.375 Y127.392 E-.07863
G1 X128.566 Y127.256 E-.0893
G1 X128.758 Y127.119 E-.0893
G1 X129.029 Y127.056 E-.1058
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z4.58 F42000
G1 Z4.18
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X127.755 Y129.822 E.01657
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.390946
G1 X128.193 Y131.19 E.00978
; LINE_WIDTH: 0.427371
G1 X128.206 Y131.271 E.00257
; LINE_WIDTH: 0.471558
G1 X128.219 Y131.352 E.00286
; LINE_WIDTH: 0.515745
G1 X128.232 Y131.433 E.00316
; LINE_WIDTH: 0.559932
G1 X128.246 Y131.514 E.00345
; LINE_WIDTH: 0.604119
G1 X128.259 Y131.595 E.00375
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01698
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.95 Y135.18 I5.384 J-.068 E.02908
; LINE_WIDTH: 0.482042
G1 X128.991 Y135.432 E.00916
; LINE_WIDTH: 0.451021
G1 X129.032 Y135.685 E.00851
; LINE_WIDTH: 0.419999
G1 X129.031 Y136.196 E.01571
G1 X128.907 Y136.789 E.01862
G1 X128.674 Y137.29 E.01696
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.01701
G1 X126.952 Y138.494 E.01538
G1 X126.348 Y138.542 E.01862
G1 X125.802 Y138.461 E.01696
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.01701
G1 X124.466 Y137.61 E.01538
G1 X124.134 Y137.104 E.01862
G1 X123.943 Y136.586 E.01696
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524888
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559982
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517854
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475726
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536823
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580638
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566567
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.866 Y130.008 I-.542 J-.147 E.01257
; LINE_WIDTH: 0.521644
G1 X123.846 Y129.882 E.00499
; LINE_WIDTH: 0.484771
G1 X123.827 Y129.756 E.0046
; LINE_WIDTH: 0.447898
G1 X123.804 Y129.483 E.00903
; LINE_WIDTH: 0.403816
G1 X123.782 Y129.21 E.00805
; LINE_WIDTH: 0.384669
G1 X123.794 Y128.694 E.01438
; LINE_WIDTH: 0.433253
G1 X123.818 Y128.518 E.00564
; LINE_WIDTH: 0.481837
G1 X123.842 Y128.343 E.00634
; LINE_WIDTH: 0.530421
G1 X123.867 Y128.167 E.00704
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00774
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.689 J-4.302 E.13331
G1 X124.351 Y128.197 E.00523
; LINE_WIDTH: 0.552756
G1 X124.274 Y128.289 E.00497
; LINE_WIDTH: 0.526507
G1 X124.223 Y128.447 E.00655
; LINE_WIDTH: 0.479228
G1 X124.172 Y128.605 E.00591
; LINE_WIDTH: 0.431949
G1 X124.121 Y128.763 E.00527
; LINE_WIDTH: 0.384669
G1 X124.095 Y129.143 E.01059
; LINE_WIDTH: 0.385275
G1 X124.134 Y129.349 E.00586
; LINE_WIDTH: 0.41273
G1 X124.172 Y129.556 E.00633
; LINE_WIDTH: 0.451131
G1 X124.218 Y129.653 E.00359
; LINE_WIDTH: 0.489531
G1 X124.265 Y129.75 E.00392
; LINE_WIDTH: 0.527932
G1 X124.311 Y129.848 E.00426
; LINE_WIDTH: 0.566332
G1 X124.358 Y129.945 E.0046
G1 X124.532 Y130.097 E.00985
G2 X124.358 Y130.326 I.159 J.302 E.01267
; LINE_WIDTH: 0.530872
G1 X124.293 Y130.463 E.00605
; LINE_WIDTH: 0.495411
G1 X124.229 Y130.601 E.00561
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566567
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518863
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477571
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441474
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512187
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559982
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.804 Y137.552 E.01516
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.776 E.01308
G1 X128.313 Y135.499 E.01043
; LINE_WIDTH: 0.451021
G1 X128.386 Y135.318 E.00648
; LINE_WIDTH: 0.482042
G1 X128.458 Y135.137 E.00697
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01621
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609943
G2 X127.756 Y131.65 I-.136 J-.221 E.00997
; LINE_WIDTH: 0.582941
G1 X127.792 Y131.559 E.00431
; LINE_WIDTH: 0.555939
G1 X127.806 Y131.437 E.00511
G1 X127.812 Y131.394 E.00184
; LINE_WIDTH: 0.511193
G1 X127.815 Y131.361 E.00127
G1 X127.831 Y131.229 E.00507
; LINE_WIDTH: 0.466446
G1 X127.85 Y131.064 E.00573
; LINE_WIDTH: 0.421699
G1 X127.854 Y131.032 E.00099
G1 X127.87 Y130.899 E.00414
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01404
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
G1 X127.754 Y128.896 E.01593
; LINE_WIDTH: 0.568047
G1 X127.731 Y128.849 E.00225
; LINE_WIDTH: 0.5218
G1 X127.707 Y128.802 E.00205
; LINE_WIDTH: 0.475552
G1 X127.684 Y128.755 E.00185
; LINE_WIDTH: 0.429304
G1 X127.598 Y128.455 E.00983
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00968
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.027 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.42 J1.381 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.229 Y131.61 E.00478
G1 X130.384 Y131.486 E.00607
G1 X130.406 Y131.469 E.00087
G1 X130.447 Y131.358 E.00363
G1 X130.443 Y130.518 E.0258
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.593 Y128.721 E.01205
; LINE_WIDTH: 0.465536
G1 X128.524 Y128.823 E.00425
; LINE_WIDTH: 0.511073
G1 X128.454 Y128.925 E.00471
; LINE_WIDTH: 0.55661
G1 X128.385 Y129.027 E.00517
; LINE_WIDTH: 0.602146
G1 X128.315 Y129.13 E.00563
G1 X128.335 Y129.287 E.00725
; LINE_WIDTH: 0.566492
G1 X128.347 Y129.386 E.00423
M204 S6000
; WIPE_START
G1 F6875.852
G1 X128.387 Y129.508 E-.04868
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02059
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06983
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z4.58 F42000
G1 Z4.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5305
G1 F1200
G1 X124.46 Y136.736 E.01601
; LINE_WIDTH: 0.549166
G1 X124.759 Y137.251 E.02457
; LINE_WIDTH: 0.580496
G1 X125.114 Y137.609 E.02209
; LINE_WIDTH: 0.604464
G1 X125.498 Y137.844 E.02062
; LINE_WIDTH: 0.617362
G1 X125.923 Y137.998 E.02114
; LINE_WIDTH: 0.621868
G1 X126.365 Y138.062 E.02105
G1 X126.922 Y138.005 E.0264
; LINE_WIDTH: 0.613358
G1 X127.507 Y137.775 E.02924
; LINE_WIDTH: 0.618328
G1 X128.003 Y137.387 E.02953
G1 X128.356 Y136.869 E.0294
; LINE_WIDTH: 0.597956
G1 X128.532 Y136.35 E.02476
; LINE_WIDTH: 0.582704
G1 X128.57 Y135.924 E.01883
; WIPE_START
G1 F6669.334
G1 X128.532 Y136.35 E-.16268
G1 X128.356 Y136.869 E-.20805
G1 X128.003 Y137.387 E-.2383
G1 X127.69 Y137.632 E-.15097
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z4.58 F42000
G1 Z4.18
G1 E.8 F1800
; LINE_WIDTH: 0.472576
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.796
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z4.58 F42000
G1 Z4.18
G1 E.8 F1800
; LINE_WIDTH: 0.573195
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60126
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646512
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23719
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19061
; WIPE_END
G1 E-.04 F1800
G1 X128.987 Y127.548 Z4.58 F42000
G1 Z4.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590182
G1 F1200
G1 X129.358 Y127.485 E.0168
; LINE_WIDTH: 0.586815
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500907
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 4.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.485
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/50
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z4.58 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z4.58
G1 Z4.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554835
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512865
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407989
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379905
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351821
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341366
G1 X131.063 Y131.439 E.02189
; LINE_WIDTH: 0.388888
G1 X131.042 Y131.506 E.00199
; LINE_WIDTH: 0.43641
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483932
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531454
G1 X130.976 Y131.707 E.0028
; LINE_WIDTH: 0.578976
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.578976
G1 X130.877 Y131.707 E.00316
; LINE_WIDTH: 0.531454
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483932
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.43641
G1 X130.793 Y131.507 E.00232
; LINE_WIDTH: 0.388888
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.341366
G1 X130.77 Y130.523 E.02232
; LINE_WIDTH: 0.350644
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.14 Y129.81 Z4.78 F42000
G1 Z4.38
G1 E.8 F1800
; LINE_WIDTH: 0.364283
G1 F1200
G1 X128.139 Y130.328 E.01357
G3 X127.762 Y129.82 I2.486 J-2.239 E.01658
G1 X127.999 Y129.55 E.0094
G1 X128.106 Y129.733 E.00557
G1 X128.116 Y129.755 E.00061
G1 X128.354 Y129.44 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.535047
G1 F1200
G1 X128.385 Y129.502 E.00278
; LINE_WIDTH: 0.496698
G1 X128.418 Y129.567 E.0027
; LINE_WIDTH: 0.458349
G1 X128.449 Y129.629 E.00234
G1 X128.45 Y129.632 E.00013
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429983
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474972
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.519962
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564951
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.60994
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632426
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589941
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.50497
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.352 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00904
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.685 E.00841
; LINE_WIDTH: 0.419999
G1 X129.031 Y136.208 E.01607
G1 X128.907 Y136.789 E.01826
G1 X128.674 Y137.29 E.01697
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.01701
G1 X126.941 Y138.497 E.01574
G1 X126.349 Y138.542 E.01826
G1 X125.802 Y138.461 E.01697
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.01701
G1 X124.459 Y137.602 E.01574
G1 X124.134 Y137.104 E.01826
G1 X123.943 Y136.586 E.01697
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454701
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566563
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523622
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515305
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428881
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.688 J-4.302 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385352
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.41273
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511836
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561389
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563727
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529135
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494543
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523622
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566563
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.804 Y137.552 E.01516
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.50497
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589941
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632426
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.60994
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582105
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.55427
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.283 Y129.906 E.01059
G1 X127.303 Y129.791 E.00359
; LINE_WIDTH: 0.467423
G1 X127.33 Y129.758 E.00148
G1 X127.415 Y129.654 E.00465
; LINE_WIDTH: 0.514846
G1 X127.526 Y129.516 E.00681
; LINE_WIDTH: 0.56227
G1 X127.603 Y129.421 E.00517
G1 X127.638 Y129.379 E.00233
; LINE_WIDTH: 0.609693
G1 X127.641 Y129.375 E.00019
G1 X127.75 Y129.241 E.00799
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.028 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00682
G2 X130.422 Y131.721 I-41.413 J1.381 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.229 Y131.61 E.00478
G1 X130.383 Y131.486 E.00606
G1 X130.406 Y131.469 E.00087
G1 X130.447 Y131.358 E.00363
G1 X130.443 Y130.518 E.02581
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
M73 P84 R3
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 X128.335 Y129.279 E.00719
; LINE_WIDTH: 0.567662
G1 X128.346 Y129.381 E.00435
M204 S6000
; WIPE_START
G1 F6860.514
G1 X128.385 Y129.502 E-.04842
G1 X128.418 Y129.567 E-.02773
G1 X128.449 Y129.629 E-.0263
G1 X128.45 Y129.632 E-.00143
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.025 E-.06787
; WIPE_END
G1 E-.04 F1800
G1 X128.571 Y135.932 Z4.78 F42000
G1 Z4.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.585434
G1 F1200
G1 X128.532 Y136.35 E.01855
; LINE_WIDTH: 0.597956
G1 X128.356 Y136.869 E.02476
; LINE_WIDTH: 0.618326
G1 X128.003 Y137.387 E.0294
G1 X127.507 Y137.775 E.02953
; LINE_WIDTH: 0.613358
G1 X126.922 Y138.006 E.02924
; LINE_WIDTH: 0.622078
G1 X126.366 Y138.062 E.02638
G1 X125.923 Y137.998 E.0211
; LINE_WIDTH: 0.617362
G1 X125.498 Y137.844 E.02114
; LINE_WIDTH: 0.604468
G1 X125.114 Y137.609 E.02062
; LINE_WIDTH: 0.580518
G1 X124.758 Y137.251 E.02212
; LINE_WIDTH: 0.550404
G1 X124.46 Y136.736 E.02461
; LINE_WIDTH: 0.5305
G1 X124.347 Y136.349 E.016
; WIPE_START
G1 F7383.404
G1 X124.46 Y136.736 E-.15304
G1 X124.758 Y137.251 E-.22612
G1 X125.114 Y137.609 E-.1919
G1 X125.498 Y137.844 E-.17124
G1 X125.542 Y137.86 E-.0177
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z4.78 F42000
G1 Z4.38
G1 E.8 F1800
; LINE_WIDTH: 0.472576
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.796
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z4.78 F42000
G1 Z4.38
G1 E.8 F1800
; LINE_WIDTH: 0.573203
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23719
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19061
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z4.78 F42000
G1 Z4.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 4.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.459
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 23/50
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z4.78 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z4.78
G1 Z4.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638771
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596802
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407986
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351835
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332921
G1 X131.067 Y131.411 E.02096
; LINE_WIDTH: 0.381851
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.43078
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.47971
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528639
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577569
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.9 Y131.784 E.00311
; LINE_WIDTH: 0.587394
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548289
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509184
G1 X130.803 Y131.614 E.00249
; LINE_WIDTH: 0.470079
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.42436
G1 X130.787 Y131.456 E.00131
; LINE_WIDTH: 0.378641
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332921
G1 X130.77 Y130.513 E.02132
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497192
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544385
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591578
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638771
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.779
G1 X127.975 Y128.126 E-.14252
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z4.98 F42000
G1 Z4.58
G1 E.8 F1800
; LINE_WIDTH: 0.360701
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.443 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.0001
; LINE_WIDTH: 0.530837
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.351 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.685 E.00841
; LINE_WIDTH: 0.419999
G1 X129.03 Y136.219 E.01643
G1 X128.907 Y136.789 E.0179
G1 X128.674 Y137.29 E.01698
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.01701
G1 X126.93 Y138.499 E.0161
G1 X126.349 Y138.543 E.0179
G1 X125.802 Y138.461 E.01698
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.01701
G1 X124.451 Y137.593 E.0161
G1 X124.134 Y137.104 E.0179
G1 X123.943 Y136.586 E.01697
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515305
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428881
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563163
G1 X123.91 Y120.263 E.11114
; LINE_WIDTH: 0.543716
G1 X123.936 Y117.89 E.09684
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.543716
G1 X124.41 Y120.265 E.09678
; LINE_WIDTH: 0.563163
G1 X124.412 Y122.885 E.11109
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09375
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.688 J-4.302 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385352
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412731
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462284
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511837
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561389
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563727
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529135
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494543
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518861
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477569
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441472
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.798 Y137.553 E.01499
G1 X127.264 Y137.373 E.01533
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582104
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554269
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509989
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.03 J-2.284 E.15108
G2 X131.672 Y134.53 I9.527 J-.918 E.03555
G2 X132.16 Y135.774 I6.89 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.403 J1.381 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.229 Y131.61 E.0048
G1 X130.385 Y131.486 E.00613
G1 X130.406 Y131.47 E.00079
G1 X130.447 Y131.36 E.00361
G1 X130.443 Y130.518 E.02588
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.383 E.00427
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.355 Y129.445 E-.02367
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.026 E-.06821
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z4.98 F42000
G1 Z4.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5732
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601264
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23719
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19061
; WIPE_END
G1 E-.04 F1800
G1 X128.46 Y133.954 Z4.98 F42000
G1 Z4.58
G1 E.8 F1800
; LINE_WIDTH: 0.472578
G1 F1200
G1 X128.305 Y133.794 E.00783
; WIPE_START
G1 F8378.757
G1 X128.46 Y133.954 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z4.98 F42000
G1 Z4.58
G1 E.8 F1800
; LINE_WIDTH: 0.530456
G1 F1200
G1 X124.459 Y136.736 E.01601
; LINE_WIDTH: 0.546344
G1 X124.719 Y137.197 E.0217
; LINE_WIDTH: 0.580992
G1 X125.112 Y137.608 E.02492
; LINE_WIDTH: 0.583736
G1 X125.658 Y137.916 E.02766
; LINE_WIDTH: 0.600726
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.61984
G1 X126.816 Y138.03 E.02805
G1 X127.434 Y137.815 E.03075
; LINE_WIDTH: 0.615306
G1 X127.944 Y137.445 E.02937
; LINE_WIDTH: 0.62528
G1 X128.261 Y137.041 E.02437
G1 X128.451 Y136.636 E.02125
; LINE_WIDTH: 0.621074
G1 X128.563 Y136.169 E.02262
; LINE_WIDTH: 0.599648
G1 X128.571 Y135.932 E.01074
; WIPE_START
G1 F6466.354
G1 X128.563 Y136.169 E-.08994
G1 X128.451 Y136.636 E-.18247
G1 X128.261 Y137.041 E-.17015
G1 X127.944 Y137.445 E-.19511
G1 X127.683 Y137.634 E-.12234
; WIPE_END
G1 E-.04 F1800
G1 X128.661 Y130.064 Z4.98 F42000
G1 X128.986 Y127.549 Z4.98
G1 Z4.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.50091
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 4.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.434
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/50
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z4.98 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z4.98
G1 Z4.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554835
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512865
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01692
G3 X130.615 Y127.656 I-.538 J1.671 E.03467
G1 X130.788 Y127.965 E.01175
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407989
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379912
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351834
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332809
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381757
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430705
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479653
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587428
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.54836
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509292
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470223
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424419
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378614
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332809
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z5.18 F42000
G1 Z4.78
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.141 Y129.789 E.00729
G3 X128.129 Y130.341 I-8.364 J.091 E.01431
G1 X127.755 Y129.822 E.01657
G1 X127.959 Y129.591 E.00798
G1 X128.354 Y129.443 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565556
G1 F1200
G1 X128.355 Y129.445 E.00012
; LINE_WIDTH: 0.530836
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429983
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474972
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.519961
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.56495
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609939
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.351 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.685 E.0084
; LINE_WIDTH: 0.419999
G1 X129.029 Y136.23 E.01675
G1 X128.907 Y136.789 E.01757
G1 X128.674 Y137.29 E.01698
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.92 Y138.502 E.01643
G1 X126.349 Y138.543 E.01757
G1 X125.802 Y138.461 E.01698
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.144 Y137.121 E.01643
G1 X123.943 Y136.585 E.01757
G1 X123.868 Y136.051 E.01659
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454701
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566564
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558519
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515306
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.42888
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563163
G1 X123.909 Y120.283 E.1103
; LINE_WIDTH: 0.543893
G1 X123.936 Y117.89 E.09769
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.543893
G1 X124.41 Y120.285 E.09763
; LINE_WIDTH: 0.563163
G1 X124.412 Y122.885 E.11024
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09375
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.689 J-4.302 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385352
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.41273
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462284
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511838
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561391
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563728
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529136
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494544
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566564
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.789 Y137.554 E.01469
G1 X127.264 Y137.373 E.01561
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609939
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582103
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554267
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509988
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465708
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
M73 P85 R3
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500954
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.138 Y126.771 E.01422
G1 X130.501 Y126.983 E.0129
G1 X130.866 Y127.328 E.01545
G1 X131.116 Y127.724 E.01437
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.031 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.89 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.488 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.405 Y131.471 E.00107
G1 X130.447 Y131.36 E.00363
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.68 Y128.413 E.01123
G1 X129.275 Y128.354 E.01258
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558588
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604784
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.348 Y129.383 E.00425
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.355 Y129.445 E-.02383
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.025 E-.06805
; WIPE_END
G1 E-.04 F1800
G1 X128.571 Y135.932 Z5.18 F42000
G1 Z4.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.584788
G1 F1200
G1 X128.533 Y136.351 E.01854
; LINE_WIDTH: 0.597958
G1 X128.356 Y136.869 E.02476
; LINE_WIDTH: 0.61833
G1 X128.003 Y137.387 E.02941
G1 X127.507 Y137.775 E.02953
; LINE_WIDTH: 0.613358
G1 X126.905 Y138.008 E.03002
; LINE_WIDTH: 0.622424
G1 X126.368 Y138.062 E.0255
G1 X125.923 Y137.998 E.0212
; LINE_WIDTH: 0.617366
G1 X125.498 Y137.844 E.02114
; LINE_WIDTH: 0.604466
G1 X125.111 Y137.607 E.02076
; LINE_WIDTH: 0.581114
G1 X124.745 Y137.238 E.0228
; LINE_WIDTH: 0.551612
G1 X124.46 Y136.736 E.02396
; LINE_WIDTH: 0.530458
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.04
G1 X124.46 Y136.736 E-.15293
G1 X124.745 Y137.238 E-.21967
G1 X125.111 Y137.607 E-.19754
G1 X125.498 Y137.844 E-.17243
G1 X125.541 Y137.86 E-.01744
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z5.18 F42000
G1 Z4.78
G1 E.8 F1800
; LINE_WIDTH: 0.472578
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.757
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z5.18 F42000
G1 Z4.78
G1 E.8 F1800
; LINE_WIDTH: 0.573198
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601262
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z5.18 F42000
G1 Z4.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586855
G1 X129.614 Y127.537 E.01157
; LINE_WIDTH: 0.55916
G1 X129.87 Y127.588 E.01098
; LINE_WIDTH: 0.530873
G1 X129.961 Y127.638 E.00413
; LINE_WIDTH: 0.501994
G1 X130.052 Y127.688 E.00389
; CHANGE_LAYER
; Z_HEIGHT: 4.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7841.882
G1 X129.961 Y127.638 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 25/50
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z5.18 I-.509 J-1.105 P1  F42000
G1 X128.13 Y128.481 Z5.18
G1 Z4.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638855
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.741 I.757 J.111 E.02079
; LINE_WIDTH: 0.59686
G1 X128.262 Y127.566 E.00938
; LINE_WIDTH: 0.554864
G1 X128.374 Y127.391 E.00867
; LINE_WIDTH: 0.512868
G1 X128.566 Y127.255 E.009
; LINE_WIDTH: 0.481434
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.77 Y127.067 E.01689
G3 X130.616 Y127.656 I-.541 J1.679 E.0347
G1 X130.788 Y127.965 E.01174
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438159
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407996
G1 X130.975 Y129.232 E.01295
; LINE_WIDTH: 0.379915
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528602
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.57755
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587431
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548363
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509296
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470228
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424422
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378616
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350643
G1 X130.712 Y130.021 E.01241
; LINE_WIDTH: 0.382306
G3 X130.657 Y129.311 I2.666 J-.563 E.01975
; LINE_WIDTH: 0.39737
G1 X130.611 Y129.038 E.008
; LINE_WIDTH: 0.42441
G1 X130.564 Y128.765 E.00861
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497213
G1 X129.077 Y127.995 E.00569
; LINE_WIDTH: 0.544427
G1 X128.925 Y128.02 E.00628
; LINE_WIDTH: 0.591641
G1 X128.774 Y128.045 E.00687
; LINE_WIDTH: 0.638855
G1 X128.622 Y128.071 E.00746
G1 X128.176 Y128.443 E.02819
; WIPE_START
G1 F6040.927
G1 X127.975 Y128.126 E-.1425
G1 X128.038 Y127.916 E-.08322
G1 X128.15 Y127.741 E-.07896
G1 X128.262 Y127.566 E-.07896
G1 X128.374 Y127.391 E-.07896
G1 X128.566 Y127.255 E-.08935
G1 X128.758 Y127.119 E-.08935
G1 X129.062 Y127.048 E-.11869
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z5.38 F42000
G1 Z4.98
G1 E.8 F1800
; LINE_WIDTH: 0.360701
G1 F1200
G1 X128.108 Y129.733 E.00561
G1 X128.141 Y129.811 E.00218
G1 X128.129 Y130.341 E.01374
G1 X127.755 Y129.822 E.01657
G1 X127.959 Y129.591 E.00798
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00013
; LINE_WIDTH: 0.530838
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426107
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459608
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.352 J-.067 E.02928
; LINE_WIDTH: 0.480903
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450451
G1 X129.032 Y135.685 E.0084
; LINE_WIDTH: 0.419999
G1 X129.029 Y136.241 E.01711
G1 X128.907 Y136.788 E.01721
G1 X128.674 Y137.29 E.01699
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.908 Y138.504 E.01678
G1 X126.349 Y138.543 E.01721
G1 X125.802 Y138.461 E.01699
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566567
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558519
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515306
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.42888
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563163
G1 X123.909 Y120.303 E.10945
; LINE_WIDTH: 0.54407
G1 X123.936 Y117.89 E.09854
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.54407
G1 X124.41 Y120.305 E.09848
; LINE_WIDTH: 0.563163
G1 X124.412 Y122.885 E.10939
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09375
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.76 J-4.303 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385351
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412728
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511837
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561391
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563728
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529136
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494544
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566567
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.778 Y137.555 E.01437
G1 X127.264 Y137.373 E.01593
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450451
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480903
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459608
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426107
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582104
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.55427
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.188 E.00974
G1 X127.498 Y127.944 E.00779
G1 X127.713 Y127.493 E.01537
G1 X128.003 Y127.144 E.01395
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.69 Y126.635 E.01418
G1 X130.137 Y126.771 E.01434
G1 X130.501 Y126.984 E.01297
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01434
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.033 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.061 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.514 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00682
G2 X130.422 Y131.721 I-41.497 J1.385 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.00169
G1 X130.093 Y129.526 E.00539
G2 X130.238 Y129.414 I-.094 J-.271 E.0057
G1 X130.282 Y129.361 E.00213
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01296
G1 X129.994 Y128.599 E.01208
G1 X129.687 Y128.417 E.01099
G1 X129.275 Y128.354 E.0128
G1 X128.892 Y128.467 E.01227
G1 X128.717 Y128.607 E.00688
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00478
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00441
G1 X128.531 Y128.812 E.0009
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.00258
G1 X128.438 Y128.915 E.00325
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00003
G2 X128.317 Y129.122 I.142 J.221 E.01136
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.347 Y129.383 E.00424
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.355 Y129.445 E-.02396
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.01897
G1 X128.665 Y129.736 E-.06528
G1 X128.525 Y129.856 E-.06998
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.025 E-.06796
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z5.38 F42000
G1 Z4.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573196
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601258
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19059
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z5.38 F42000
G1 Z4.98
G1 E.8 F1800
; LINE_WIDTH: 0.472578
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.757
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z5.38 F42000
G1 Z4.98
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583736
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600726
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.622286
G1 X126.816 Y138.031 E.02816
G1 X127.432 Y137.816 E.0308
; LINE_WIDTH: 0.615308
G1 X127.944 Y137.445 E.02949
; LINE_WIDTH: 0.625278
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.634 E.02134
; LINE_WIDTH: 0.621252
G1 X128.562 Y136.189 E.0216
; LINE_WIDTH: 0.599712
G1 X128.571 Y135.932 E.01166
; WIPE_START
G1 F6465.61
G1 X128.562 Y136.189 E-.09765
G1 X128.452 Y136.634 E-.17418
G1 X128.261 Y137.041 E-.17089
G1 X127.944 Y137.445 E-.19509
G1 X127.683 Y137.634 E-.1222
; WIPE_END
G1 E-.04 F1800
G1 X128.661 Y130.064 Z5.38 F42000
G1 X128.986 Y127.549 Z5.38
G1 Z4.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590073
G1 F1200
G1 X129.358 Y127.485 E.01685
; LINE_WIDTH: 0.586648
G1 X129.614 Y127.537 E.01158
; LINE_WIDTH: 0.558675
G1 X129.871 Y127.589 E.01099
; LINE_WIDTH: 0.530191
G1 X129.965 Y127.641 E.00427
; LINE_WIDTH: 0.501197
G1 X130.059 Y127.693 E.00402
; CHANGE_LAYER
; Z_HEIGHT: 5.18
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7855.511
G1 X129.965 Y127.641 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/50
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z5.38 I-.507 J-1.106 P1  F42000
G1 X128.13 Y128.481 Z5.38
G1 Z5.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638771
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596802
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00902
; LINE_WIDTH: 0.481432
G1 X128.759 Y127.119 E.00842
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01725
G1 X129.771 Y127.067 E.01695
G3 X130.616 Y127.656 I-.547 J1.685 E.03466
G1 X130.788 Y127.965 E.01172
G1 X130.919 Y128.476 E.01751
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479653
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587428
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548359
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.50929
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470221
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424418
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378614
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497192
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544385
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591578
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638771
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.779
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08951
G1 X128.759 Y127.119 E-.08951
G1 X129.062 Y127.048 E-.1183
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z5.58 F42000
G1 Z5.18
G1 E.8 F1800
; LINE_WIDTH: 0.360699
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565556
G1 F1200
G1 X128.355 Y129.445 E.00014
; LINE_WIDTH: 0.530836
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391223
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429983
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474972
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.519961
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.56495
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.49311
G2 X128.951 Y135.185 I5.352 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.01699
G1 X127.916 Y138.093 E.01714
G1 X127.433 Y138.353 E.01685
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.803 Y138.461 E.01699
G1 X125.281 Y138.263 E.01714
G1 X124.821 Y137.964 E.01685
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515305
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.42888
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522592
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.531 E.00661
G1 X124.251 Y117.533 E.00668
G1 X124.385 Y117.64 E.00672
G1 X124.412 Y117.894 E.00997
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.688 J-4.302 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385352
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.41273
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462284
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511838
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561391
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563728
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529136
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494544
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
M73 P86 R3
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.49311
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582104
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554269
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509989
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00448
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500956
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.366 Y126.871 E.01395
G1 X128.791 Y126.687 E.01421
G1 X129.23 Y126.609 E.01371
G1 X129.695 Y126.636 E.0143
G1 X130.141 Y126.773 E.01434
G1 X130.502 Y126.984 E.01286
G1 X130.87 Y127.333 E.01557
G1 X131.116 Y127.724 E.01419
G1 X131.209 Y127.978 E.00832
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.031 J-2.284 E.15108
G2 X131.672 Y134.53 I9.527 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.514 Y133.73 E.03106
G1 X130.493 Y133.721 E.00068
G1 X130.445 Y133.699 E.00163
G1 X130.311 Y133.639 E.0045
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.487 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.241 Y129.411 I-.101 J-.28 E.00583
G1 X130.282 Y129.361 E.002
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.274 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.347 Y129.382 E.00423
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.355 Y129.445 E-.02406
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.025 E-.06782
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z5.58 F42000
G1 Z5.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.64819
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X128.46 Y133.954 Z5.58 F42000
G1 Z5.18
G1 E.8 F1800
; LINE_WIDTH: 0.47258
G1 F1200
G1 X128.305 Y133.794 E.00783
; WIPE_START
G1 F8378.718
G1 X128.46 Y133.954 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z5.58 F42000
G1 Z5.18
G1 E.8 F1800
; LINE_WIDTH: 0.530456
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.58109
G1 X125.112 Y137.607 E.02506
; LINE_WIDTH: 0.583296
G1 X125.658 Y137.916 E.02763
; LINE_WIDTH: 0.600726
G1 X126.22 Y138.051 E.02626
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.615136
G1 X127.944 Y137.445 E.02951
; LINE_WIDTH: 0.625284
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599732
G1 X128.57 Y135.932 E.01195
; WIPE_START
G1 F6465.378
G1 X128.562 Y136.195 E-.10006
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.1951
G1 X127.683 Y137.633 E-.12213
; WIPE_END
G1 E-.04 F1800
G1 X128.661 Y130.064 Z5.58 F42000
G1 X128.986 Y127.549 Z5.58
G1 Z5.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.59004
G1 F1200
G1 X129.358 Y127.485 E.0168
; LINE_WIDTH: 0.586586
G1 X129.615 Y127.537 E.01161
; LINE_WIDTH: 0.558498
G1 X129.871 Y127.589 E.01101
; LINE_WIDTH: 0.529865
G1 X129.967 Y127.642 E.00435
; LINE_WIDTH: 0.500687
G1 X130.063 Y127.696 E.00409
; CHANGE_LAYER
; Z_HEIGHT: 5.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7864.263
G1 X129.967 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 27/50
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z5.58 I-.505 J-1.107 P1  F42000
G1 X128.13 Y128.48 Z5.58
G1 Z5.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.639668
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.976 Y128.126 E.01881
G3 X128.151 Y127.739 I.774 J.118 E.02091
; LINE_WIDTH: 0.59755
G1 X128.263 Y127.565 E.00934
; LINE_WIDTH: 0.555431
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.513312
G1 X128.567 Y127.255 E.00906
; LINE_WIDTH: 0.481656
G1 X128.761 Y127.119 E.00845
; LINE_WIDTH: 0.449999
G1 X129.271 Y126.999 E.01739
G1 X129.718 Y127.05 E.01491
G3 X130.788 Y127.964 I-.396 J1.547 E.04835
G1 X130.919 Y128.476 E.01752
; LINE_WIDTH: 0.438162
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351835
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.41 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528602
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.57755
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587425
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548351
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509278
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470204
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424406
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378608
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350578
G1 X130.712 Y130.021 E.01241
; LINE_WIDTH: 0.382175
G3 X130.657 Y129.312 I2.663 J-.563 E.01973
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.284 Y128.337 E.01696
G1 X129.854 Y128.062 E.01696
G1 X129.312 Y127.964 E.01826
G1 X129.072 Y128.012 E.00811
; LINE_WIDTH: 0.497417
G1 X128.961 Y128.025 E.00413
; LINE_WIDTH: 0.544834
G1 X128.851 Y128.038 E.00456
; LINE_WIDTH: 0.592251
G1 X128.74 Y128.051 E.005
; LINE_WIDTH: 0.639668
G1 X128.629 Y128.065 E.00543
G1 X128.176 Y128.442 E.02864
; WIPE_START
G1 F6032.697
G1 X127.976 Y128.126 E-.14233
G1 X128.04 Y127.913 E-.08435
G1 X128.151 Y127.739 E-.07853
G1 X128.263 Y127.565 E-.07853
G1 X128.374 Y127.391 E-.07853
G1 X128.567 Y127.255 E-.08986
G1 X128.761 Y127.119 E-.08986
G1 X129.063 Y127.048 E-.11801
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z5.78 F42000
G1 Z5.38
G1 E.8 F1800
; LINE_WIDTH: 0.360708
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.141 Y130.335 E.01359
G3 X127.755 Y129.822 I2.797 J-2.51 E.01666
G1 X127.851 Y129.713 E.00375
G1 X127.959 Y129.591 E.00422
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00015
; LINE_WIDTH: 0.530837
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.488 E.01712
G1 X128.389 Y130.565 E.00436
G1 X128.22 Y130.845 E.01005
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00983
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.49311
G2 X128.951 Y135.185 I5.352 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.73 E.01698
G1 X127.906 Y138.099 E.0175
G1 X127.433 Y138.353 E.0165
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454701
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566564
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515306
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472094
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428881
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563163
G1 X123.909 Y120.343 E.10776
; LINE_WIDTH: 0.544424
G1 X123.936 Y117.89 E.10024
; LINE_WIDTH: 0.52265
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.248 Y117.532 E.00656
G1 X124.387 Y117.645 E.007
G1 X124.412 Y117.893 E.00974
; LINE_WIDTH: 0.544424
G1 X124.41 Y120.345 E.10018
; LINE_WIDTH: 0.563163
G1 X124.412 Y122.885 E.1077
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09375
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.689 J-4.302 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385351
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412729
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511836
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561389
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563728
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529136
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494544
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566564
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.49311
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582101
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554264
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509985
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465706
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421427
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500954
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.722 Y127.48 E.01583
G1 X128.003 Y127.143 E.0135
G1 X128.365 Y126.872 E.01388
G1 X128.801 Y126.685 E.01458
G1 X129.231 Y126.609 E.01341
G1 X129.693 Y126.636 E.01421
G1 X130.15 Y126.778 E.01472
G1 X130.503 Y126.985 E.01257
G1 X130.873 Y127.338 E.0157
G1 X131.116 Y127.724 E.01403
G1 X131.209 Y127.978 E.00831
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.029 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.448 Y133.7 E.00152
G1 X130.307 Y133.638 E.00473
G1 X130.446 Y133.509 E.00583
G1 X130.472 Y133.485 E.00107
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00682
G2 X130.422 Y131.721 I-41.49 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.318 Y129.635 E.02741
G1 X130.301 Y129.627 E.00059
G1 X130.251 Y129.602 E.00168
G1 X130.094 Y129.524 E.00539
G2 X130.24 Y129.414 I-.078 J-.255 E.00576
G1 X130.282 Y129.362 E.00204
G1 X130.306 Y129.332 E.00117
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.688 Y128.417 E.01095
G1 X129.274 Y128.354 E.01288
G1 X128.892 Y128.467 E.01224
G1 X128.717 Y128.606 E.00688
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00441
G1 X128.531 Y128.812 E.0009
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.00259
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00003
G2 X128.317 Y129.122 I.142 J.221 E.01136
; LINE_WIDTH: 0.600277
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.347 Y129.382 E.00422
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.355 Y129.445 E-.02414
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.488 E-.21174
G1 X128.389 Y130.565 E-.05392
G1 X128.22 Y130.845 E-.12428
G1 X128.206 Y131.023 E-.06791
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z5.78 F42000
G1 Z5.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573196
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60126
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z5.78 F42000
G1 Z5.38
G1 E.8 F1800
; LINE_WIDTH: 0.530498
G1 F1200
G1 X124.46 Y136.735 E.01599
; LINE_WIDTH: 0.547672
G1 X124.716 Y137.195 E.02164
; LINE_WIDTH: 0.580038
G1 X125.093 Y137.589 E.02389
; LINE_WIDTH: 0.601594
G1 X125.476 Y137.831 E.02058
; LINE_WIDTH: 0.612738
G1 X125.897 Y137.99 E.02094
; LINE_WIDTH: 0.61663
G1 X126.343 Y138.061 E.02108
G1 X126.866 Y138.018 E.02453
; LINE_WIDTH: 0.613208
G1 X127.431 Y137.815 E.0279
; LINE_WIDTH: 0.614712
G1 X127.944 Y137.445 E.02947
; LINE_WIDTH: 0.625284
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.633 E.02137
; LINE_WIDTH: 0.621312
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599734
G1 X128.57 Y135.932 E.01195
; WIPE_START
G1 F6465.355
G1 X128.562 Y136.195 E-.10006
G1 X128.452 Y136.633 E-.17157
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19507
G1 X127.683 Y137.633 E-.12216
; WIPE_END
G1 E-.04 F1800
G1 X128.663 Y130.064 Z5.78 F42000
G1 X128.989 Y127.548 Z5.78
G1 Z5.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.591104
G1 F1200
G1 X129.362 Y127.484 E.01691
; LINE_WIDTH: 0.587524
G1 X129.619 Y127.538 E.01168
; LINE_WIDTH: 0.557023
G1 X129.877 Y127.592 E.01102
; LINE_WIDTH: 0.52783
G1 X129.969 Y127.643 E.00418
; LINE_WIDTH: 0.499946
G1 X130.062 Y127.695 E.00394
; CHANGE_LAYER
; Z_HEIGHT: 5.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7877.014
G1 X129.969 Y127.643 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/50
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
G17
G3 Z5.78 I-.504 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z5.78
G1 Z5.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638774
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379912
M73 P86 R2
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351835
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332801
G1 X131.067 Y131.41 E.02094
; LINE_WIDTH: 0.381751
G1 X131.044 Y131.482 E.00208
; LINE_WIDTH: 0.4307
G1 X131.022 Y131.553 E.00238
; LINE_WIDTH: 0.479649
G1 X131 Y131.625 E.00268
; LINE_WIDTH: 0.528598
G1 X130.978 Y131.697 E.00298
; LINE_WIDTH: 0.577547
G1 X130.955 Y131.769 E.00328
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00358
G1 X130.9 Y131.784 E.00311
; LINE_WIDTH: 0.587362
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548227
G1 X130.835 Y131.671 E.0027
; LINE_WIDTH: 0.509092
G1 X130.803 Y131.614 E.00249
; LINE_WIDTH: 0.469957
G1 X130.794 Y131.547 E.00233
; LINE_WIDTH: 0.424239
G1 X130.785 Y131.481 E.00208
; LINE_WIDTH: 0.37852
G1 X130.777 Y131.414 E.00183
; LINE_WIDTH: 0.332801
G1 X130.77 Y130.513 E.0213
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544387
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591581
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638774
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.749
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z5.98 F42000
G1 Z5.58
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00015
; LINE_WIDTH: 0.530837
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.351 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566566
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523624
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515306
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.42888
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09382
; LINE_WIDTH: 0.563163
G1 X123.909 Y120.363 E.10691
; LINE_WIDTH: 0.544601
G1 X123.936 Y117.89 E.10109
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.544601
G1 X124.41 Y120.365 E.10103
; LINE_WIDTH: 0.563163
G1 X124.412 Y122.885 E.10685
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09375
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.762 J-4.303 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385351
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412728
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511837
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561391
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563728
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529136
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494544
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459952
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523624
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566566
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
M73 P87 R2
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582103
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554267
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509988
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465708
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.034 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.166 Y135.968 E.00595
G1 X132.063 Y136.13 E.00591
G1 X131.868 Y136.169 E.0061
G1 X131.644 Y136.089 E.0073
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.449 J1.383 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.229 Y131.61 E.00479
G1 X130.378 Y131.492 E.00582
G1 X130.406 Y131.47 E.0011
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02585
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.347 Y129.382 E.00422
M204 S6000
; WIPE_START
G1 F6888.153
G1 X128.355 Y129.445 E-.02418
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.024 E-.0677
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z5.98 F42000
G1 Z5.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573198
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601262
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X128.46 Y133.954 Z5.98 F42000
G1 Z5.58
G1 E.8 F1800
; LINE_WIDTH: 0.47258
G1 F1200
G1 X128.305 Y133.794 E.00783
; WIPE_START
G1 F8378.718
G1 X128.46 Y133.954 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.932 Z5.98 F42000
G1 Z5.58
G1 E.8 F1800
; LINE_WIDTH: 0.599736
G1 F1200
G1 X128.562 Y136.195 E.01195
; LINE_WIDTH: 0.621314
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.615306
G1 X127.431 Y137.816 E.02952
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0311
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600726
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583736
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581116
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.549032
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530456
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.07
G1 X124.459 Y136.736 E-.15298
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z5.98 F42000
G1 X128.986 Y127.549 Z5.98
G1 Z5.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.50091
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 5.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.434
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/50
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
G17
G3 Z5.98 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z5.98
G1 Z5.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638771
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.74 I.754 J.109 E.02087
; LINE_WIDTH: 0.596891
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.555011
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.513131
G1 X128.566 Y127.255 E.00902
; LINE_WIDTH: 0.481565
G1 X128.758 Y127.119 E.00841
; LINE_WIDTH: 0.449999
G1 X129.266 Y127 E.01732
G1 X129.764 Y127.064 E.01667
G3 X130.615 Y127.655 I-.546 J1.695 E.03487
G1 X130.788 Y127.965 E.01177
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379905
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351821
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341396
G1 X131.063 Y131.441 E.02194
; LINE_WIDTH: 0.388918
G1 X131.042 Y131.508 E.00199
; LINE_WIDTH: 0.43644
G1 X131.02 Y131.575 E.00226
; LINE_WIDTH: 0.483962
G1 X130.998 Y131.642 E.00253
; LINE_WIDTH: 0.531484
G1 X130.977 Y131.709 E.0028
; LINE_WIDTH: 0.579006
G1 X130.955 Y131.776 E.00308
; LINE_WIDTH: 0.626528
G1 X130.933 Y131.843 E.00335
G1 X130.905 Y131.776 E.00344
; LINE_WIDTH: 0.579006
G1 X130.877 Y131.71 E.00316
; LINE_WIDTH: 0.531484
G1 X130.849 Y131.643 E.00288
; LINE_WIDTH: 0.483962
G1 X130.821 Y131.576 E.0026
; LINE_WIDTH: 0.43644
G1 X130.793 Y131.51 E.00232
; LINE_WIDTH: 0.388918
G1 X130.765 Y131.443 E.00204
; LINE_WIDTH: 0.341396
G1 X130.77 Y130.523 E.02237
; LINE_WIDTH: 0.350644
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.31 E.01833
G1 X129.771 Y128.031 E.01838
G1 X129.227 Y127.969 E.01817
; LINE_WIDTH: 0.497192
G1 X129.076 Y127.995 E.00569
; LINE_WIDTH: 0.544385
G1 X128.924 Y128.02 E.00628
; LINE_WIDTH: 0.591578
G1 X128.773 Y128.046 E.00687
; LINE_WIDTH: 0.638771
G1 X128.621 Y128.072 E.00746
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.779
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.74 E-.07859
G1 X128.262 Y127.565 E-.07859
G1 X128.374 Y127.391 E-.07859
G1 X128.566 Y127.255 E-.08946
G1 X128.758 Y127.119 E-.08946
G1 X129.062 Y127.048 E-.11863
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z6.18 F42000
G1 Z5.78
G1 E.8 F1800
; LINE_WIDTH: 0.360719
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.142 Y130.342 E.01376
G1 X128.117 Y130.335 E.00066
G1 X127.755 Y129.822 E.01628
G1 X127.959 Y129.591 E.00798
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565556
G1 F1200
G1 X128.355 Y129.445 E.00016
; LINE_WIDTH: 0.530836
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.492 E.01722
G1 X128.373 Y130.584 E.00504
G1 X128.221 Y130.843 E.00924
; LINE_WIDTH: 0.391219
G1 X128.192 Y131.19 E.00989
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609937
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632426
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589941
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.50497
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.351 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566566
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523624
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515306
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.42888
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09382
; LINE_WIDTH: 0.563163
G1 X123.909 Y120.383 E.10606
; LINE_WIDTH: 0.544778
G1 X123.936 Y117.89 E.10194
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.544778
G1 X124.41 Y120.385 E.10188
; LINE_WIDTH: 0.563163
G1 X124.412 Y122.885 E.10601
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09375
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.688 J-4.302 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385351
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412729
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511836
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561389
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563727
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529135
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494543
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523624
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566566
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.50497
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589941
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632426
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609937
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582101
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554265
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509986
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.226 Y126.61 E.01372
G1 X129.695 Y126.636 E.01444
G1 X130.137 Y126.771 E.01419
G1 X130.498 Y126.982 E.01285
G1 X130.867 Y127.329 E.01558
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I127.861 J-2.278 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.723 I-41.076 J1.367 E.04691
G1 X130.408 Y131.715 E.0005
G1 X130.36 Y131.687 E.0017
G1 X130.229 Y131.611 E.00467
G1 X130.385 Y131.487 E.00613
G1 X130.406 Y131.471 E.00079
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.653 Y128.399 E.01215
G1 X129.277 Y128.354 E.01163
G1 X128.892 Y128.467 E.01235
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.347 Y129.382 E.00421
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.355 Y129.445 E-.02419
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.492 E-.21294
G1 X128.373 Y130.584 E-.06234
G1 X128.221 Y130.843 E-.11426
G1 X128.206 Y131.022 E-.06824
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z6.18 F42000
G1 Z5.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573203
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630502
G1 X130.933 Y131.843 E.02978
; WIPE_START
G1 F6126.805
G1 X130.951 Y132.465 E-.23633
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.839 E-.19147
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z6.18 F42000
G1 Z5.78
G1 E.8 F1800
; LINE_WIDTH: 0.472578
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.757
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.932 Z6.18 F42000
G1 Z5.78
G1 E.8 F1800
; LINE_WIDTH: 0.599736
G1 F1200
G1 X128.562 Y136.195 E.01195
; LINE_WIDTH: 0.621314
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.62528
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02436
; LINE_WIDTH: 0.615308
G1 X127.431 Y137.816 E.02953
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0311
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600722
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583736
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581116
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.549032
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530454
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.1
G1 X124.459 Y136.736 E-.15299
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z6.18 F42000
G1 X128.986 Y127.549 Z6.18
G1 Z5.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590119
G1 F1200
G1 X129.359 Y127.485 E.01687
; LINE_WIDTH: 0.586892
G1 X129.614 Y127.536 E.01152
; LINE_WIDTH: 0.558763
G1 X129.868 Y127.588 E.01092
; LINE_WIDTH: 0.530215
G1 X129.966 Y127.642 E.00443
; LINE_WIDTH: 0.501248
G1 X130.063 Y127.696 E.00416
; CHANGE_LAYER
; Z_HEIGHT: 5.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7854.645
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/50
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
G17
G3 Z6.18 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z6.18
G1 Z5.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407989
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379904
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351819
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341397
G1 X131.063 Y131.441 E.02194
; LINE_WIDTH: 0.388919
G1 X131.042 Y131.508 E.00199
; LINE_WIDTH: 0.43644
G1 X131.02 Y131.575 E.00226
; LINE_WIDTH: 0.483962
G1 X130.998 Y131.642 E.00253
; LINE_WIDTH: 0.531483
G1 X130.977 Y131.709 E.0028
; LINE_WIDTH: 0.579005
G1 X130.955 Y131.776 E.00308
; LINE_WIDTH: 0.626526
G1 X130.933 Y131.843 E.00335
G1 X130.905 Y131.776 E.00344
; LINE_WIDTH: 0.579005
G1 X130.877 Y131.71 E.00316
; LINE_WIDTH: 0.531483
G1 X130.849 Y131.643 E.00288
; LINE_WIDTH: 0.483962
G1 X130.821 Y131.576 E.0026
; LINE_WIDTH: 0.43644
G1 X130.793 Y131.51 E.00232
; LINE_WIDTH: 0.388919
G1 X130.765 Y131.443 E.00204
; LINE_WIDTH: 0.341397
G1 X130.77 Y130.523 E.02238
; LINE_WIDTH: 0.350644
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382248
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z6.38 F42000
G1 Z5.98
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00016
; LINE_WIDTH: 0.530837
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426107
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459608
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.352 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558519
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515306
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.42888
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.76 J-4.303 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385351
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412728
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511837
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561391
M73 P88 R2
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563728
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529136
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494544
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459608
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426107
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582104
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554269
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509989
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500954
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I127.85 J-2.277 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.723 I-41.073 J1.367 E.04691
G1 X130.408 Y131.715 E.0005
G1 X130.37 Y131.693 E.00137
G1 X130.229 Y131.611 E.00499
G1 X130.38 Y131.491 E.00591
G1 X130.406 Y131.471 E.00101
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466195
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512391
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558587
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604783
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.347 Y129.382 E.00422
M204 S6000
; WIPE_START
G1 F6888.153
G1 X128.355 Y129.445 E-.02418
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.024 E-.0677
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z6.38 F42000
G1 Z5.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573204
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601274
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.6305
G1 X130.933 Y131.843 E.02977
; WIPE_START
G1 F6126.825
G1 X130.951 Y132.465 E-.2363
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.839 E-.1915
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z6.38 F42000
G1 Z5.98
G1 E.8 F1800
; LINE_WIDTH: 0.472578
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.757
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.932 Z6.38 F42000
G1 Z5.98
G1 E.8 F1800
; LINE_WIDTH: 0.599734
G1 F1200
G1 X128.562 Y136.195 E.01195
; LINE_WIDTH: 0.621314
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.615312
G1 X127.431 Y137.816 E.02952
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.03111
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600724
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583738
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581116
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.549032
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530456
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.07
G1 X124.459 Y136.736 E-.15298
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z6.38 F42000
G1 X128.986 Y127.549 Z6.38
G1 Z5.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586815
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 6.18
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.459
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/50
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
G17
G3 Z6.38 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z6.38
G1 Z6.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554835
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512866
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481433
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407989
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379905
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.35182
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341402
G1 X131.063 Y131.441 E.02195
; LINE_WIDTH: 0.388923
G1 X131.042 Y131.508 E.00199
; LINE_WIDTH: 0.436444
G1 X131.02 Y131.575 E.00226
; LINE_WIDTH: 0.483964
G1 X130.998 Y131.642 E.00253
; LINE_WIDTH: 0.531485
G1 X130.977 Y131.709 E.0028
; LINE_WIDTH: 0.579006
G1 X130.955 Y131.776 E.00308
; LINE_WIDTH: 0.626526
G1 X130.933 Y131.843 E.00335
G1 X130.905 Y131.776 E.00344
; LINE_WIDTH: 0.579006
G1 X130.877 Y131.71 E.00316
; LINE_WIDTH: 0.531485
G1 X130.849 Y131.643 E.00288
; LINE_WIDTH: 0.483964
G1 X130.821 Y131.576 E.0026
; LINE_WIDTH: 0.436444
G1 X130.793 Y131.51 E.00232
; LINE_WIDTH: 0.388923
G1 X130.765 Y131.443 E.00204
; LINE_WIDTH: 0.341402
G1 X130.77 Y130.523 E.02238
; LINE_WIDTH: 0.350645
G1 X130.712 Y130.027 E.01254
; LINE_WIDTH: 0.382249
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z6.58 F42000
G1 Z6.18
G1 E.8 F1800
; LINE_WIDTH: 0.360699
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00015
; LINE_WIDTH: 0.530838
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429983
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474972
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.519961
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.56495
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609939
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426108
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.351 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.4547
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566564
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.43774
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515305
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472093
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428881
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.689 J-4.302 E.13331
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385351
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412728
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511837
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561391
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563728
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529136
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494543
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.43774
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566564
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518861
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477569
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426108
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609939
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582104
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554269
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509989
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I127.848 J-2.277 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.723 I-41.072 J1.367 E.04691
G1 X130.408 Y131.715 E.0005
G1 X130.37 Y131.693 E.00136
G1 X130.229 Y131.611 E.005
G1 X130.379 Y131.492 E.00586
G1 X130.406 Y131.471 E.00106
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.00169
G1 X130.093 Y129.525 E.0054
G2 X130.238 Y129.414 I-.09 J-.268 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.347 Y129.382 E.00422
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.355 Y129.445 E-.02415
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.0653
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.024 E-.06773
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z6.58 F42000
G1 Z6.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5732
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60127
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646518
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630502
G1 X130.933 Y131.843 E.02977
; WIPE_START
G1 F6126.805
G1 X130.951 Y132.465 E-.23628
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.839 E-.19153
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z6.58 F42000
G1 Z6.18
G1 E.8 F1800
; LINE_WIDTH: 0.47258
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.718
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.932 Z6.58 F42000
G1 Z6.18
G1 E.8 F1800
; LINE_WIDTH: 0.59973
G1 F1200
G1 X128.562 Y136.195 E.01195
; LINE_WIDTH: 0.621314
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.615308
G1 X127.431 Y137.816 E.02952
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0311
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600724
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583738
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581116
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.549032
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530456
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.07
G1 X124.459 Y136.736 E-.15299
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z6.58 F42000
G1 X128.986 Y127.549 Z6.58
G1 Z6.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.50091
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 6.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.434
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/50
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
G17
G3 Z6.58 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z6.58
G1 Z6.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438163
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407991
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379905
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351819
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341408
G1 X131.063 Y131.441 E.02195
; LINE_WIDTH: 0.388929
G1 X131.042 Y131.508 E.00199
; LINE_WIDTH: 0.436449
G1 X131.02 Y131.575 E.00226
; LINE_WIDTH: 0.483969
G1 X130.998 Y131.642 E.00253
; LINE_WIDTH: 0.53149
G1 X130.977 Y131.709 E.0028
; LINE_WIDTH: 0.57901
G1 X130.955 Y131.776 E.00308
; LINE_WIDTH: 0.62653
G1 X130.933 Y131.843 E.00335
G1 X130.905 Y131.777 E.00344
; LINE_WIDTH: 0.57901
G1 X130.877 Y131.71 E.00316
; LINE_WIDTH: 0.53149
G1 X130.849 Y131.643 E.00288
; LINE_WIDTH: 0.483969
G1 X130.821 Y131.576 E.0026
; LINE_WIDTH: 0.436449
G1 X130.793 Y131.51 E.00232
; LINE_WIDTH: 0.388929
G1 X130.765 Y131.443 E.00204
; LINE_WIDTH: 0.341408
G1 X130.77 Y130.523 E.02238
; LINE_WIDTH: 0.350645
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382249
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424407
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z6.78 F42000
G1 Z6.38
G1 E.8 F1800
; LINE_WIDTH: 0.360701
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00015
; LINE_WIDTH: 0.530838
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474971
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.51996
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564949
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609938
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632427
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02118
G1 X128.336 Y132.986 E.00102
; LINE_WIDTH: 0.589942
G1 X128.358 Y132.986 E.00095
; LINE_WIDTH: 0.547456
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504971
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462485
G1 X128.421 Y132.987 E.00073
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426109
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459609
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.352 J-.067 E.02928
; LINE_WIDTH: 0.480904
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450452
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.4547
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515306
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472094
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428881
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390688
M73 P89 R2
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.055 E.12827
; LINE_WIDTH: 0.573607
G1 X123.908 Y120.443 E.19945
; LINE_WIDTH: 0.545301
G1 X123.936 Y117.89 E.1045
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.545301
G1 X124.41 Y120.444 E.10442
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.19935
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1656.968 J-4.3 E.13328
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390688
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385351
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412728
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511837
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561391
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563728
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529136
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494544
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450452
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480904
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459609
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426109
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462485
G1 X128.197 Y132.969 E.00073
; LINE_WIDTH: 0.504971
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547456
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589942
G1 X128.26 Y132.979 E.00095
; LINE_WIDTH: 0.632427
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.0226
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609938
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582101
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.554264
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509985
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465706
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421427
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614462
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576628
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538793
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500958
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460479
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I127.841 J-2.277 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.514 Y133.729 E.03106
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00162
G1 X130.311 Y133.639 E.00451
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.723 I-41.067 J1.367 E.04691
G1 X130.408 Y131.715 E.0005
G1 X130.37 Y131.693 E.00135
G1 X130.229 Y131.611 E.00501
G1 X130.379 Y131.492 E.00586
G1 X130.406 Y131.471 E.00106
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466197
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512394
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558591
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604788
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.347 Y129.382 E.00422
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.355 Y129.445 E-.0241
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.025 E-.06778
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z6.78 F42000
G1 Z6.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60127
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648182
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630502
G1 X130.933 Y131.843 E.02977
; WIPE_START
G1 F6126.805
G1 X130.951 Y132.465 E-.23624
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.839 E-.19156
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z6.78 F42000
G1 Z6.38
G1 E.8 F1800
; LINE_WIDTH: 0.472576
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.796
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z6.78 F42000
G1 Z6.38
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.58112
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583734
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.03111
; LINE_WIDTH: 0.615308
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.59973
G1 X128.57 Y135.932 E.01195
; WIPE_START
G1 F6465.401
G1 X128.562 Y136.195 E-.10006
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.684 Y137.633 E-.12213
; WIPE_END
G1 E-.04 F1800
G1 X128.661 Y130.064 Z6.78 F42000
G1 X128.986 Y127.549 Z6.78
G1 Z6.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586816
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559044
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.53041
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500913
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 6.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.391
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/50
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
G17
G3 Z6.78 I-.504 J-1.108 P1  F42000
G1 X128.129 Y128.478 Z6.78
G1 Z6.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.639628
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.976 Y128.126 E.01868
G3 X128.152 Y127.74 I.74 J.105 E.02088
; LINE_WIDTH: 0.600015
G1 X128.264 Y127.567 E.0094
; LINE_WIDTH: 0.560402
G1 X128.377 Y127.393 E.00873
; LINE_WIDTH: 0.520789
G1 X128.567 Y127.256 E.00913
; LINE_WIDTH: 0.485394
G1 X128.758 Y127.119 E.00845
; LINE_WIDTH: 0.449999
G1 X129.272 Y126.999 E.01751
G1 X129.718 Y127.049 E.01489
G3 X130.618 Y127.658 I-.497 J1.704 E.03663
G1 X130.788 Y127.965 E.01163
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379903
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351819
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341411
G1 X131.063 Y131.441 E.02195
; LINE_WIDTH: 0.388961
G1 X131.042 Y131.508 E.00199
; LINE_WIDTH: 0.436512
G1 X131.02 Y131.575 E.00226
; LINE_WIDTH: 0.484062
G1 X130.998 Y131.642 E.00253
; LINE_WIDTH: 0.531612
G1 X130.976 Y131.709 E.0028
; LINE_WIDTH: 0.579162
G1 X130.955 Y131.776 E.00308
; LINE_WIDTH: 0.626712
G1 X130.933 Y131.843 E.00335
G1 X130.905 Y131.777 E.00344
; LINE_WIDTH: 0.579162
G1 X130.877 Y131.71 E.00316
; LINE_WIDTH: 0.531612
G1 X130.849 Y131.643 E.00288
; LINE_WIDTH: 0.484062
G1 X130.821 Y131.577 E.0026
; LINE_WIDTH: 0.436512
G1 X130.793 Y131.51 E.00232
; LINE_WIDTH: 0.388961
G1 X130.765 Y131.443 E.00204
; LINE_WIDTH: 0.341411
G1 X130.77 Y130.523 E.02238
; LINE_WIDTH: 0.350643
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.251 Y128.311 E.0183
G1 X129.785 Y128.037 E.01792
G1 X129.232 Y127.969 E.01851
; LINE_WIDTH: 0.497407
G1 X129.078 Y127.996 E.00577
; LINE_WIDTH: 0.544814
G1 X128.925 Y128.023 E.00637
; LINE_WIDTH: 0.592221
G1 X128.772 Y128.049 E.00697
; LINE_WIDTH: 0.639628
G1 X128.618 Y128.076 E.00757
G1 X128.176 Y128.44 E.02785
; WIPE_START
G1 F6033.102
G1 X127.976 Y128.126 E-.14146
G1 X128.039 Y127.914 E-.08395
G1 X128.152 Y127.74 E-.07868
G1 X128.264 Y127.567 E-.07868
G1 X128.377 Y127.393 E-.07868
G1 X128.567 Y127.256 E-.08908
G1 X128.758 Y127.119 E-.08908
G1 X129.066 Y127.047 E-.12039
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z6.98 F42000
G1 Z6.58
G1 E.8 F1800
; LINE_WIDTH: 0.36071
G1 F1200
G1 X128.145 Y130.317 E.01311
G1 X128.114 Y130.323 E.00083
G1 X127.755 Y129.822 E.01596
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00014
; LINE_WIDTH: 0.530838
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01074
; LINE_WIDTH: 0.391197
G1 X128.192 Y131.19 E.00978
; LINE_WIDTH: 0.430226
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.475459
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.520691
G1 X128.232 Y131.436 E.00324
; LINE_WIDTH: 0.565924
G1 X128.245 Y131.519 E.00354
; LINE_WIDTH: 0.611156
G1 X128.259 Y131.601 E.00385
; LINE_WIDTH: 0.632022
G1 X128.535 Y131.815 E.0168
G1 X128.6 Y132.462 E.03121
G1 X128.475 Y132.575 E.00812
G1 X128.315 Y132.986 E.02116
G1 X128.337 Y132.986 E.00102
; LINE_WIDTH: 0.589618
G1 X128.358 Y132.986 E.00094
; LINE_WIDTH: 0.547213
G1 X128.379 Y132.987 E.00087
; LINE_WIDTH: 0.504809
G1 X128.4 Y132.987 E.0008
; LINE_WIDTH: 0.462404
G1 X128.421 Y132.987 E.00072
; LINE_WIDTH: 0.419999
G1 X128.449 Y133.268 E.00868
G1 X128.632 Y133.572 E.01089
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426107
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459608
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493109
G2 X128.951 Y135.185 I5.352 J-.067 E.02929
; LINE_WIDTH: 0.480901
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.45045
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.4547
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566563
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523622
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.48068
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.477335
G1 X123.848 Y130.469 E.00619
; LINE_WIDTH: 0.520377
G1 X123.868 Y130.295 E.0068
; LINE_WIDTH: 0.563419
G2 X123.864 Y129.978 I-.56 J-.153 E.01366
; LINE_WIDTH: 0.518573
G1 X123.84 Y129.833 E.00567
; LINE_WIDTH: 0.473727
G1 X123.817 Y129.689 E.00513
; LINE_WIDTH: 0.42888
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393116
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390687
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.437767
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484846
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531925
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.055 E.12827
; LINE_WIDTH: 0.573607
G1 X123.908 Y120.463 E.19858
; LINE_WIDTH: 0.545478
G1 X123.936 Y117.89 E.10536
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.545478
G1 X124.41 Y120.464 E.10527
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.19848
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.029 J-4.3 E.13328
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531925
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484846
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00256
; LINE_WIDTH: 0.437767
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390687
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385351
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412729
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462283
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511836
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561389
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.564434
G1 X124.535 Y130.095 E.00971
G2 X124.364 Y130.321 I.162 J.301 E.01244
; LINE_WIDTH: 0.529879
G1 X124.296 Y130.46 E.00614
; LINE_WIDTH: 0.495324
G1 X124.229 Y130.599 E.00571
; LINE_WIDTH: 0.460768
G1 X124.201 Y130.817 E.00747
; LINE_WIDTH: 0.431935
G1 X124.173 Y131.034 E.00695
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.48068
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523622
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566563
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518863
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477571
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441474
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00578
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.45045
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480901
G1 X128.457 Y135.14 E.00775
; LINE_WIDTH: 0.493109
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459608
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426107
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.176 Y132.965 E.01327
; LINE_WIDTH: 0.462404
G1 X128.197 Y132.969 E.00072
; LINE_WIDTH: 0.504809
G1 X128.218 Y132.972 E.0008
; LINE_WIDTH: 0.547213
G1 X128.239 Y132.976 E.00087
; LINE_WIDTH: 0.589618
G1 X128.26 Y132.979 E.00094
; LINE_WIDTH: 0.632022
G1 X128.281 Y132.983 E.00102
G1 X128.213 Y132.517 E.02258
G1 X128.004 Y132.135 E.02091
G1 X127.638 Y131.823 E.02309
; LINE_WIDTH: 0.611156
G2 X127.755 Y131.65 I-.147 J-.225 E.00991
; LINE_WIDTH: 0.583283
G1 X127.797 Y131.551 E.00475
; LINE_WIDTH: 0.55541
G1 X127.811 Y131.426 E.00525
G1 X127.815 Y131.386 E.00166
; LINE_WIDTH: 0.510845
G1 X127.819 Y131.351 E.00134
G1 X127.833 Y131.222 E.00497
; LINE_WIDTH: 0.466279
G1 X127.852 Y131.057 E.00571
; LINE_WIDTH: 0.421714
G1 X127.854 Y131.035 E.00071
G1 X127.87 Y130.893 E.0044
; LINE_WIDTH: 0.419999
G1 X127.793 Y130.459 E.01354
G1 X127.556 Y130.11 E.01297
G1 X127.317 Y129.929 E.00923
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514847
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562271
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609694
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614462
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576627
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538792
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500957
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.237 Y126.609 E.01406
G1 X129.695 Y126.636 E.01411
G1 X130.137 Y126.771 E.01419
G1 X130.512 Y126.991 E.01334
G1 X130.867 Y127.329 E.01509
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G1 X131.412 Y131.798 E.10215
G2 X131.565 Y133.964 I20.13 J-.332 E.06677
G1 X131.672 Y134.53 E.01769
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.728 E.0311
G1 X130.493 Y133.72 E.00066
G1 X130.448 Y133.699 E.00153
G1 X130.311 Y133.639 E.00459
G1 X130.443 Y133.509 E.00568
G1 X130.472 Y133.482 E.00121
G1 X130.498 Y133.242 E.00742
G2 X130.422 Y131.724 I-31.525 J.822 E.04671
G1 X130.408 Y131.715 E.0005
G1 X130.37 Y131.693 E.00134
G1 X130.229 Y131.611 E.00502
G1 X130.379 Y131.492 E.00586
G1 X130.406 Y131.471 E.00106
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.689 Y128.417 E.01092
G1 X129.269 Y128.354 E.01307
G1 X128.892 Y128.467 E.01209
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466197
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512394
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558592
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604789
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.347 Y129.382 E.00423
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.355 Y129.445 E-.02403
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.0653
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01704
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13283
G1 X128.205 Y131.025 E-.06778
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z6.98 F42000
G1 Z6.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573196
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601262
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.647064
G1 X131.08 Y134.032 E.03055
; LINE_WIDTH: 0.651144
G3 X130.95 Y132.476 I10.097 J-1.622 E.07745
; LINE_WIDTH: 0.631482
G1 X130.933 Y131.843 E.03036
; WIPE_START
G1 F6116.603
G1 X130.95 Y132.476 E-.24057
G1 X130.993 Y133.347 E-.33146
G1 X131.055 Y133.838 E-.18797
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z6.98 F42000
G1 Z6.58
G1 E.8 F1800
; LINE_WIDTH: 0.472578
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8378.757
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z6.98 F42000
G1 Z6.58
G1 E.8 F1800
; LINE_WIDTH: 0.530454
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549034
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583734
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.615306
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621312
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.59973
G1 X128.57 Y135.932 E.01195
; WIPE_START
G1 F6465.401
G1 X128.562 Y136.195 E-.10005
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.684 Y137.633 E-.12213
; WIPE_END
G1 E-.04 F1800
G1 X128.662 Y130.064 Z6.98 F42000
G1 X128.988 Y127.548 Z6.98
G1 Z6.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.591595
G1 F1200
G1 X129.363 Y127.484 E.01704
; LINE_WIDTH: 0.58845
G1 X129.619 Y127.538 E.01162
; LINE_WIDTH: 0.559586
G1 X129.875 Y127.591 E.01101
; LINE_WIDTH: 0.529996
G1 X129.969 Y127.643 E.00426
; LINE_WIDTH: 0.499679
G1 X130.063 Y127.695 E.004
; CHANGE_LAYER
; Z_HEIGHT: 6.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7881.627
G1 X129.969 Y127.643 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 34/50
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
G17
G3 Z6.98 I-.505 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z6.98
G1 Z6.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554835
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512866
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481433
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.40799
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379905
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351819
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341418
G1 X131.063 Y131.441 E.02195
; LINE_WIDTH: 0.388937
G1 X131.042 Y131.508 E.00199
; LINE_WIDTH: 0.436456
G1 X131.02 Y131.575 E.00226
; LINE_WIDTH: 0.483974
G1 X130.998 Y131.642 E.00253
; LINE_WIDTH: 0.531493
G1 X130.977 Y131.709 E.0028
; LINE_WIDTH: 0.579012
G1 X130.955 Y131.776 E.00308
; LINE_WIDTH: 0.62653
G1 X130.933 Y131.843 E.00335
G1 X130.905 Y131.777 E.00344
; LINE_WIDTH: 0.579012
G1 X130.877 Y131.71 E.00316
; LINE_WIDTH: 0.531493
G1 X130.849 Y131.643 E.00288
; LINE_WIDTH: 0.483974
G1 X130.821 Y131.577 E.0026
; LINE_WIDTH: 0.436456
G1 X130.793 Y131.51 E.00232
; LINE_WIDTH: 0.388937
G1 X130.765 Y131.443 E.00204
; LINE_WIDTH: 0.341418
G1 X130.77 Y130.523 E.02238
; LINE_WIDTH: 0.350643
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382246
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424407
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z7.18 F42000
G1 Z6.78
G1 E.8 F1800
; LINE_WIDTH: 0.360679
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01594
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.354 Y129.442 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565558
G1 F1200
G1 X128.355 Y129.445 E.00013
; LINE_WIDTH: 0.53084
G1 X128.387 Y129.508 E.00278
; LINE_WIDTH: 0.493893
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.63 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.524 Y129.856 I.134 J.299 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
M73 P90 R2
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429982
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.47497
G1 X128.219 Y131.354 E.00293
; LINE_WIDTH: 0.519958
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564946
G1 X128.246 Y131.518 E.00354
; LINE_WIDTH: 0.609934
G1 X128.259 Y131.6 E.00384
; LINE_WIDTH: 0.632419
G1 X128.535 Y131.815 E.01678
G1 X128.6 Y132.462 E.03122
G1 X128.444 Y132.628 E.01096
G1 X128.447 Y132.743 E.00552
G1 X128.447 Y132.763 E.00096
; LINE_WIDTH: 0.588934
G1 X128.448 Y132.779 E.00067
G1 X128.45 Y132.898 E.00534
; LINE_WIDTH: 0.545448
G1 X128.453 Y133.033 E.00553
; LINE_WIDTH: 0.501962
G1 X128.456 Y133.168 E.00505
; LINE_WIDTH: 0.458476
G1 X128.456 Y133.188 E.00068
G1 X128.458 Y133.303 E.0039
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00981
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426109
G1 X128.872 Y134.125 E.01342
; LINE_WIDTH: 0.459605
G1 X128.882 Y134.39 E.00902
; LINE_WIDTH: 0.493101
G2 X128.951 Y135.185 I5.352 J-.067 E.02928
; LINE_WIDTH: 0.480897
G1 X128.991 Y135.435 E.00903
; LINE_WIDTH: 0.450448
G1 X129.032 Y135.684 E.0084
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559986
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517857
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.44919
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493004
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536818
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580632
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523624
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.43774
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475702
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515302
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472088
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428874
G1 X123.799 Y129.422 E.00841
; LINE_WIDTH: 0.393108
G1 X123.781 Y129.155 E.00763
; LINE_WIDTH: 0.390678
G1 X123.797 Y128.641 E.01457
; LINE_WIDTH: 0.43776
G1 X123.82 Y128.479 E.00528
; LINE_WIDTH: 0.484841
G1 X123.844 Y128.316 E.00591
; LINE_WIDTH: 0.531923
G1 X123.867 Y128.154 E.00654
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00717
G1 X123.886 Y125.055 E.12827
; LINE_WIDTH: 0.573607
G1 X123.908 Y120.483 E.19772
; LINE_WIDTH: 0.545655
G1 X123.936 Y117.89 E.10622
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.545655
G1 X124.41 Y120.484 E.10613
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.19762
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1657.095 J-4.3 E.13328
G2 X124.291 Y128.317 I.172 J.261 E.01134
G1 X124.291 Y128.317 E.00003
; LINE_WIDTH: 0.531923
G1 X124.257 Y128.401 E.00359
G1 X124.236 Y128.45 E.00214
; LINE_WIDTH: 0.484841
G1 X124.209 Y128.518 E.00262
G1 X124.182 Y128.583 E.00255
; LINE_WIDTH: 0.43776
G1 X124.128 Y128.716 E.00462
; LINE_WIDTH: 0.390678
G1 X124.095 Y129.141 E.01207
; LINE_WIDTH: 0.385343
G1 X124.134 Y129.349 E.00588
; LINE_WIDTH: 0.412721
G1 X124.172 Y129.556 E.00636
; LINE_WIDTH: 0.462274
G1 X124.233 Y129.689 E.00499
; LINE_WIDTH: 0.511827
G1 X124.294 Y129.821 E.00558
; LINE_WIDTH: 0.561379
G1 X124.355 Y129.954 E.00617
; LINE_WIDTH: 0.563724
G1 X124.536 Y130.095 E.00974
G2 X124.363 Y130.323 I.165 J.305 E.01253
; LINE_WIDTH: 0.529133
G1 X124.296 Y130.462 E.00612
; LINE_WIDTH: 0.494542
G1 X124.229 Y130.601 E.00568
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.43774
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523624
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560152
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.51886
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477567
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441471
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464393
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.51219
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559986
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553522
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518059
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482596
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01299
G1 X128.295 Y135.543 E.00908
; LINE_WIDTH: 0.450448
G1 X128.376 Y135.341 E.00721
; LINE_WIDTH: 0.480897
G1 X128.457 Y135.139 E.00775
; LINE_WIDTH: 0.493101
G1 X128.443 Y134.696 E.01629
G1 X128.34 Y134.498 E.00818
; LINE_WIDTH: 0.459605
G1 X128.237 Y134.3 E.00757
; LINE_WIDTH: 0.426109
G1 X127.941 Y133.997 E.01323
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00812
G1 X127.852 Y133.758 E.00579
G1 X128.089 Y133.388 E.0135
G1 X128.115 Y133.19 E.00614
; LINE_WIDTH: 0.390177
G1 X128.141 Y132.992 E.00566
; LINE_WIDTH: 0.397343
G1 X128.162 Y132.943 E.00152
; LINE_WIDTH: 0.434331
G1 X128.183 Y132.895 E.00167
; LINE_WIDTH: 0.483853
G1 X128.19 Y132.801 E.00341
; LINE_WIDTH: 0.533375
G1 X128.198 Y132.706 E.00379
; LINE_WIDTH: 0.582897
G1 X128.205 Y132.612 E.00417
; LINE_WIDTH: 0.632419
G1 X128.213 Y132.517 E.00456
G1 X128.004 Y132.136 E.02089
G1 X127.637 Y131.822 E.02319
; LINE_WIDTH: 0.609934
G2 X127.758 Y131.646 I-.145 J-.23 E.01016
; LINE_WIDTH: 0.582102
G1 X127.797 Y131.552 E.00449
; LINE_WIDTH: 0.55427
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00448
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576627
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538793
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500958
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460479
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I127.828 J-2.276 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.461 Y133.496 E.00057
G1 X130.488 Y133.47 E.00115
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.724 I-41.035 J1.365 E.0469
G1 X130.408 Y131.715 E.0005
G1 X130.371 Y131.693 E.00134
G1 X130.229 Y131.611 E.00503
G1 X130.379 Y131.492 E.00586
G1 X130.406 Y131.471 E.00106
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466197
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512394
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558591
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604788
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565558
G1 X128.347 Y129.383 E.00424
M204 S6000
; WIPE_START
G1 F6888.133
G1 X128.355 Y129.445 E-.02394
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.63 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.01903
G1 X128.665 Y129.736 E-.06524
G1 X128.524 Y129.856 E-.07006
G1 X128.491 Y129.898 E-.02049
G1 X128.463 Y129.933 E-.01704
G1 X128.508 Y130.485 E-.21062
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.025 E-.06794
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z7.18 F42000
G1 Z6.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573199
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601268
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630502
G1 X130.933 Y131.843 E.02976
; WIPE_START
G1 F6126.805
G1 X130.951 Y132.465 E-.23618
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.84 E-.19162
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z7.18 F42000
G1 Z6.78
G1 E.8 F1800
; LINE_WIDTH: 0.472564
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8379.03
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z7.18 F42000
G1 Z6.78
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.016
; LINE_WIDTH: 0.54903
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581114
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583738
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600722
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623078
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.61531
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599734
G1 X128.57 Y135.932 E.01195
; WIPE_START
G1 F6465.355
G1 X128.562 Y136.195 E-.10005
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.684 Y137.633 E-.12213
; WIPE_END
G1 E-.04 F1800
G1 X128.661 Y130.064 Z7.18 F42000
G1 X128.986 Y127.549 Z7.18
G1 Z6.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586816
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559044
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530409
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500911
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 6.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.417
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 35/50
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
G17
G3 Z7.18 I-.503 J-1.108 P1  F42000
G1 X128.153 Y128.465 Z7.18
G1 Z6.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638768
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01857
G3 X128.15 Y127.739 I.754 J.108 E.02088
; LINE_WIDTH: 0.596861
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554954
G1 X128.374 Y127.391 E.00864
; LINE_WIDTH: 0.513047
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481523
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407986
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379903
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.35182
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341422
G1 X131.063 Y131.442 E.02196
; LINE_WIDTH: 0.38894
G1 X131.042 Y131.509 E.00199
; LINE_WIDTH: 0.436458
G1 X131.02 Y131.576 E.00226
; LINE_WIDTH: 0.483976
G1 X130.998 Y131.643 E.00253
; LINE_WIDTH: 0.531494
G1 X130.977 Y131.71 E.0028
; LINE_WIDTH: 0.579012
G1 X130.955 Y131.777 E.00308
; LINE_WIDTH: 0.62653
G1 X130.933 Y131.844 E.00335
G1 X130.905 Y131.777 E.00344
; LINE_WIDTH: 0.579012
G1 X130.877 Y131.71 E.00316
; LINE_WIDTH: 0.531494
G1 X130.849 Y131.643 E.00288
; LINE_WIDTH: 0.483976
G1 X130.821 Y131.577 E.0026
; LINE_WIDTH: 0.436458
G1 X130.793 Y131.51 E.00232
; LINE_WIDTH: 0.38894
G1 X130.765 Y131.443 E.00204
; LINE_WIDTH: 0.341422
G1 X130.77 Y130.523 E.02239
; LINE_WIDTH: 0.350644
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497192
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544384
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591576
G1 X128.773 Y128.046 E.00689
; LINE_WIDTH: 0.638768
G1 X128.621 Y128.072 E.00748
G1 X128.199 Y128.426 E.02676
; WIPE_START
G1 F6041.809
G1 X127.975 Y128.126 E-.14219
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11894
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z7.38 F42000
G1 Z6.98
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00062
G1 X127.755 Y129.822 E.01595
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.443 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565856
G1 F1200
G1 X128.355 Y129.445 E.0001
; LINE_WIDTH: 0.530838
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00529
G2 X128.525 Y129.855 I.134 J.299 E.00572
G1 X128.491 Y129.898 E.00168
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391234
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.430125
G1 X128.205 Y131.273 E.00263
; LINE_WIDTH: 0.475256
G1 X128.219 Y131.355 E.00293
; LINE_WIDTH: 0.520387
G1 X128.232 Y131.437 E.00324
; LINE_WIDTH: 0.565518
G1 X128.246 Y131.519 E.00355
; LINE_WIDTH: 0.610649
G1 X128.259 Y131.601 E.00385
; LINE_WIDTH: 0.631986
G1 X128.535 Y131.815 E.01675
G1 X128.6 Y132.462 E.03121
G1 X128.445 Y132.629 E.01094
; LINE_WIDTH: 0.631014
G1 X128.447 Y132.744 E.0055
G1 X128.448 Y132.764 E.00098
; LINE_WIDTH: 0.58789
G1 X128.448 Y132.778 E.00063
G1 X128.451 Y132.899 E.00537
; LINE_WIDTH: 0.544766
G1 X128.453 Y133.034 E.00553
; LINE_WIDTH: 0.501642
G1 X128.456 Y133.17 E.00505
; LINE_WIDTH: 0.458518
G1 X128.456 Y133.19 E.00068
G1 X128.459 Y133.305 E.0039
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00978
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.426533
G1 X128.871 Y134.12 E.01326
; LINE_WIDTH: 0.460081
G1 X128.881 Y134.385 E.00902
; LINE_WIDTH: 0.493629
G2 X128.951 Y135.188 I5.409 J-.069 E.02964
; LINE_WIDTH: 0.481322
G1 X128.991 Y135.436 E.00898
; LINE_WIDTH: 0.450661
G1 X129.032 Y135.684 E.00835
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445319
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489793
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524888
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.894 Y133.906 I-.966 J-.177 E.0169
; LINE_WIDTH: 0.513484
G1 X123.869 Y133.707 E.00767
; LINE_WIDTH: 0.466985
G1 X123.845 Y133.509 E.00691
; LINE_WIDTH: 0.420485
G1 X123.833 Y133.003 E.01555
; LINE_WIDTH: 0.449178
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.492979
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.53678
G1 X123.893 Y132.382 E.00837
; LINE_WIDTH: 0.58058
G2 X123.905 Y132.007 I-1.256 J-.227 E.01648
; LINE_WIDTH: 0.566563
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523622
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515299
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.47208
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428861
G1 X123.799 Y129.42 E.0085
; LINE_WIDTH: 0.393039
G1 X123.781 Y129.15 E.00771
; LINE_WIDTH: 0.389624
G1 X123.796 Y128.65 E.01414
; LINE_WIDTH: 0.436969
G1 X123.82 Y128.485 E.00534
; LINE_WIDTH: 0.484314
G1 X123.844 Y128.321 E.00598
; LINE_WIDTH: 0.531659
G1 X123.867 Y128.156 E.00662
; LINE_WIDTH: 0.579004
G1 X123.891 Y127.991 E.00727
G1 X123.886 Y125.054 E.1283
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563165
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563165
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579004
G2 X124.427 Y128.105 I1653.44 J-4.288 E.1333
G2 X124.291 Y128.316 I.169 J.258 E.01131
G1 X124.29 Y128.319 E.00015
; LINE_WIDTH: 0.531659
G1 X124.258 Y128.398 E.00339
G1 X124.236 Y128.454 E.00242
; LINE_WIDTH: 0.484314
G1 X124.212 Y128.513 E.00229
G1 X124.181 Y128.589 E.00294
; LINE_WIDTH: 0.436969
G1 X124.126 Y128.724 E.00468
; LINE_WIDTH: 0.389624
G1 X124.095 Y129.136 E.01166
; LINE_WIDTH: 0.385673
G1 X124.134 Y129.347 E.00601
; LINE_WIDTH: 0.413513
G1 X124.173 Y129.559 E.0065
; LINE_WIDTH: 0.463182
G1 X124.234 Y129.691 E.00499
; LINE_WIDTH: 0.512851
G1 X124.295 Y129.824 E.00558
; LINE_WIDTH: 0.562519
G1 X124.357 Y129.956 E.00617
; LINE_WIDTH: 0.563812
G1 X124.536 Y130.095 E.00964
G2 X124.359 Y130.326 I.161 J.308 E.01277
; LINE_WIDTH: 0.529192
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494571
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431525
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523622
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566563
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601441
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.257 J.427 E.01605
; LINE_WIDTH: 0.560148
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518854
G1 X124.265 Y132.635 E.00565
; LINE_WIDTH: 0.47756
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441469
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.418586
G1 X124.218 Y133.459 E.01273
; LINE_WIDTH: 0.465719
G1 X124.266 Y133.613 E.00555
; LINE_WIDTH: 0.512851
G1 X124.314 Y133.767 E.00617
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00679
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445319
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.779 E.01301
G1 X128.299 Y135.533 E.00937
; LINE_WIDTH: 0.450661
G1 X128.378 Y135.338 E.007
; LINE_WIDTH: 0.481322
G1 X128.457 Y135.143 E.00752
; LINE_WIDTH: 0.493629
G1 X128.442 Y134.69 E.01663
G1 X128.338 Y134.493 E.00817
; LINE_WIDTH: 0.460081
G1 X128.235 Y134.296 E.00757
; LINE_WIDTH: 0.426533
G1 X127.939 Y133.996 E.01317
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00805
G1 X127.851 Y133.76 E.00572
G1 X128.087 Y133.392 E.01344
G1 X128.114 Y133.192 E.00619
; LINE_WIDTH: 0.390463
G1 X128.14 Y132.992 E.00571
; LINE_WIDTH: 0.398114
G1 X128.161 Y132.94 E.00162
; LINE_WIDTH: 0.435301
G1 X128.183 Y132.889 E.00179
; LINE_WIDTH: 0.484473
G1 X128.19 Y132.794 E.0034
; LINE_WIDTH: 0.533644
G1 X128.197 Y132.7 E.00377
; LINE_WIDTH: 0.582815
G1 X128.204 Y132.606 E.00415
; LINE_WIDTH: 0.631986
G1 X128.211 Y132.512 E.00453
G1 X128.004 Y132.135 E.02062
G1 X127.637 Y131.823 E.02315
; LINE_WIDTH: 0.610649
G2 X127.759 Y131.647 I-.144 J-.229 E.01017
; LINE_WIDTH: 0.582459
G1 X127.797 Y131.552 E.0045
; LINE_WIDTH: 0.554268
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465711
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421432
G1 X127.852 Y131.055 E.00007
G1 X127.854 Y131.037 E.00057
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.615805
G1 X127.784 Y128.894 E.01628
G1 X127.763 Y128.855 E.00206
; LINE_WIDTH: 0.575493
G1 X127.742 Y128.816 E.00192
; LINE_WIDTH: 0.53518
G1 X127.721 Y128.778 E.00177
; LINE_WIDTH: 0.494867
G1 X127.66 Y128.617 E.00632
; LINE_WIDTH: 0.457433
G1 X127.599 Y128.457 E.0058
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00973
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I127.824 J-2.276 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.724 I-41.021 J1.365 E.0469
G1 X130.408 Y131.715 E.0005
G1 X130.371 Y131.694 E.00133
G1 X130.229 Y131.611 E.00503
G1 X130.379 Y131.492 E.00587
G1 X130.406 Y131.471 E.00105
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.464661
G1 X128.626 Y128.706 E.00464
; LINE_WIDTH: 0.509323
G1 X128.552 Y128.788 E.00419
G1 X128.535 Y128.806 E.00095
; LINE_WIDTH: 0.553985
G1 X128.498 Y128.847 E.00233
G1 X128.445 Y128.906 E.00329
; LINE_WIDTH: 0.598646
G1 X128.443 Y128.907 E.00009
G1 X128.354 Y129.006 E.00603
; LINE_WIDTH: 0.600873
G2 X128.336 Y129.285 I.301 J.159 E.0131
; LINE_WIDTH: 0.565856
G1 X128.347 Y129.383 E.00423
M204 S6000
; WIPE_START
G1 F6884.214
G1 X128.355 Y129.445 E-.02372
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.0189
G1 X128.665 Y129.736 E-.06538
G1 X128.525 Y129.855 E-.06982
G1 X128.491 Y129.898 E-.02076
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13269
G1 X128.205 Y131.026 E-.06822
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z7.38 F42000
G1 Z6.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630502
G1 X130.933 Y131.844 E.02975
; WIPE_START
G1 F6126.805
G1 X130.951 Y132.465 E-.23615
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.84 E-.19166
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.793 Z7.38 F42000
G1 Z6.98
G1 E.8 F1800
; LINE_WIDTH: 0.47244
G1 F1200
G1 X128.46 Y133.954 E.00783
; WIPE_START
G1 F8381.449
G1 X128.305 Y133.793 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.931 Z7.38 F42000
G1 Z6.98
G1 E.8 F1800
; LINE_WIDTH: 0.599742
G1 F1200
G1 X128.562 Y136.195 E.01202
; LINE_WIDTH: 0.621314
G1 X128.452 Y136.634 E.02128
; LINE_WIDTH: 0.625284
G1 X128.261 Y137.041 E.02137
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.61531
G1 X127.431 Y137.816 E.02952
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.03111
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600724
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583736
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581116
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.54903
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530458
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.04
G1 X124.459 Y136.736 E-.15299
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21708
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z7.38 F42000
G1 X128.986 Y127.549 Z7.38
G1 Z6.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590113
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586815
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500907
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 7.18
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.485
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 36/50
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
G17
G3 Z7.38 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z7.38
G1 Z7.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00864
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.683 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.437129
G1 X130.943 Y128.766 E.00934
; LINE_WIDTH: 0.41474
G1 X130.973 Y129.216 E.01368
; LINE_WIDTH: 0.383287
G1 X131.003 Y129.667 E.01252
; LINE_WIDTH: 0.351834
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528602
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.57755
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587428
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548358
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509288
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470217
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424415
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378613
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350612
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382243
G3 X130.657 Y129.309 I2.711 J-.568 E.01981
; LINE_WIDTH: 0.399617
G1 X130.604 Y129.023 E.00844
; LINE_WIDTH: 0.428487
G1 X130.552 Y128.738 E.00912
; LINE_WIDTH: 0.449999
G1 X130.248 Y128.308 E.01745
G1 X129.775 Y128.033 E.01815
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
M73 P91 R2
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.1425
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z7.58 F42000
G1 Z7.18
G1 E.8 F1800
; LINE_WIDTH: 0.362034
G1 F1200
G1 X128.14 Y130.329 E.01347
G1 X128.114 Y130.322 E.0007
G1 X127.755 Y129.823 E.016
G1 X127.998 Y129.547 E.00955
G1 X128.112 Y129.758 E.00622
G1 X128.355 Y129.443 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565558
G1 F1200
G1 X128.355 Y129.445 E.0001
; LINE_WIDTH: 0.530838
G1 X128.387 Y129.508 E.00278
; LINE_WIDTH: 0.493892
G1 X128.418 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00231
G1 X128.45 Y129.632 E.00005
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.639 E.00051
G1 X128.51 Y129.661 E.00155
G1 X128.665 Y129.736 E.00527
G2 X128.525 Y129.856 I.133 J.299 E.00574
G1 X128.491 Y129.898 E.00167
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01702
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391068
G1 X128.192 Y131.19 E.00978
; LINE_WIDTH: 0.428768
G1 X128.206 Y131.272 E.0026
; LINE_WIDTH: 0.473522
G1 X128.219 Y131.354 E.0029
; LINE_WIDTH: 0.518277
G1 X128.232 Y131.435 E.0032
; LINE_WIDTH: 0.563031
G1 X128.246 Y131.517 E.0035
; LINE_WIDTH: 0.607785
G1 X128.259 Y131.598 E.00381
; LINE_WIDTH: 0.632815
G1 X128.535 Y131.815 E.01686
G1 X128.6 Y132.462 E.03123
G1 X128.447 Y132.629 E.01093
; LINE_WIDTH: 0.627826
G1 X128.449 Y132.744 E.00546
G1 X128.449 Y132.765 E.00099
; LINE_WIDTH: 0.585416
G1 X128.449 Y132.778 E.00058
G1 X128.451 Y132.9 E.0054
; LINE_WIDTH: 0.543005
G1 X128.454 Y133.035 E.00552
; LINE_WIDTH: 0.500594
G1 X128.456 Y133.171 E.00505
; LINE_WIDTH: 0.458183
G1 X128.457 Y133.191 E.00068
G1 X128.459 Y133.306 E.0039
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00974
G1 X128.832 Y133.697 E.00725
; LINE_WIDTH: 0.42694
G1 X128.87 Y134.114 E.01311
; LINE_WIDTH: 0.460529
G1 X128.88 Y134.38 E.00903
; LINE_WIDTH: 0.494117
G2 X128.951 Y135.191 I5.465 J-.07 E.02997
; LINE_WIDTH: 0.481759
G1 X128.991 Y135.438 E.00894
; LINE_WIDTH: 0.450879
G1 X129.032 Y135.684 E.00831
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454698
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.895 Y133.909 I-.954 J-.176 E.01674
; LINE_WIDTH: 0.514158
G1 X123.87 Y133.715 E.00753
; LINE_WIDTH: 0.468331
G1 X123.846 Y133.52 E.0068
; LINE_WIDTH: 0.422504
G1 X123.833 Y133.003 E.01599
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.866 Y130.008 I-.541 J-.147 E.0126
; LINE_WIDTH: 0.521212
G1 X123.846 Y129.881 E.00501
; LINE_WIDTH: 0.483907
G1 X123.826 Y129.754 E.00462
; LINE_WIDTH: 0.446602
G1 X123.804 Y129.477 E.00914
; LINE_WIDTH: 0.403036
G1 X123.782 Y129.2 E.00816
; LINE_WIDTH: 0.38864
G1 X123.796 Y128.658 E.01527
; LINE_WIDTH: 0.436231
G1 X123.82 Y128.491 E.0054
; LINE_WIDTH: 0.483822
G1 X123.843 Y128.324 E.00605
; LINE_WIDTH: 0.531413
G1 X123.867 Y128.158 E.0067
; LINE_WIDTH: 0.579003
G1 X123.891 Y127.991 E.00736
G1 X123.886 Y125.054 E.12828
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579003
G2 X124.427 Y128.104 I1659.601 J-4.31 E.1333
G1 X124.352 Y128.195 E.00515
; LINE_WIDTH: 0.553531
G1 X124.276 Y128.285 E.0049
; LINE_WIDTH: 0.528059
G1 X124.226 Y128.434 E.00621
; LINE_WIDTH: 0.481586
G1 X124.175 Y128.583 E.00561
; LINE_WIDTH: 0.435113
G1 X124.125 Y128.731 E.00502
; LINE_WIDTH: 0.38864
G1 X124.095 Y129.131 E.01129
; LINE_WIDTH: 0.385977
G1 X124.135 Y129.346 E.00613
; LINE_WIDTH: 0.414253
G1 X124.174 Y129.562 E.00663
; LINE_WIDTH: 0.46403
G1 X124.235 Y129.694 E.00499
; LINE_WIDTH: 0.513807
G1 X124.297 Y129.826 E.00558
; LINE_WIDTH: 0.563584
G1 X124.358 Y129.958 E.00617
; LINE_WIDTH: 0.563892
G1 X124.536 Y130.095 E.00955
G2 X124.359 Y130.326 I.161 J.307 E.01277
; LINE_WIDTH: 0.529245
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494598
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477571
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.42075
G1 X124.221 Y133.472 E.0132
; LINE_WIDTH: 0.467162
G1 X124.268 Y133.621 E.00542
; LINE_WIDTH: 0.513573
G1 X124.315 Y133.771 E.00601
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00661
; LINE_WIDTH: 0.588986
M73 P91 R1
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.805 Y137.552 E.01521
G1 X127.282 Y137.365 E.01573
G1 X127.673 Y137.046 E.01549
G1 X127.94 Y136.668 E.01424
G1 X128.099 Y136.202 E.01513
G1 X128.118 Y135.778 E.01303
G1 X128.303 Y135.523 E.00968
; LINE_WIDTH: 0.450879
G1 X128.38 Y135.335 E.00677
; LINE_WIDTH: 0.481759
G1 X128.456 Y135.146 E.00728
; LINE_WIDTH: 0.494062
G1 X128.44 Y134.68 E.01713
G1 X128.336 Y134.486 E.00808
; LINE_WIDTH: 0.460501
G1 X128.233 Y134.293 E.00748
; LINE_WIDTH: 0.42694
G1 X127.937 Y133.995 E.01312
; LINE_WIDTH: 0.419999
G1 X127.706 Y133.876 E.00799
G1 X127.85 Y133.761 E.00566
G1 X128.086 Y133.395 E.01339
G1 X128.112 Y133.193 E.00624
; LINE_WIDTH: 0.390724
G1 X128.139 Y132.992 E.00576
; LINE_WIDTH: 0.399011
G1 X128.161 Y132.937 E.00172
; LINE_WIDTH: 0.436574
G1 X128.183 Y132.882 E.0019
; LINE_WIDTH: 0.485635
G1 X128.19 Y132.788 E.00339
; LINE_WIDTH: 0.534695
G1 X128.196 Y132.695 E.00377
; LINE_WIDTH: 0.583755
G1 X128.203 Y132.601 E.00414
; LINE_WIDTH: 0.632815
G1 X128.209 Y132.507 E.00452
G1 X128.004 Y132.138 E.02031
G1 X127.636 Y131.823 E.02329
; LINE_WIDTH: 0.609666
G2 X127.757 Y131.648 I-.14 J-.226 E.01006
; LINE_WIDTH: 0.582483
G1 X127.794 Y131.556 E.00438
; LINE_WIDTH: 0.555299
G1 X127.808 Y131.431 E.00525
G1 X127.813 Y131.391 E.00168
; LINE_WIDTH: 0.510736
G1 X127.817 Y131.356 E.00136
G1 X127.832 Y131.226 E.00497
; LINE_WIDTH: 0.466173
G1 X127.851 Y131.061 E.00573
; LINE_WIDTH: 0.42161
G1 X127.854 Y131.033 E.00086
G1 X127.87 Y130.896 E.00426
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01396
G1 X127.558 Y130.121 E.01232
G1 X127.316 Y129.928 E.00952
G1 X127.275 Y129.825 E.0034
G1 X127.452 Y129.648 E.0077
; LINE_WIDTH: 0.467423
G1 X127.526 Y129.546 E.00436
; LINE_WIDTH: 0.514846
G1 X127.601 Y129.445 E.00485
; LINE_WIDTH: 0.56227
G1 X127.675 Y129.343 E.00534
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00582
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.208 Y127.972 E.00812
G1 X131.31 Y128.475 E.01579
G2 X131.492 Y133.388 I128.029 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.486 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.376 Y131.695 E.00113
G1 X130.229 Y131.61 E.00523
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.00171
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.212 Y128.897 E.0137
G1 X129.993 Y128.598 E.01136
G1 X129.656 Y128.4 E.01201
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466197
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512394
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558591
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604788
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565558
G1 X128.348 Y129.383 E.00427
M204 S6000
; WIPE_START
G1 F6888.14
G1 X128.355 Y129.445 E-.02371
G1 X128.387 Y129.508 E-.02658
G1 X128.418 Y129.57 E-.02658
G1 X128.449 Y129.631 E-.02597
G1 X128.45 Y129.632 E-.00061
G1 X128.465 Y129.639 E-.00635
G1 X128.51 Y129.661 E-.01912
G1 X128.665 Y129.736 E-.06519
G1 X128.525 Y129.856 E-.06998
G1 X128.491 Y129.898 E-.02063
G1 X128.463 Y129.933 E-.0171
G1 X128.508 Y130.485 E-.21047
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.026 E-.06819
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z7.58 F42000
G1 Z7.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5732
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601268
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.2372
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X128.46 Y133.954 Z7.58 F42000
G1 Z7.18
G1 E.8 F1800
; LINE_WIDTH: 0.47229
G1 F1200
G1 X128.305 Y133.793 E.00782
; WIPE_START
G1 F8384.377
G1 X128.46 Y133.954 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.571 Y135.929 Z7.58 F42000
G1 Z7.18
G1 E.8 F1800
; LINE_WIDTH: 0.585402
G1 F1200
G1 X128.534 Y136.351 E.01872
; LINE_WIDTH: 0.60165
G1 X128.322 Y136.938 E.02843
; LINE_WIDTH: 0.620282
G1 X127.97 Y137.42 E.02807
G1 X127.431 Y137.816 E.03148
; LINE_WIDTH: 0.62308
G1 X126.81 Y138.032 E.0311
G1 X126.22 Y138.051 E.0279
; LINE_WIDTH: 0.600724
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583736
G1 X125.111 Y137.607 E.02768
; LINE_WIDTH: 0.581118
G1 X124.716 Y137.195 E.02505
; LINE_WIDTH: 0.54903
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530456
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.07
G1 X124.459 Y136.736 E-.15298
G1 X124.716 Y137.195 E-.19995
G1 X125.111 Y137.607 E-.21709
G1 X125.547 Y137.853 E-.18998
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z7.58 F42000
G1 X128.986 Y127.549 Z7.58
G1 Z7.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586815
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530401
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500894
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 7.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.717
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 37/50
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
G17
G3 Z7.58 I-.565 J-1.078 P1  F42000
G1 X128.126 Y128.607 Z7.58
G1 Z7.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.449999
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.858 Y128.133 E.01805
G1 X127.905 Y127.995 E.00484
G1 X128.095 Y127.64 E.01337
G1 X128.352 Y127.369 E.01238
G1 X128.758 Y127.119 E.01581
G1 X129.264 Y127 E.01724
G3 X130.031 Y127.163 I-.038 J2.075 E.02619
G1 X130.365 Y127.381 E.01323
G1 X130.609 Y127.647 E.01196
G1 X130.803 Y128.013 E.01374
G3 X130.948 Y128.798 I-3.876 J1.121 E.02654
; LINE_WIDTH: 0.408
G1 X130.975 Y129.232 E.01295
; LINE_WIDTH: 0.379918
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351835
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479653
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.58743
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548363
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509297
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.47023
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424424
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378617
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350662
G1 X130.712 Y130.021 E.01241
; LINE_WIDTH: 0.382343
G1 X130.654 Y129.53 E.01369
G1 X130.659 Y129.336 E.00535
; LINE_WIDTH: 0.408
G1 X130.586 Y128.838 E.01499
; LINE_WIDTH: 0.447538
G1 X130.459 Y128.564 E.00996
; LINE_WIDTH: 0.449999
G1 X130.076 Y128.178 E.01802
G1 X129.6 Y127.987 E.01704
G1 X129.049 Y127.998 E.01826
G1 X128.561 Y128.217 E.01776
G1 X128.171 Y128.567 E.01739
; WIPE_START
G1 F8843.491
G1 X127.858 Y128.133 E-.20315
G1 X127.905 Y127.995 E-.05547
G1 X128.095 Y127.64 E-.15317
G1 X128.352 Y127.369 E-.14186
G1 X128.758 Y127.119 E-.18114
G1 X128.822 Y127.104 E-.02522
; WIPE_END
G1 E-.04 F1800
G1 X128.139 Y129.79 Z7.78 F42000
G1 Z7.38
G1 E.8 F1800
; LINE_WIDTH: 0.364682
G1 F1200
G1 X128.144 Y130.323 E.01399
G1 X127.756 Y129.818 E.0167
G1 X127.998 Y129.55 E.00946
G1 X128.109 Y129.738 E.00571
G1 X128.354 Y129.441 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.53347
G1 F1200
G1 X128.386 Y129.504 E.00281
; LINE_WIDTH: 0.495647
G1 X128.418 Y129.568 E.00265
; LINE_WIDTH: 0.457823
G1 X128.449 Y129.63 E.00232
G1 X128.45 Y129.632 E.00011
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.390995
G1 X128.193 Y131.19 E.00978
; LINE_WIDTH: 0.427928
G1 X128.206 Y131.272 E.00258
; LINE_WIDTH: 0.47233
G1 X128.219 Y131.353 E.00288
; LINE_WIDTH: 0.516731
G1 X128.232 Y131.434 E.00317
; LINE_WIDTH: 0.561133
G1 X128.246 Y131.515 E.00347
; LINE_WIDTH: 0.605534
G1 X128.259 Y131.596 E.00377
; LINE_WIDTH: 0.632961
G1 X128.535 Y131.815 E.01694
G1 X128.6 Y132.462 E.03123
G1 X128.449 Y132.63 E.01089
; LINE_WIDTH: 0.623164
G1 X128.45 Y132.745 E.0054
G1 X128.451 Y132.766 E.001
; LINE_WIDTH: 0.581749
G1 X128.451 Y132.777 E.00051
G1 X128.453 Y132.901 E.00543
; LINE_WIDTH: 0.540333
G1 X128.455 Y133.036 E.00549
; LINE_WIDTH: 0.498917
G1 X128.457 Y133.172 E.00503
; LINE_WIDTH: 0.457501
G1 X128.457 Y133.192 E.00068
G1 X128.459 Y133.307 E.00389
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00971
G1 X128.832 Y133.697 E.00725
G1 X128.853 Y133.913 E.00668
; LINE_WIDTH: 0.464856
G1 X128.887 Y134.469 E.01916
; LINE_WIDTH: 0.502105
G2 X128.982 Y135.392 I4.706 J-.018 E.03475
; LINE_WIDTH: 0.461052
G1 X129.032 Y135.684 E.01012
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454701
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566566
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523624
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515304
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472089
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428874
G1 X123.799 Y129.43 E.00816
; LINE_WIDTH: 0.393661
G1 X123.781 Y129.172 E.00741
; LINE_WIDTH: 0.387502
G1 X123.795 Y128.667 E.01417
; LINE_WIDTH: 0.435378
G1 X123.819 Y128.498 E.00546
; LINE_WIDTH: 0.483253
G1 X123.843 Y128.329 E.00613
; LINE_WIDTH: 0.531128
G1 X123.867 Y128.16 E.00679
; LINE_WIDTH: 0.579003
G1 X123.891 Y127.991 E.00746
G1 X123.886 Y125.055 E.12824
; LINE_WIDTH: 0.573607
G1 X123.907 Y120.543 E.19513
; LINE_WIDTH: 0.546185
G1 X123.936 Y117.89 E.10879
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.546185
G1 X124.41 Y120.544 E.1087
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.19503
; LINE_WIDTH: 0.579003
G2 X124.427 Y128.104 I1667.152 J-4.336 E.13326
G1 X124.352 Y128.194 E.00511
; LINE_WIDTH: 0.553905
G1 X124.277 Y128.283 E.00487
; LINE_WIDTH: 0.528807
G1 X124.226 Y128.436 E.00635
; LINE_WIDTH: 0.481706
G1 X124.175 Y128.588 E.00574
; LINE_WIDTH: 0.434604
G1 X124.124 Y128.74 E.00512
; LINE_WIDTH: 0.387502
G1 X124.097 Y129.16 E.01182
; LINE_WIDTH: 0.387314
G1 X124.136 Y129.364 E.00583
; LINE_WIDTH: 0.415776
G1 X124.176 Y129.568 E.00631
; LINE_WIDTH: 0.465176
G1 X124.236 Y129.698 E.00494
; LINE_WIDTH: 0.514575
G1 X124.297 Y129.828 E.00552
; LINE_WIDTH: 0.563974
G1 X124.358 Y129.958 E.0061
G1 X124.536 Y130.095 E.00954
G2 X124.359 Y130.326 I.161 J.307 E.01276
; LINE_WIDTH: 0.5293
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494625
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523624
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566566
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518863
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477571
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441474
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553525
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518063
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482601
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.778 E.01304
G1 X128.307 Y135.515 E.00995
; LINE_WIDTH: 0.451085
G1 X128.382 Y135.332 E.00657
; LINE_WIDTH: 0.48217
G1 X128.456 Y135.149 E.00707
; LINE_WIDTH: 0.494723
G1 X128.439 Y134.679 E.01732
G1 X128.333 Y134.485 E.00814
; LINE_WIDTH: 0.457361
G1 X128.227 Y134.291 E.00747
; LINE_WIDTH: 0.419999
G1 X127.936 Y133.994 E.01278
G1 X127.706 Y133.876 E.00792
G1 X127.848 Y133.762 E.0056
G1 X128.084 Y133.398 E.01333
G1 X128.111 Y133.195 E.00629
; LINE_WIDTH: 0.391036
G1 X128.138 Y132.992 E.0058
; LINE_WIDTH: 0.396991
G1 X128.16 Y132.936 E.00174
; LINE_WIDTH: 0.431909
G1 X128.181 Y132.88 E.00191
; LINE_WIDTH: 0.47212
G1 X128.186 Y132.804 E.00265
; LINE_WIDTH: 0.51233
G1 X128.192 Y132.729 E.0029
; LINE_WIDTH: 0.552541
G1 X128.197 Y132.653 E.00315
; LINE_WIDTH: 0.592751
G1 X128.202 Y132.578 E.0034
; LINE_WIDTH: 0.632961
G1 X128.208 Y132.502 E.00364
G1 X128.004 Y132.139 E.02002
G1 X127.636 Y131.823 E.02333
; LINE_WIDTH: 0.609536
G2 X127.756 Y131.649 I-.138 J-.224 E.01002
; LINE_WIDTH: 0.582618
G1 X127.793 Y131.558 E.00434
; LINE_WIDTH: 0.555699
G1 X127.807 Y131.435 E.00516
G1 X127.812 Y131.393 E.00178
; LINE_WIDTH: 0.511023
G1 X127.816 Y131.359 E.0013
G1 X127.831 Y131.228 E.00504
; LINE_WIDTH: 0.466346
G1 X127.851 Y131.063 E.00573
; LINE_WIDTH: 0.421669
G1 X127.854 Y131.032 E.00094
G1 X127.87 Y130.898 E.00418
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.014
G1 X127.559 Y130.113 E.01254
G1 X127.283 Y129.906 E.01059
G1 X127.303 Y129.793 E.00354
; LINE_WIDTH: 0.467423
G1 X127.363 Y129.719 E.0033
G1 X127.415 Y129.655 E.00284
; LINE_WIDTH: 0.514846
G1 X127.526 Y129.517 E.00683
; LINE_WIDTH: 0.56227
G1 X127.603 Y129.423 E.00514
G1 X127.638 Y129.379 E.00237
; LINE_WIDTH: 0.609693
G1 X127.64 Y129.376 E.00016
G1 X127.75 Y129.241 E.00804
; LINE_WIDTH: 0.618243
G1 X127.78 Y128.897 E.01619
G1 X127.757 Y128.85 E.00247
; LINE_WIDTH: 0.572828
G1 X127.734 Y128.803 E.00227
; LINE_WIDTH: 0.527412
G1 X127.71 Y128.756 E.00208
; LINE_WIDTH: 0.481996
G1 X127.654 Y128.606 E.00573
; LINE_WIDTH: 0.450998
G1 X127.598 Y128.456 E.00533
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00969
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.616 Y127.06 E.01718
G1 X130.976 Y127.477 E.01693
G1 X131.195 Y127.928 E.01543
G1 X131.31 Y128.475 E.01717
G2 X131.492 Y133.388 I128.029 J-2.284 E.15108
G2 X131.672 Y134.53 I9.527 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.493 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00155
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.00168
G1 X130.093 Y129.525 E.00542
G2 X130.237 Y129.414 I-.091 J-.268 E.00569
G1 X130.282 Y129.361 E.00215
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01295
G1 X129.966 Y128.578 E.01312
G1 X129.654 Y128.399 E.01103
G1 X129.275 Y128.354 E.01176
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.46151
G1 X128.631 Y128.7 E.00435
; LINE_WIDTH: 0.50302
G1 X128.563 Y128.773 E.00373
G1 X128.544 Y128.794 E.00105
; LINE_WIDTH: 0.544531
G1 X128.514 Y128.827 E.00184
G1 X128.458 Y128.888 E.00338
; LINE_WIDTH: 0.586041
G1 X128.371 Y128.981 E.00565
; LINE_WIDTH: 0.60188
G2 X128.335 Y129.284 I.271 J.186 E.01444
; LINE_WIDTH: 0.567675
G1 X128.346 Y129.382 E.00421
M204 S6000
; WIPE_START
G1 F6860.344
G1 X128.386 Y129.504 E-.04878
G1 X128.418 Y129.568 E-.02732
G1 X128.449 Y129.63 E-.02612
G1 X128.45 Y129.632 E-.00119
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01897
G1 X128.665 Y129.736 E-.0653
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01704
G1 X128.508 Y130.485 E-.21058
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.026 E-.06835
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z7.78 F42000
G1 Z7.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573201
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646518
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.33221
G1 X131.044 Y133.837 E-.19058
; WIPE_END
G1 E-.04 F1800
G1 X128.307 Y133.782 Z7.78 F42000
G1 Z7.38
G1 E.8 F1800
; LINE_WIDTH: 0.456726
G1 F1200
G1 X128.457 Y133.95 E.00759
; WIPE_START
G1 F8699.728
G1 X128.307 Y133.782 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z7.78 F42000
G1 Z7.38
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.54903
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581118
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583734
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600726
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.61531
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.62131
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599756
G1 X128.571 Y135.927 E.01217
; WIPE_START
G1 F6465.099
G1 X128.562 Y136.195 E-.10194
G1 X128.452 Y136.634 E-.17157
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.688 Y137.631 E-.12025
; WIPE_END
G1 E-.04 F1800
G1 X128.432 Y130.034 Z7.78 F42000
G1 X128.663 Y127.683 Z7.78
G1 Z7.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541648
G1 F1200
G1 X128.978 Y127.537 E.01412
; LINE_WIDTH: 0.576836
G1 X129.169 Y127.516 E.00834
; LINE_WIDTH: 0.594878
G1 X129.359 Y127.494 E.00862
G1 X129.752 Y127.547 E.01785
; LINE_WIDTH: 0.53906
G1 X129.912 Y127.636 E.00737
; LINE_WIDTH: 0.494543
G1 X130.071 Y127.725 E.00671
; LINE_WIDTH: 0.450027
G1 X130.23 Y127.813 E.00605
; LINE_WIDTH: 0.415272
G1 X130.271 Y127.851 E.00169
; CHANGE_LAYER
; Z_HEIGHT: 7.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9668.271
G1 X130.23 Y127.813 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 38/50
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
G17
G3 Z7.78 I-.369 J-1.16 P1  F42000
G1 X128.13 Y128.481 Z7.78
G1 Z7.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
M73 P92 R1
G3 X130.616 Y127.656 I-.546 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438163
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.40799
G1 X130.975 Y129.232 E.01295
; LINE_WIDTH: 0.379912
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479653
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587429
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548361
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509294
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470226
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424421
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378616
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350619
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382258
G3 X130.657 Y129.311 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397357
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z7.98 F42000
G1 Z7.58
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.444 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00007
; LINE_WIDTH: 0.530838
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.63 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.299 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429874
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474755
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519636
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564517
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609398
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.633098
G1 X128.535 Y131.815 E.01681
G1 X128.6 Y132.462 E.03124
G1 X128.45 Y132.631 E.01087
; LINE_WIDTH: 0.61951
G1 X128.452 Y132.745 E.00536
G1 X128.452 Y132.766 E.00101
; LINE_WIDTH: 0.578903
G1 X128.452 Y132.777 E.00045
G1 X128.454 Y132.902 E.00547
; LINE_WIDTH: 0.538295
G1 X128.456 Y133.037 E.00547
; LINE_WIDTH: 0.497687
G1 X128.457 Y133.173 E.00502
; LINE_WIDTH: 0.457079
G1 X128.458 Y133.193 E.00068
G1 X128.459 Y133.308 E.00389
; LINE_WIDTH: 0.419999
G1 X128.632 Y133.572 E.00968
G1 X128.832 Y133.697 E.00725
G1 X128.853 Y133.909 E.00653
; LINE_WIDTH: 0.464771
G1 X128.886 Y134.462 E.01907
; LINE_WIDTH: 0.502499
G2 X128.982 Y135.393 I4.72 J-.014 E.03511
; LINE_WIDTH: 0.461249
G1 X129.032 Y135.684 E.01007
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524891
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559986
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517857
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566567
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.863 Y129.986 I-.585 J-.152 E.01352
; LINE_WIDTH: 0.515314
G1 X123.84 Y129.838 E.00578
; LINE_WIDTH: 0.472109
G1 X123.817 Y129.689 E.00525
; LINE_WIDTH: 0.428904
G1 X123.799 Y129.433 E.00808
; LINE_WIDTH: 0.393841
G1 X123.781 Y129.177 E.00735
; LINE_WIDTH: 0.386552
G1 X123.795 Y128.675 E.01405
; LINE_WIDTH: 0.434665
G1 X123.819 Y128.504 E.00552
; LINE_WIDTH: 0.482777
G1 X123.843 Y128.333 E.00619
; LINE_WIDTH: 0.530889
G1 X123.867 Y128.162 E.00687
; LINE_WIDTH: 0.579001
G1 X123.891 Y127.99 E.00755
G1 X123.886 Y125.055 E.12823
; LINE_WIDTH: 0.573607
G1 X123.907 Y120.563 E.19426
; LINE_WIDTH: 0.546362
G1 X123.936 Y117.89 E.10964
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01006
; LINE_WIDTH: 0.546362
G1 X124.41 Y120.564 E.10956
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.19417
; LINE_WIDTH: 0.579001
G2 X124.427 Y128.104 I1659.895 J-4.311 E.13325
G1 X124.278 Y128.282 E.01014
; LINE_WIDTH: 0.52957
G1 X124.226 Y128.437 E.00648
; LINE_WIDTH: 0.481898
G1 X124.174 Y128.592 E.00585
; LINE_WIDTH: 0.434225
G1 X124.123 Y128.747 E.00521
; LINE_WIDTH: 0.386552
G1 X124.097 Y129.166 E.01175
; LINE_WIDTH: 0.387951
G1 X124.137 Y129.369 E.00581
; LINE_WIDTH: 0.41678
G1 X124.177 Y129.572 E.0063
; LINE_WIDTH: 0.465871
G1 X124.237 Y129.7 E.00489
; LINE_WIDTH: 0.514962
G1 X124.297 Y129.829 E.00546
; LINE_WIDTH: 0.564053
G1 X124.358 Y129.957 E.00603
G1 X124.536 Y130.095 E.00957
G2 X124.359 Y130.326 I.161 J.307 E.01275
; LINE_WIDTH: 0.529352
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494651
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566567
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464393
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.51219
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559986
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.805 Y137.552 E.01521
G1 X127.282 Y137.365 E.01573
G1 X127.68 Y137.034 E.01591
G1 X127.941 Y136.667 E.01383
G1 X128.099 Y136.202 E.0151
G1 X128.118 Y135.777 E.01306
G1 X128.311 Y135.507 E.01021
; LINE_WIDTH: 0.451296
G1 X128.384 Y135.329 E.00637
; LINE_WIDTH: 0.482593
G1 X128.456 Y135.152 E.00686
; LINE_WIDTH: 0.495213
G1 X128.438 Y134.674 E.01764
G1 X128.331 Y134.481 E.00813
; LINE_WIDTH: 0.457606
G1 X128.225 Y134.287 E.00746
; LINE_WIDTH: 0.419999
G1 X127.934 Y133.993 E.01272
G1 X127.707 Y133.876 E.00785
G1 X127.847 Y133.764 E.00553
G1 X128.083 Y133.401 E.01328
G1 X128.11 Y133.197 E.00634
; LINE_WIDTH: 0.391285
G1 X128.137 Y132.993 E.00585
; LINE_WIDTH: 0.395423
G1 X128.158 Y132.935 E.00175
; LINE_WIDTH: 0.428275
G1 X128.18 Y132.878 E.00192
; LINE_WIDTH: 0.46924
G1 X128.185 Y132.802 E.00265
; LINE_WIDTH: 0.510205
G1 X128.19 Y132.726 E.00291
; LINE_WIDTH: 0.551169
G1 X128.195 Y132.65 E.00316
; LINE_WIDTH: 0.592134
G1 X128.201 Y132.573 E.00342
; LINE_WIDTH: 0.633098
G1 X128.206 Y132.497 E.00367
G1 X128.005 Y132.14 E.01974
G1 X127.636 Y131.823 E.02338
; LINE_WIDTH: 0.609398
G2 X127.758 Y131.646 I-.146 J-.232 E.01018
; LINE_WIDTH: 0.581834
G1 X127.797 Y131.552 E.00448
; LINE_WIDTH: 0.554269
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509989
G1 X127.82 Y131.347 E.00153
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576624
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538788
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500951
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460475
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.028 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00451
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.494 J1.385 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.0048
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.00171
G1 X130.094 Y129.526 E.00535
G2 X130.242 Y129.409 I-.103 J-.283 E.00591
G1 X130.282 Y129.361 E.00192
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466195
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512391
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558587
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604782
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.384 E.0043
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.355 Y129.445 E-.02343
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.63 E-.02581
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01901
G1 X128.665 Y129.736 E-.06527
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01704
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.026 E-.06845
; WIPE_END
G1 E-.04 F1800
G1 X130.933 Y131.841 Z7.98 F42000
G1 Z7.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.630496
G1 F1200
G1 X130.951 Y132.465 E.02989
; LINE_WIDTH: 0.646514
G1 X130.995 Y133.338 E.043
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.02533
G1 X131.218 Y134.637 E.03979
; LINE_WIDTH: 0.601264
G1 X131.31 Y134.865 E.01118
; LINE_WIDTH: 0.573197
G1 X131.401 Y135.093 E.01062
; WIPE_START
G1 F6788.905
G1 X131.31 Y134.865 E-.09339
G1 X131.218 Y134.637 E-.09339
G1 X131.045 Y133.849 E-.30657
G1 X130.995 Y133.338 E-.19513
G1 X130.985 Y133.15 E-.07152
; WIPE_END
G1 E-.04 F1800
G1 X128.307 Y133.783 Z7.98 F42000
G1 Z7.58
G1 E.8 F1800
; LINE_WIDTH: 0.458198
G1 F1200
G1 X128.457 Y133.95 E.00759
; WIPE_START
G1 F8668.892
G1 X128.307 Y133.783 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z7.98 F42000
G1 Z7.58
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.54903
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581118
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583738
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.625044
G1 X127.982 Y137.406 E.0326
G1 X128.323 Y136.937 E.02749
; LINE_WIDTH: 0.601442
G1 X128.534 Y136.35 E.02836
; LINE_WIDTH: 0.585374
G1 X128.571 Y135.926 E.01884
; WIPE_START
G1 F6636.507
G1 X128.534 Y136.35 E-.16192
G1 X128.323 Y136.937 E-.23682
G1 X127.982 Y137.406 E-.22022
G1 X127.685 Y137.627 E-.14104
; WIPE_END
G1 E-.04 F1800
G1 X128.662 Y130.058 Z7.98 F42000
G1 X128.986 Y127.549 Z7.98
G1 Z7.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590107
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500907
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 7.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.485
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 39/50
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
G17
G3 Z7.98 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z7.98
G1 Z7.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351834
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430705
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479652
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.5286
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577547
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626494
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587429
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548364
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509299
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470234
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424426
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378618
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.1425
G1 X128.038 Y127.914 E-.08419
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z8.18 F42000
G1 Z7.78
G1 E.8 F1800
; LINE_WIDTH: 0.360704
G1 F1200
G1 X128.141 Y130.333 E.01352
G1 X128.093 Y130.279 E.00186
G1 X127.755 Y129.822 E.01473
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.444 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565556
G1 F1200
G1 X128.355 Y129.445 E.00005
; LINE_WIDTH: 0.530836
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.487 E.01708
G1 X128.395 Y130.558 E.0041
G1 X128.22 Y130.846 E.01036
; LINE_WIDTH: 0.391222
G1 X128.192 Y131.19 E.00981
; LINE_WIDTH: 0.429847
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.4747
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519552
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564405
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609257
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.633213
G1 X128.535 Y131.815 E.01682
G1 X128.6 Y132.463 E.03132
G2 X128.451 Y132.639 I.186 J.31 E.01128
; LINE_WIDTH: 0.610585
G1 X128.452 Y132.751 E.00521
G1 X128.453 Y132.807 E.00257
; LINE_WIDTH: 0.562284
G1 X128.455 Y132.975 E.00711
; LINE_WIDTH: 0.513982
G1 X128.458 Y133.143 E.00645
; LINE_WIDTH: 0.465681
G1 X128.459 Y133.212 E.00238
G1 X128.46 Y133.311 E.00341
; LINE_WIDTH: 0.419999
G1 X128.631 Y133.57 E.00954
G1 X128.832 Y133.697 E.00729
G1 X128.853 Y133.909 E.00653
; LINE_WIDTH: 0.464676
G1 X128.886 Y134.456 E.01884
; LINE_WIDTH: 0.50289
G2 X128.982 Y135.395 I4.731 J-.011 E.03545
; LINE_WIDTH: 0.461445
G1 X129.032 Y135.684 E.01002
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454701
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489796
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.895 Y133.913 I-.949 J-.176 E.01658
; LINE_WIDTH: 0.515429
G1 X123.872 Y133.722 E.00741
; LINE_WIDTH: 0.470874
G1 X123.848 Y133.531 E.00671
; LINE_WIDTH: 0.426319
G1 X123.833 Y133.003 E.0165
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566564
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.866 Y130.012 I-.531 J-.146 E.01241
; LINE_WIDTH: 0.522371
G1 X123.847 Y129.89 E.00484
; LINE_WIDTH: 0.486225
G1 X123.828 Y129.767 E.00448
; LINE_WIDTH: 0.450078
G1 X123.805 Y129.502 E.00884
; LINE_WIDTH: 0.405785
G1 X123.783 Y129.236 E.00788
; LINE_WIDTH: 0.38561
G1 X123.794 Y128.683 E.01547
; LINE_WIDTH: 0.433958
G1 X123.819 Y128.509 E.00557
; LINE_WIDTH: 0.482306
G1 X123.843 Y128.336 E.00626
; LINE_WIDTH: 0.530654
G1 X123.867 Y128.163 E.00695
; LINE_WIDTH: 0.579001
G1 X123.891 Y127.99 E.00763
G1 X123.886 Y125.054 E.12825
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.651 E.00942
G1 X124.079 Y117.531 E.00658
G1 X124.253 Y117.533 E.0068
G1 X124.384 Y117.637 E.00654
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579001
G2 X124.427 Y128.104 I1653.505 J-4.289 E.13328
G1 X124.279 Y128.28 E.01006
; LINE_WIDTH: 0.530327
G1 X124.226 Y128.438 E.00661
; LINE_WIDTH: 0.482088
G1 X124.174 Y128.596 E.00596
; LINE_WIDTH: 0.433849
G1 X124.122 Y128.754 E.0053
; LINE_WIDTH: 0.38561
G1 X124.098 Y129.171 E.01167
; LINE_WIDTH: 0.388584
G1 X124.138 Y129.373 E.0058
; LINE_WIDTH: 0.417782
G1 X124.178 Y129.575 E.00629
; LINE_WIDTH: 0.466564
G1 X124.238 Y129.702 E.00484
; LINE_WIDTH: 0.515346
G1 X124.298 Y129.829 E.0054
; LINE_WIDTH: 0.564128
G1 X124.357 Y129.956 E.00596
G1 X124.535 Y130.095 E.00959
G2 X124.358 Y130.326 I.161 J.306 E.01274
; LINE_WIDTH: 0.529403
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494677
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566564
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.426319
G1 X124.229 Y133.504 E.01442
; LINE_WIDTH: 0.470874
G1 X124.274 Y133.643 E.00508
; LINE_WIDTH: 0.515429
G1 X124.318 Y133.782 E.00561
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00614
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.777 E.01307
G1 X128.315 Y135.498 E.01047
; LINE_WIDTH: 0.451512
G1 X128.385 Y135.327 E.00617
; LINE_WIDTH: 0.483024
G1 X128.456 Y135.155 E.00665
; LINE_WIDTH: 0.495686
G1 X128.436 Y134.669 E.01795
G1 X128.329 Y134.477 E.00813
; LINE_WIDTH: 0.457843
G1 X128.222 Y134.284 E.00745
; LINE_WIDTH: 0.419999
G1 X127.932 Y133.992 E.01265
G1 X127.707 Y133.876 E.00779
G1 X127.846 Y133.765 E.00547
G1 X128.082 Y133.405 E.01323
G1 X128.109 Y133.197 E.00644
; LINE_WIDTH: 0.391561
G1 X128.137 Y132.989 E.00595
; LINE_WIDTH: 0.395009
G1 X128.158 Y132.932 E.00176
; LINE_WIDTH: 0.426895
G1 X128.179 Y132.874 E.00192
; LINE_WIDTH: 0.468159
G1 X128.184 Y132.798 E.00266
; LINE_WIDTH: 0.509423
G1 X128.189 Y132.721 E.00292
; LINE_WIDTH: 0.550686
G1 X128.194 Y132.645 E.00317
; LINE_WIDTH: 0.59195
G1 X128.199 Y132.568 E.00343
; LINE_WIDTH: 0.633213
G1 X128.204 Y132.492 E.00369
G1 X128.005 Y132.14 E.01942
G1 X127.636 Y131.823 E.02343
; LINE_WIDTH: 0.609257
G2 X127.758 Y131.646 I-.146 J-.232 E.01018
; LINE_WIDTH: 0.581821
G1 X127.797 Y131.552 E.00448
; LINE_WIDTH: 0.554384
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00142
; LINE_WIDTH: 0.510076
G1 X127.82 Y131.348 E.00152
G1 X127.834 Y131.223 E.00479
; LINE_WIDTH: 0.465767
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421458
G1 X127.852 Y131.056 E.00007
G1 X127.854 Y131.037 E.00057
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500956
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.036 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.499 J1.385 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.239 Y129.414 I-.098 J-.276 E.00574
G1 X130.282 Y129.361 E.00209
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.348 Y129.384 E.00432
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.355 Y129.445 E-.02328
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01894
G1 X128.665 Y129.736 E-.06533
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.487 E-.21123
G1 X128.395 Y130.558 E-.05071
G1 X128.22 Y130.846 E-.12809
G1 X128.205 Y131.026 E-.06867
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z8.18 F42000
G1 Z7.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60127
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19059
; WIPE_END
G1 E-.04 F1800
G1 X128.307 Y133.784 Z8.18 F42000
G1 Z7.78
G1 E.8 F1800
; LINE_WIDTH: 0.460034
G1 F1200
G1 X128.457 Y133.949 E.00756
; WIPE_START
G1 F8630.734
G1 X128.307 Y133.784 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z8.18 F42000
G1 Z7.78
G1 E.8 F1800
; LINE_WIDTH: 0.530458
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.54903
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583736
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.61531
G1 X127.944 Y137.445 E.02953
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599774
G1 X128.571 Y135.919 E.01253
; WIPE_START
G1 F6464.89
G1 X128.562 Y136.195 E-.10495
G1 X128.452 Y136.634 E-.17157
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19509
G1 X127.694 Y137.626 E-.11725
; WIPE_END
G1 E-.04 F1800
G1 X128.664 Y130.055 Z8.18 F42000
M73 P93 R1
G1 X128.986 Y127.549 Z8.18
G1 Z7.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586815
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 7.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.459
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 40/50
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
G17
G3 Z8.18 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z8.18
G1 Z7.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638771
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596802
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438163
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.40799
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379912
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351834
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479653
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587431
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548365
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509299
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470233
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424426
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378618
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382248
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497192
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544385
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591578
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638771
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.779
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z8.38 F42000
G1 Z7.98
G1 E.8 F1800
; LINE_WIDTH: 0.360711
G1 F1200
G1 X128.146 Y130.325 E.01333
G1 X128.118 Y130.341 E.00082
G1 X128.094 Y130.282 E.00166
G1 X127.755 Y129.822 E.01479
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.444 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.565557
G1 F1200
G1 X128.355 Y129.445 E.00004
; LINE_WIDTH: 0.530838
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.489 E.01715
G1 X128.385 Y130.57 E.00453
G1 X128.22 Y130.845 E.00985
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00984
; LINE_WIDTH: 0.429558
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474123
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.518687
G1 X128.232 Y131.435 E.00321
; LINE_WIDTH: 0.563252
G1 X128.246 Y131.517 E.00351
; LINE_WIDTH: 0.607816
G1 X128.259 Y131.598 E.00381
; LINE_WIDTH: 0.629856
G1 X128.535 Y131.815 E.01678
G3 X128.602 Y132.466 I-38.533 J4.283 E.03131
G2 X128.493 Y132.593 I.076 J.176 E.0083
; LINE_WIDTH: 0.60023
G1 X128.464 Y132.655 E.00311
; LINE_WIDTH: 0.570604
G1 X128.464 Y132.763 E.00463
G1 X128.463 Y132.821 E.00251
; LINE_WIDTH: 0.532391
G1 X128.463 Y132.988 E.00662
; LINE_WIDTH: 0.494177
G1 X128.463 Y133.154 E.00611
; LINE_WIDTH: 0.455963
G1 X128.463 Y133.211 E.00194
G1 X128.463 Y133.32 E.00365
; LINE_WIDTH: 0.419999
G1 X128.625 Y133.56 E.00891
G1 X128.832 Y133.697 E.00763
G1 X128.853 Y133.91 E.00658
; LINE_WIDTH: 0.458977
G1 X128.867 Y134.239 E.01114
; LINE_WIDTH: 0.497955
G1 X128.88 Y134.567 E.01219
; LINE_WIDTH: 0.503284
G2 X128.982 Y135.397 I5.478 J-.252 E.03138
; LINE_WIDTH: 0.461642
G1 X129.032 Y135.684 E.00996
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489793
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524887
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559981
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517854
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475726
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433598
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566566
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523624
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.867 Y130.014 I-.528 J-.146 E.01235
; LINE_WIDTH: 0.522763
G1 X123.848 Y129.893 E.00479
; LINE_WIDTH: 0.487007
G1 X123.829 Y129.772 E.00443
; LINE_WIDTH: 0.451251
G1 X123.806 Y129.506 E.00886
; LINE_WIDTH: 0.406536
G1 X123.783 Y129.241 E.00789
; LINE_WIDTH: 0.384681
G1 X123.794 Y128.69 E.01535
; LINE_WIDTH: 0.433261
G1 X123.818 Y128.515 E.00562
; LINE_WIDTH: 0.481841
G1 X123.842 Y128.34 E.00632
; LINE_WIDTH: 0.530421
G1 X123.867 Y128.165 E.00702
; LINE_WIDTH: 0.579001
G1 X123.891 Y127.99 E.00772
G1 X123.886 Y125.054 E.12824
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579001
G2 X124.427 Y128.104 I1662.044 J-4.319 E.13327
G1 X124.28 Y128.278 E.00998
; LINE_WIDTH: 0.531086
G1 X124.227 Y128.439 E.00674
; LINE_WIDTH: 0.482285
G1 X124.173 Y128.6 E.00607
; LINE_WIDTH: 0.433483
G1 X124.12 Y128.761 E.0054
; LINE_WIDTH: 0.384681
G1 X124.098 Y129.177 E.0116
; LINE_WIDTH: 0.389232
G1 X124.139 Y129.378 E.00579
; LINE_WIDTH: 0.418799
G1 X124.18 Y129.579 E.00628
; LINE_WIDTH: 0.467267
G1 X124.239 Y129.705 E.0048
; LINE_WIDTH: 0.515734
G1 X124.298 Y129.83 E.00534
; LINE_WIDTH: 0.564201
G1 X124.357 Y129.956 E.00589
G1 X124.535 Y130.096 E.00962
G2 X124.358 Y130.326 I.161 J.306 E.01274
; LINE_WIDTH: 0.529451
G1 X124.294 Y130.464 E.00602
; LINE_WIDTH: 0.494701
G1 X124.229 Y130.601 E.00559
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523624
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566566
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464391
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512186
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559981
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01297
G1 X128.289 Y135.553 E.00875
; LINE_WIDTH: 0.450562
G1 X128.371 Y135.358 E.00702
; LINE_WIDTH: 0.481125
G1 X128.453 Y135.163 E.00755
; LINE_WIDTH: 0.49154
G1 X128.449 Y134.732 E.01577
G1 X128.336 Y134.448 E.01117
; LINE_WIDTH: 0.450643
G1 X128.084 Y134.118 E.01377
; LINE_WIDTH: 0.419999
G1 X127.739 Y133.877 E.01294
G1 X127.851 Y133.761 E.00494
G1 X128.08 Y133.408 E.01294
G1 X128.114 Y133.257 E.00475
; LINE_WIDTH: 0.444294
G1 X128.134 Y133.119 E.00458
; LINE_WIDTH: 0.485699
G1 X128.154 Y132.98 E.00505
; LINE_WIDTH: 0.527104
G1 X128.174 Y132.846 E.00533
G1 X128.175 Y132.842 E.00019
; LINE_WIDTH: 0.568509
G1 X128.184 Y132.778 E.00278
G1 X128.195 Y132.703 E.00322
; LINE_WIDTH: 0.609914
G1 X128.215 Y132.565 E.00646
; LINE_WIDTH: 0.629856
G1 X128.02 Y132.155 E.02174
G1 X127.888 Y132.024 E.00887
; LINE_WIDTH: 0.607816
G1 X127.63 Y131.828 E.01493
G2 X127.758 Y131.646 I-.151 J-.243 E.0105
; LINE_WIDTH: 0.581041
G1 X127.797 Y131.552 E.00447
; LINE_WIDTH: 0.554266
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509987
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500954
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.033 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.5 J1.385 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558588
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604784
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.385 E.00433
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.355 Y129.445 E-.02312
G1 X128.387 Y129.508 E-.02662
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.489 E-.21205
G1 X128.385 Y130.57 E-.05604
G1 X128.22 Y130.845 E-.12177
G1 X128.205 Y131.026 E-.069
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z8.38 F42000
G1 Z7.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573197
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601262
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19059
; WIPE_END
G1 E-.04 F1800
G1 X128.305 Y133.794 Z8.38 F42000
G1 Z7.98
G1 E.8 F1800
; LINE_WIDTH: 0.47586
G1 F1200
G1 X128.453 Y133.951 E.00762
; WIPE_START
G1 F8315.24
G1 X128.305 Y133.794 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z8.38 F42000
G1 Z7.98
G1 E.8 F1800
; LINE_WIDTH: 0.530456
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583736
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.615308
G1 X127.944 Y137.445 E.02953
; LINE_WIDTH: 0.62528
G1 X128.261 Y137.041 E.02436
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.62131
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.59972
G1 X128.57 Y135.934 E.01186
; WIPE_START
G1 F6465.517
G1 X128.562 Y136.195 E-.09934
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19509
G1 X127.682 Y137.635 E-.12286
; WIPE_END
G1 E-.04 F1800
G1 X128.66 Y130.065 Z8.38 F42000
G1 X128.986 Y127.549 Z8.38
G1 Z7.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530406
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 8.18
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.459
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 41/50
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
G17
G3 Z8.38 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z8.38
G1 Z8.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596802
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554832
G1 X128.374 Y127.391 E.00864
; LINE_WIDTH: 0.512862
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351835
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332811
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381759
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430707
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479655
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528603
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577551
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587431
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548363
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509296
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470228
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424423
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378617
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332811
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350611
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382242
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397353
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z8.58 F42000
G1 Z8.18
G1 E.8 F1800
; LINE_WIDTH: 0.360717
G1 F1200
G1 X128.142 Y130.34 E.01372
G1 X128.117 Y130.334 E.00067
G1 X127.755 Y129.822 E.01623
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.491 E.0172
G1 X128.377 Y130.579 E.00487
G1 X128.221 Y130.844 E.00944
; LINE_WIDTH: 0.39122
G1 X128.192 Y131.19 E.00987
; LINE_WIDTH: 0.429595
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474196
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.518798
G1 X128.232 Y131.435 E.00321
; LINE_WIDTH: 0.563399
G1 X128.246 Y131.517 E.00351
; LINE_WIDTH: 0.608
G1 X128.259 Y131.599 E.00381
; LINE_WIDTH: 0.629534
G1 X128.535 Y131.815 E.01677
G3 X128.602 Y132.468 I-34.418 J3.869 E.03138
G1 X128.46 Y132.621 E.00999
; LINE_WIDTH: 0.608071
G1 X128.457 Y132.677 E.00262
; LINE_WIDTH: 0.568015
G1 X128.454 Y132.734 E.00244
; LINE_WIDTH: 0.527958
G1 X128.451 Y132.791 E.00225
; LINE_WIDTH: 0.487901
G1 X128.447 Y132.848 E.00206
; LINE_WIDTH: 0.447844
G1 X128.444 Y132.905 E.00188
; LINE_WIDTH: 0.449467
G1 X128.43 Y132.995 E.00304
; LINE_WIDTH: 0.491147
G1 X128.415 Y133.086 E.00335
; LINE_WIDTH: 0.532827
G1 X128.401 Y133.176 E.00366
; LINE_WIDTH: 0.574507
G1 X128.386 Y133.267 E.00397
; LINE_WIDTH: 0.616186
G1 X128.371 Y133.357 E.00428
; LINE_WIDTH: 0.622663
G1 X128.542 Y133.618 E.0147
; LINE_WIDTH: 0.627965
G1 X128.734 Y133.766 E.01157
G2 X128.801 Y134.216 I1.831 J-.041 E.02177
; LINE_WIDTH: 0.585651
G1 X128.839 Y134.382 E.00752
; LINE_WIDTH: 0.543336
G1 X128.877 Y134.548 E.00694
; LINE_WIDTH: 0.503743
G1 X128.932 Y135.113 E.02132
G2 X128.982 Y135.399 I5.686 J-.845 E.0109
; LINE_WIDTH: 0.461871
G1 X129.032 Y135.684 E.0099
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.861 Y129.973 I-.621 J-.157 E.01406
; LINE_WIDTH: 0.512936
G1 X123.837 Y129.812 E.00625
; LINE_WIDTH: 0.467355
G1 X123.813 Y129.65 E.00564
; LINE_WIDTH: 0.421774
G1 X123.797 Y129.385 E.00821
; LINE_WIDTH: 0.389131
G1 X123.78 Y129.119 E.00751
; LINE_WIDTH: 0.395806
G1 X123.8 Y128.611 E.01464
; LINE_WIDTH: 0.441605
G1 X123.822 Y128.455 E.0051
; LINE_WIDTH: 0.487403
G1 X123.845 Y128.3 E.00568
; LINE_WIDTH: 0.533202
G1 X123.868 Y128.145 E.00627
; LINE_WIDTH: 0.579
G1 X123.891 Y127.99 E.00685
G1 X123.886 Y125.054 E.12823
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.579
G2 X124.427 Y128.104 I1655.017 J-4.294 E.13327
G2 X124.291 Y128.31 I.166 J.257 E.01111
; LINE_WIDTH: 0.533202
G1 X124.248 Y128.415 E.00454
G1 X124.239 Y128.436 E.00093
; LINE_WIDTH: 0.487403
G1 X124.202 Y128.524 E.00344
G1 X124.186 Y128.563 E.00152
; LINE_WIDTH: 0.441605
G1 X124.134 Y128.689 E.00445
; LINE_WIDTH: 0.395806
G1 X124.094 Y129.101 E.01188
; LINE_WIDTH: 0.401563
G1 X124.157 Y129.503 E.01191
; LINE_WIDTH: 0.446165
G1 X124.2 Y129.621 E.00414
; LINE_WIDTH: 0.490767
G1 X124.244 Y129.74 E.0046
; LINE_WIDTH: 0.535368
G1 X124.287 Y129.858 E.00505
; LINE_WIDTH: 0.565482
G1 X124.527 Y130.102 E.01456
G2 X124.358 Y130.326 I.157 J.293 E.01232
; LINE_WIDTH: 0.530305
G1 X124.293 Y130.463 E.00604
; LINE_WIDTH: 0.495128
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451189
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01297
G1 X128.289 Y135.554 E.00869
; LINE_WIDTH: 0.45059
G1 X128.371 Y135.361 E.00698
; LINE_WIDTH: 0.481181
G1 X128.453 Y135.167 E.00751
; LINE_WIDTH: 0.491303
G1 X128.45 Y134.737 E.01571
; LINE_WIDTH: 0.532414
G1 X128.418 Y134.595 E.00581
; LINE_WIDTH: 0.573524
G1 X128.385 Y134.453 E.0063
; LINE_WIDTH: 0.614634
G1 X128.353 Y134.311 E.00679
; LINE_WIDTH: 0.621098
G1 X128.191 Y134.09 E.01289
; LINE_WIDTH: 0.622663
G1 X127.914 Y133.871 E.01669
G2 X128.199 Y133.37 I-4.741 J-3.027 E.02724
; LINE_WIDTH: 0.616186
G1 X128.19 Y133.296 E.0035
; LINE_WIDTH: 0.568124
G1 X128.18 Y133.221 E.00321
; LINE_WIDTH: 0.520061
G1 X128.171 Y133.147 E.00291
; LINE_WIDTH: 0.471998
G1 X128.162 Y133.073 E.00262
; LINE_WIDTH: 0.423935
G1 X128.152 Y132.998 E.00233
; LINE_WIDTH: 0.422312
G1 X128.165 Y132.913 E.00266
; LINE_WIDTH: 0.468752
G1 X128.178 Y132.828 E.00299
; LINE_WIDTH: 0.515192
G1 X128.191 Y132.743 E.00331
; LINE_WIDTH: 0.561632
G1 X128.204 Y132.658 E.00364
; LINE_WIDTH: 0.608071
G1 X128.216 Y132.572 E.00397
; LINE_WIDTH: 0.629534
G1 X128.025 Y132.162 E.02162
G1 X127.886 Y132.023 E.00944
; LINE_WIDTH: 0.608
G1 X127.63 Y131.827 E.01481
G2 X127.758 Y131.646 I-.151 J-.242 E.01049
; LINE_WIDTH: 0.581133
G1 X127.797 Y131.552 E.00447
; LINE_WIDTH: 0.554265
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509986
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.031 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.498 J1.385 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558588
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604784
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.153
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
M73 P94 R1
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.491 E-.21266
G1 X128.377 Y130.579 E-.06025
G1 X128.221 Y130.844 E-.11676
G1 X128.205 Y131.028 E-.07029
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z8.58 F42000
G1 Z8.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573201
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19059
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z8.58 F42000
G1 Z8.18
G1 E.8 F1800
; LINE_WIDTH: 0.530454
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549034
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583738
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.615308
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625284
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599722
G1 X128.57 Y135.934 E.01185
; WIPE_START
G1 F6465.494
G1 X128.562 Y136.195 E-.09922
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.682 Y137.635 E-.12297
; WIPE_END
G1 E-.04 F1800
G1 X128.66 Y130.065 Z8.58 F42000
G1 X128.986 Y127.549 Z8.58
G1 Z8.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590107
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500907
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 8.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.485
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 42/50
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
G17
G3 Z8.58 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z8.58
G1 Z8.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351834
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.33281
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381758
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479653
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587429
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548362
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509295
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470228
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424422
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378616
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.33281
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X127.998 Y129.546 Z8.78 F42000
G1 Z8.38
G1 E.8 F1800
; LINE_WIDTH: 0.360699
G1 F1200
G1 X128.141 Y129.811 E.00778
G1 X128.129 Y130.341 E.01374
G1 X128.113 Y130.323 E.00063
G1 X127.755 Y129.822 E.01595
G1 X127.959 Y129.591 E.00798
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530836
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429631
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474269
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.518907
G1 X128.232 Y131.435 E.00321
; LINE_WIDTH: 0.563545
G1 X128.246 Y131.517 E.00351
; LINE_WIDTH: 0.608182
G1 X128.259 Y131.599 E.00381
; LINE_WIDTH: 0.629258
G1 X128.535 Y131.815 E.01675
G3 X128.603 Y132.47 I-31.01 J3.526 E.03144
G1 X128.456 Y132.628 E.01029
; LINE_WIDTH: 0.606034
G1 X128.455 Y132.692 E.00297
; LINE_WIDTH: 0.560608
G1 X128.454 Y132.757 E.00273
; LINE_WIDTH: 0.515181
G1 X128.453 Y132.822 E.00249
; LINE_WIDTH: 0.469755
G1 X128.452 Y132.887 E.00225
; LINE_WIDTH: 0.424328
G1 X128.451 Y132.951 E.00201
; LINE_WIDTH: 0.424454
G1 X128.436 Y133.033 E.00258
; LINE_WIDTH: 0.470006
G1 X128.422 Y133.115 E.00289
; LINE_WIDTH: 0.515558
G1 X128.421 Y133.117 E.00007
G1 X128.407 Y133.197 E.00313
; LINE_WIDTH: 0.56111
G1 X128.392 Y133.278 E.00351
; LINE_WIDTH: 0.606662
G1 X128.378 Y133.36 E.00382
; LINE_WIDTH: 0.622759
G1 X128.541 Y133.616 E.01436
; LINE_WIDTH: 0.628188
G1 X128.734 Y133.766 E.01165
G2 X128.801 Y134.224 I1.847 J-.039 E.02213
; LINE_WIDTH: 0.585574
G1 X128.84 Y134.39 E.00752
; LINE_WIDTH: 0.54296
G1 X128.878 Y134.555 E.00693
; LINE_WIDTH: 0.504131
G1 X128.932 Y135.116 E.02117
G2 X128.982 Y135.4 I5.52 J-.821 E.01084
; LINE_WIDTH: 0.462065
G1 X129.032 Y135.684 E.00985
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.902 Y138.506 E.017
G1 X126.35 Y138.543 E.017
G1 X125.802 Y138.461 E.017
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.134 Y137.105 E.017
G1 X123.943 Y136.586 E.017
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.861 Y129.971 I-.627 J-.157 E.01416
; LINE_WIDTH: 0.512419
G1 X123.837 Y129.807 E.00634
; LINE_WIDTH: 0.46632
G1 X123.812 Y129.643 E.00572
; LINE_WIDTH: 0.420221
G1 X123.796 Y129.379 E.00814
; LINE_WIDTH: 0.388293
G1 X123.78 Y129.114 E.00745
; LINE_WIDTH: 0.396526
G1 X123.8 Y128.606 E.01465
; LINE_WIDTH: 0.442145
G1 X123.823 Y128.452 E.00507
; LINE_WIDTH: 0.487763
G1 X123.845 Y128.298 E.00565
; LINE_WIDTH: 0.533382
G1 X123.868 Y128.144 E.00623
; LINE_WIDTH: 0.579
G1 X123.891 Y127.989 E.00681
G1 X123.886 Y125.055 E.12819
; LINE_WIDTH: 0.573607
G1 X123.906 Y120.643 E.19081
; LINE_WIDTH: 0.547069
G1 X123.936 Y117.89 E.11308
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01005
; LINE_WIDTH: 0.547069
G1 X124.41 Y120.644 E.11299
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.19071
; LINE_WIDTH: 0.579
G2 X124.427 Y128.104 I1662.937 J-4.322 E.13323
G2 X124.291 Y128.309 I.165 J.257 E.01107
; LINE_WIDTH: 0.533382
G1 X124.247 Y128.417 E.00467
G1 X124.239 Y128.434 E.00077
; LINE_WIDTH: 0.487763
G1 X124.202 Y128.525 E.00354
G1 X124.195 Y128.54 E.00059
G1 X124.187 Y128.56 E.0008
; LINE_WIDTH: 0.442145
G1 X124.135 Y128.686 E.00443
; LINE_WIDTH: 0.396526
G1 X124.094 Y129.095 E.01185
; LINE_WIDTH: 0.400042
G1 X124.155 Y129.496 E.0118
; LINE_WIDTH: 0.445568
G1 X124.199 Y129.618 E.00425
; LINE_WIDTH: 0.491093
G1 X124.244 Y129.739 E.00473
; LINE_WIDTH: 0.536618
G1 X124.289 Y129.861 E.00521
; LINE_WIDTH: 0.565406
G1 X124.527 Y130.102 E.01443
G2 X124.358 Y130.326 I.157 J.294 E.01233
; LINE_WIDTH: 0.530254
G1 X124.293 Y130.463 E.00604
; LINE_WIDTH: 0.495102
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.772 Y137.555 E.01417
G1 X127.264 Y137.373 E.01611
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01297
G1 X128.288 Y135.556 E.00864
; LINE_WIDTH: 0.450598
G1 X128.37 Y135.364 E.00695
; LINE_WIDTH: 0.481196
G1 X128.452 Y135.171 E.00747
; LINE_WIDTH: 0.491066
G1 X128.451 Y134.743 E.01563
; LINE_WIDTH: 0.532105
G1 X128.42 Y134.602 E.00578
; LINE_WIDTH: 0.573144
G1 X128.388 Y134.46 E.00627
; LINE_WIDTH: 0.614182
G1 X128.357 Y134.318 E.00675
; LINE_WIDTH: 0.621422
G1 X128.191 Y134.091 E.01327
; LINE_WIDTH: 0.622759
G1 X127.913 Y133.87 E.01678
G1 X128.173 Y133.452 E.02326
G1 X128.168 Y133.366 E.00406
; LINE_WIDTH: 0.573922
G1 X128.164 Y133.28 E.00372
; LINE_WIDTH: 0.525085
G1 X128.159 Y133.195 E.00337
; LINE_WIDTH: 0.476248
G1 X128.154 Y133.109 E.00303
; LINE_WIDTH: 0.427411
G1 X128.149 Y133.023 E.00269
; LINE_WIDTH: 0.424066
G1 X128.163 Y132.934 E.00279
; LINE_WIDTH: 0.469558
G1 X128.177 Y132.846 E.00312
; LINE_WIDTH: 0.51505
G1 X128.19 Y132.757 E.00345
; LINE_WIDTH: 0.560542
G1 X128.204 Y132.668 E.00378
; LINE_WIDTH: 0.606034
G1 X128.218 Y132.58 E.00412
; LINE_WIDTH: 0.629258
G1 X128.031 Y132.17 E.0215
G1 X127.884 Y132.021 E.01001
; LINE_WIDTH: 0.608182
G1 X127.631 Y131.827 E.01469
G2 X127.758 Y131.646 I-.15 J-.241 E.01048
; LINE_WIDTH: 0.581225
G1 X127.797 Y131.552 E.00447
; LINE_WIDTH: 0.554267
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509988
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465708
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.033 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00682
G2 X130.422 Y131.721 I-41.491 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.00481
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.274 E.00571
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02663
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06985
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z8.78 F42000
G1 Z8.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5732
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.60127
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23721
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.1906
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z8.78 F42000
G1 Z8.38
G1 E.8 F1800
; LINE_WIDTH: 0.530454
G1 F1200
G1 X124.459 Y136.736 E.01599
; LINE_WIDTH: 0.549032
G1 X124.716 Y137.195 E.0217
; LINE_WIDTH: 0.581116
G1 X125.111 Y137.607 E.02505
; LINE_WIDTH: 0.583738
G1 X125.658 Y137.916 E.02768
; LINE_WIDTH: 0.600724
G1 X126.22 Y138.051 E.02624
; LINE_WIDTH: 0.623082
G1 X126.81 Y138.032 E.0279
G1 X127.431 Y137.816 E.0311
; LINE_WIDTH: 0.61531
G1 X127.944 Y137.445 E.02952
; LINE_WIDTH: 0.625282
G1 X128.261 Y137.041 E.02437
G1 X128.452 Y136.634 E.02137
; LINE_WIDTH: 0.621314
G1 X128.562 Y136.195 E.02128
; LINE_WIDTH: 0.599724
G1 X128.57 Y135.935 E.01183
; WIPE_START
G1 F6465.471
G1 X128.562 Y136.195 E-.09909
G1 X128.452 Y136.634 E-.17158
G1 X128.261 Y137.041 E-.17113
G1 X127.944 Y137.445 E-.19511
G1 X127.681 Y137.635 E-.12309
; WIPE_END
G1 E-.04 F1800
G1 X128.66 Y130.065 Z8.78 F42000
G1 X128.986 Y127.549 Z8.78
G1 Z8.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590107
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530407
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500908
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 8.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.477
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 43/50
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
G17
G3 Z8.78 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z8.78
G1 Z8.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332811
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381759
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430706
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479654
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577549
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.58743
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548363
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509296
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470229
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424423
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378617
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332811
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424406
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z8.98 F42000
G1 Z8.58
G1 E.8 F1800
; LINE_WIDTH: 0.360699
G1 F1200
G1 X128.142 Y130.261 E.01166
G1 X128.12 Y130.35 E.00239
G1 X128.092 Y130.278 E.00201
G1 X127.755 Y129.822 E.01469
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530837
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429667
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474341
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.519014
G1 X128.232 Y131.436 E.00321
; LINE_WIDTH: 0.563688
G1 X128.246 Y131.517 E.00351
; LINE_WIDTH: 0.608361
G1 X128.259 Y131.599 E.00382
; LINE_WIDTH: 0.629031
G1 X128.535 Y131.815 E.01674
G1 X128.595 Y132.388 E.02751
G1 X128.464 Y132.624 E.01288
; LINE_WIDTH: 0.605049
G1 X128.462 Y132.737 E.00517
G1 X128.462 Y132.746 E.00039
; LINE_WIDTH: 0.562744
G1 X128.462 Y132.776 E.00129
G1 X128.46 Y132.867 E.00386
; LINE_WIDTH: 0.520438
G1 X128.458 Y132.989 E.00473
; LINE_WIDTH: 0.478133
G1 X128.455 Y133.11 E.00431
; LINE_WIDTH: 0.435827
G1 X128.455 Y133.131 E.00068
G1 X128.453 Y133.231 E.00321
; LINE_WIDTH: 0.419999
G1 X128.538 Y133.462 E.00756
G1 X128.833 Y133.713 E.01189
G1 X128.868 Y134.056 E.01059
; LINE_WIDTH: 0.459837
G1 X128.873 Y134.309 E.00862
; LINE_WIDTH: 0.499675
G1 X128.879 Y134.563 E.00945
; LINE_WIDTH: 0.501469
G2 X128.975 Y135.32 I4.704 J-.211 E.02855
; LINE_WIDTH: 0.460734
G1 X129.021 Y135.573 E.00875
; LINE_WIDTH: 0.419999
G1 X129.033 Y136.133 E.01722
G1 X128.97 Y136.559 E.01323
G1 X128.747 Y137.145 E.01927
G1 X128.459 Y137.58 E.01604
G1 X128.105 Y137.946 E.01562
G1 X127.625 Y138.259 E.01761
G1 X127.093 Y138.457 E.01744
G1 X126.575 Y138.537 E.01611
G1 X126.024 Y138.504 E.01695
G1 X125.41 Y138.314 E.01975
G1 X124.904 Y138.022 E.01796
G1 X124.509 Y137.656 E.01656
G1 X124.297 Y137.382 E.01065
G1 X124.063 Y136.927 E.0157
G1 X123.98 Y136.669 E.00832
G1 X123.867 Y136.047 E.01943
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01656
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489795
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559985
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517857
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536821
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580636
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.861 Y129.968 I-.634 J-.158 E.01427
; LINE_WIDTH: 0.511906
G1 X123.836 Y129.802 E.00643
; LINE_WIDTH: 0.465294
G1 X123.812 Y129.635 E.00579
; LINE_WIDTH: 0.418682
G1 X123.796 Y129.372 E.00807
; LINE_WIDTH: 0.387463
G1 X123.78 Y129.109 E.0074
; LINE_WIDTH: 0.397251
G1 X123.8 Y128.602 E.01466
; LINE_WIDTH: 0.442689
G1 X123.823 Y128.449 E.00505
; LINE_WIDTH: 0.488126
G1 X123.845 Y128.296 E.00562
; LINE_WIDTH: 0.533563
G1 X123.868 Y128.142 E.00619
; LINE_WIDTH: 0.579
G1 X123.891 Y127.989 E.00677
G1 X123.886 Y125.055 E.12818
; LINE_WIDTH: 0.573607
G1 X123.906 Y120.663 E.18994
; LINE_WIDTH: 0.547246
G1 X123.936 Y117.89 E.11394
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01005
; LINE_WIDTH: 0.547246
G1 X124.41 Y120.664 E.11385
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.18985
; LINE_WIDTH: 0.579
G2 X124.427 Y128.103 I1656.118 J-4.298 E.13323
G2 X124.291 Y128.308 I.164 J.256 E.01103
; LINE_WIDTH: 0.533563
G1 X124.245 Y128.418 E.00479
G1 X124.239 Y128.433 E.00061
; LINE_WIDTH: 0.488126
G1 X124.187 Y128.557 E.0049
; LINE_WIDTH: 0.442689
G1 X124.135 Y128.682 E.0044
; LINE_WIDTH: 0.397251
G1 X124.094 Y129.09 E.01183
; LINE_WIDTH: 0.398528
G1 X124.153 Y129.489 E.01169
; LINE_WIDTH: 0.444977
G1 X124.199 Y129.614 E.00436
; LINE_WIDTH: 0.491425
G1 X124.244 Y129.739 E.00486
; LINE_WIDTH: 0.537873
G1 X124.29 Y129.863 E.00536
; LINE_WIDTH: 0.565327
G1 X124.527 Y130.102 E.01431
G2 X124.358 Y130.326 I.157 J.294 E.01233
; LINE_WIDTH: 0.530202
G1 X124.293 Y130.463 E.00604
; LINE_WIDTH: 0.495077
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518861
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477569
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441472
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464393
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512189
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559985
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451189
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.472 Y135.862 E.01328
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01115
G1 X124.814 Y136.471 E.01128
G1 X125.043 Y136.896 E.01482
G1 X125.396 Y137.255 E.01548
G1 X125.829 Y137.491 E.01516
G1 X126.235 Y137.577 E.01275
G1 X126.804 Y137.552 E.0175
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.078 Y136.267 E.01303
G1 X128.118 Y135.78 E.01502
G1 X128.287 Y135.558 E.00859
; LINE_WIDTH: 0.450602
G1 X128.369 Y135.366 E.00692
; LINE_WIDTH: 0.481205
G1 X128.451 Y135.175 E.00744
; LINE_WIDTH: 0.490834
G1 X128.452 Y134.749 E.01555
G1 X128.364 Y134.555 E.00779
; LINE_WIDTH: 0.459961
G1 X128.275 Y134.36 E.00726
; LINE_WIDTH: 0.429087
G1 X128.073 Y134.106 E.01021
; LINE_WIDTH: 0.419999
G1 X127.736 Y133.875 E.01255
G1 X127.847 Y133.765 E.00482
G1 X128.062 Y133.44 E.01196
G1 X128.119 Y133.206 E.00741
; LINE_WIDTH: 0.435827
G1 X128.139 Y133.082 E.00401
; LINE_WIDTH: 0.478133
G1 X128.159 Y132.96 E.00439
G1 X128.159 Y132.958 E.00005
; LINE_WIDTH: 0.520438
G1 X128.174 Y132.867 E.00361
G1 X128.179 Y132.835 E.00127
; LINE_WIDTH: 0.562744
G1 X128.185 Y132.801 E.00146
G1 X128.199 Y132.711 E.00385
; LINE_WIDTH: 0.605049
G1 X128.219 Y132.587 E.00574
; LINE_WIDTH: 0.629031
G1 X128.036 Y132.178 E.02139
G1 X127.882 Y132.02 E.01057
; LINE_WIDTH: 0.608361
G1 X127.631 Y131.827 E.01458
G1 X127.762 Y131.687 E.00884
G1 X127.78 Y131.619 E.00321
; LINE_WIDTH: 0.581316
G1 X127.797 Y131.552 E.00306
; LINE_WIDTH: 0.554271
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509991
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.46571
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500954
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.03 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.492 J1.384 E.04698
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00156
G1 X130.229 Y131.61 E.0048
G1 X130.378 Y131.492 E.00584
G1 X130.406 Y131.471 E.00108
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
M73 P95 R1
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558588
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604784
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.153
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01901
G1 X128.665 Y129.736 E-.06527
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06985
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z8.98 F42000
G1 Z8.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.532914
G1 F1200
G1 X124.459 Y136.739 E.01618
; LINE_WIDTH: 0.555296
G1 X124.773 Y137.269 E.02573
; LINE_WIDTH: 0.56804
G1 X125.192 Y137.663 E.02461
; LINE_WIDTH: 0.59066
G1 X125.666 Y137.922 E.0241
; LINE_WIDTH: 0.618324
G1 X126.118 Y138.036 E.02187
; LINE_WIDTH: 0.626612
G2 X127.011 Y137.985 I.323 J-2.213 E.04284
; LINE_WIDTH: 0.62379
G1 X127.507 Y137.775 E.02549
; LINE_WIDTH: 0.613638
G1 X127.998 Y137.383 E.02921
; LINE_WIDTH: 0.606218
G1 X128.327 Y136.924 E.02594
G1 X128.517 Y136.43 E.02428
G1 X128.57 Y135.935 E.02286
; WIPE_START
G1 F6390.934
G1 X128.517 Y136.43 E-.18921
G1 X128.327 Y136.924 E-.20099
G1 X127.998 Y137.383 E-.21479
G1 X127.679 Y137.638 E-.15501
; WIPE_END
G1 E-.04 F1800
G1 X128.304 Y133.8 Z8.98 F42000
G1 Z8.58
G1 E.8 F1800
; LINE_WIDTH: 0.4699
G1 F1200
G1 X128.449 Y133.931 E.0068
; WIPE_START
G1 F8431.308
G1 X128.304 Y133.8 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.933 Y131.841 Z8.98 F42000
G1 Z8.58
G1 E.8 F1800
; LINE_WIDTH: 0.630496
G1 F1200
G1 X130.951 Y132.465 E.02989
; LINE_WIDTH: 0.646514
G1 X130.995 Y133.338 E.043
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.02533
G1 X131.218 Y134.637 E.03979
; LINE_WIDTH: 0.60127
G1 X131.31 Y134.865 E.01118
; LINE_WIDTH: 0.5732
G1 X131.401 Y135.093 E.01062
; WIPE_START
G1 F6788.866
G1 X131.31 Y134.865 E-.09339
G1 X131.218 Y134.637 E-.09339
G1 X131.045 Y133.849 E-.30655
G1 X130.995 Y133.338 E-.19515
G1 X130.985 Y133.15 E-.07152
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z8.98 F42000
G1 Z8.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530407
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 8.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.451
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 44/50
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
G17
G3 Z8.98 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z8.98
G1 Z8.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554835
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512866
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481433
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332805
G1 X131.067 Y131.41 E.02094
; LINE_WIDTH: 0.381754
G1 X131.044 Y131.482 E.00208
; LINE_WIDTH: 0.430703
G1 X131.022 Y131.554 E.00238
; LINE_WIDTH: 0.479652
G1 X131 Y131.626 E.00268
; LINE_WIDTH: 0.528601
G1 X130.978 Y131.697 E.00298
; LINE_WIDTH: 0.57755
G1 X130.955 Y131.769 E.00328
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00358
G1 X130.9 Y131.784 E.00311
; LINE_WIDTH: 0.587371
G1 X130.868 Y131.728 E.0029
; LINE_WIDTH: 0.548244
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509117
G1 X130.803 Y131.614 E.00249
; LINE_WIDTH: 0.469989
G1 X130.794 Y131.548 E.00233
; LINE_WIDTH: 0.424261
G1 X130.785 Y131.481 E.00208
; LINE_WIDTH: 0.378533
G1 X130.777 Y131.415 E.00183
; LINE_WIDTH: 0.332805
G1 X130.77 Y130.513 E.02131
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z9.18 F42000
G1 Z8.78
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X127.755 Y129.822 E.01657
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530836
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429702
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474411
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.51912
G1 X128.232 Y131.436 E.00321
; LINE_WIDTH: 0.563829
G1 X128.246 Y131.517 E.00352
; LINE_WIDTH: 0.608537
G1 X128.259 Y131.599 E.00382
; LINE_WIDTH: 0.628851
G1 X128.535 Y131.815 E.01673
G3 X128.602 Y132.46 I-26.721 J3.089 E.03098
G2 X128.462 Y132.632 I.168 J.28 E.01081
; LINE_WIDTH: 0.603485
G1 X128.46 Y132.741 E.00498
G1 X128.46 Y132.751 E.00043
; LINE_WIDTH: 0.561068
G1 X128.459 Y132.786 E.0015
G1 X128.458 Y132.869 E.0035
; LINE_WIDTH: 0.51865
G1 X128.456 Y132.988 E.00459
; LINE_WIDTH: 0.476233
G1 X128.455 Y133.106 E.00418
; LINE_WIDTH: 0.433815
G1 X128.454 Y133.114 E.00024
G1 X128.453 Y133.225 E.00354
; LINE_WIDTH: 0.419999
G1 X128.539 Y133.464 E.00783
G1 X128.833 Y133.712 E.01181
; LINE_WIDTH: 0.429365
G1 X128.88 Y134.22 E.01604
; LINE_WIDTH: 0.459986
G1 X128.89 Y134.472 E.00858
; LINE_WIDTH: 0.490606
G2 X128.955 Y135.232 I5.458 J-.091 E.02783
; LINE_WIDTH: 0.481209
G1 X128.994 Y135.521 E.01042
; LINE_WIDTH: 0.450604
G1 X129.032 Y135.81 E.00969
; LINE_WIDTH: 0.419999
G1 X128.999 Y136.412 E.01851
G3 X128.34 Y137.731 I-2.769 J-.558 E.04583
G1 X127.92 Y138.091 E.017
G1 X127.477 Y138.33 E.01548
G3 X126.63 Y138.539 I-1.273 J-3.327 E.02688
G1 X126.074 Y138.517 E.01709
G1 X125.539 Y138.377 E.017
G1 X125.045 Y138.127 E.017
G1 X124.616 Y137.778 E.017
G1 X124.3 Y137.383 E.01553
G1 X124.063 Y136.927 E.01581
G1 X123.98 Y136.669 E.00832
G1 X123.867 Y136.047 E.01943
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01656
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559983
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517855
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475727
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536823
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580638
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.4757
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517108
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558516
G2 X123.861 Y129.966 I-.64 J-.159 E.01437
; LINE_WIDTH: 0.511397
G1 X123.836 Y129.797 E.00651
; LINE_WIDTH: 0.464278
G1 X123.811 Y129.628 E.00586
; LINE_WIDTH: 0.417158
G1 X123.796 Y129.366 E.008
; LINE_WIDTH: 0.386639
G1 X123.78 Y129.104 E.00735
; LINE_WIDTH: 0.397974
G1 X123.801 Y128.598 E.01467
; LINE_WIDTH: 0.443231
G1 X123.823 Y128.445 E.00502
; LINE_WIDTH: 0.488487
G1 X123.846 Y128.293 E.00559
; LINE_WIDTH: 0.533743
G1 X123.868 Y128.141 E.00615
; LINE_WIDTH: 0.578999
G1 X123.891 Y127.989 E.00672
G1 X123.886 Y125.054 E.12819
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578999
G2 X124.427 Y128.103 I1666.474 J-4.335 E.13325
G2 X124.292 Y128.307 I.163 J.256 E.011
; LINE_WIDTH: 0.533743
G1 X124.244 Y128.42 E.00492
G1 X124.24 Y128.431 E.00045
; LINE_WIDTH: 0.488487
G1 X124.188 Y128.554 E.00487
; LINE_WIDTH: 0.443231
G1 X124.136 Y128.678 E.00438
; LINE_WIDTH: 0.397974
G1 X124.094 Y129.084 E.0118
; LINE_WIDTH: 0.397018
G1 X124.151 Y129.481 E.01159
; LINE_WIDTH: 0.444391
G1 X124.198 Y129.61 E.00447
; LINE_WIDTH: 0.491764
G1 X124.245 Y129.738 E.00499
; LINE_WIDTH: 0.539137
G1 X124.291 Y129.866 E.00552
; LINE_WIDTH: 0.565245
G1 X124.527 Y130.102 E.01418
G2 X124.358 Y130.326 I.157 J.294 E.01234
; LINE_WIDTH: 0.530147
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.495049
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560153
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518861
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477569
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441472
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559983
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.472 Y135.862 E.01328
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01115
G1 X124.814 Y136.471 E.01128
G1 X125.038 Y136.888 E.01454
G1 X125.396 Y137.255 E.01575
G1 X125.829 Y137.491 E.01516
G1 X126.235 Y137.577 E.01275
G1 X126.804 Y137.552 E.0175
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.078 Y136.266 E.01308
G1 X128.118 Y135.78 E.01498
G1 X128.286 Y135.559 E.00853
; LINE_WIDTH: 0.450604
G1 X128.368 Y135.369 E.00689
; LINE_WIDTH: 0.481209
G1 X128.451 Y135.179 E.0074
; LINE_WIDTH: 0.490606
G1 X128.453 Y134.755 E.01547
G1 X128.366 Y134.561 E.00775
; LINE_WIDTH: 0.459986
G1 X128.279 Y134.367 E.00722
; LINE_WIDTH: 0.429365
G1 X128.072 Y134.105 E.01053
; LINE_WIDTH: 0.419999
G1 X127.735 Y133.875 E.01252
G1 X127.846 Y133.766 E.00478
G1 X128.062 Y133.441 E.01199
G1 X128.12 Y133.197 E.0077
; LINE_WIDTH: 0.433815
G1 X128.14 Y133.077 E.00389
; LINE_WIDTH: 0.476233
G1 X128.158 Y132.969 E.00385
G1 X128.16 Y132.956 E.00047
; LINE_WIDTH: 0.51865
G1 X128.174 Y132.874 E.00323
G1 X128.18 Y132.836 E.0015
; LINE_WIDTH: 0.561068
G1 X128.185 Y132.808 E.00118
G1 X128.2 Y132.715 E.00398
; LINE_WIDTH: 0.603485
G1 X128.221 Y132.595 E.00558
; LINE_WIDTH: 0.628851
G1 X128.042 Y132.186 E.02129
G1 X127.88 Y132.019 E.01112
; LINE_WIDTH: 0.608537
G1 X127.631 Y131.827 E.01448
G1 X127.762 Y131.687 E.00881
G1 X127.779 Y131.62 E.00322
; LINE_WIDTH: 0.581404
G1 X127.797 Y131.552 E.00307
; LINE_WIDTH: 0.554271
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509991
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.46571
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500956
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.009 J-2.283 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.488 Y133.47 E.0007
G1 X130.501 Y133.248 E.00683
G2 X130.422 Y131.721 I-41.285 J1.376 E.04697
G1 X130.408 Y131.713 E.0005
G1 X130.364 Y131.688 E.00157
G1 X130.23 Y131.61 E.00474
G1 X130.378 Y131.492 E.00583
G1 X130.406 Y131.471 E.00107
G1 X130.447 Y131.36 E.00362
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06528
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06988
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z9.18 F42000
G1 Z8.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.537186
G1 F1200
G1 X124.454 Y136.736 E.01617
; LINE_WIDTH: 0.547646
G1 X124.741 Y137.229 E.02346
; LINE_WIDTH: 0.56784
G1 X125.164 Y137.643 E.02532
; LINE_WIDTH: 0.588244
G1 X125.619 Y137.901 E.02322
; LINE_WIDTH: 0.618246
G1 X126.143 Y138.042 E.02546
; LINE_WIDTH: 0.633452
G1 X126.617 Y138.05 E.02282
; LINE_WIDTH: 0.637614
G1 X127.227 Y137.906 E.03034
G1 X127.506 Y137.774 E.01499
; LINE_WIDTH: 0.612778
G1 X128.001 Y137.385 E.02921
G1 X128.342 Y136.906 E.02734
; LINE_WIDTH: 0.606134
G1 X128.517 Y136.429 E.02331
G1 X128.57 Y135.935 E.02278
; WIPE_START
G1 F6391.886
G1 X128.517 Y136.429 E-.18864
G1 X128.342 Y136.906 E-.19301
G1 X128.001 Y137.385 E-.22372
G1 X127.681 Y137.637 E-.15464
; WIPE_END
G1 E-.04 F1800
G1 X128.449 Y133.931 Z9.18 F42000
G1 Z8.78
G1 E.8 F1800
; LINE_WIDTH: 0.470284
G1 F1200
G1 X128.3 Y133.797 E.00697
; WIPE_START
G1 F8423.732
G1 X128.449 Y133.931 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z9.18 F42000
G1 Z8.78
G1 E.8 F1800
; LINE_WIDTH: 0.573201
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02987
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23707
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19074
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z9.18 F42000
G1 Z8.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590107
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530407
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 8.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.451
G1 X129.966 Y127.642 E-.76
; WIPE_END
M73 P95 R0
G1 E-.04 F1800
; layer num/total_layer_count: 45/50
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
G17
G3 Z9.18 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z9.18
G1 Z8.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596802
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554832
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512862
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351834
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332811
G1 X131.067 Y131.411 E.02095
; LINE_WIDTH: 0.381759
G1 X131.044 Y131.482 E.00207
; LINE_WIDTH: 0.430707
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479655
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528603
G1 X130.978 Y131.697 E.00297
; LINE_WIDTH: 0.577551
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.00311
; LINE_WIDTH: 0.587451
G1 X130.868 Y131.727 E.0029
; LINE_WIDTH: 0.548403
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509355
G1 X130.803 Y131.614 E.00248
; LINE_WIDTH: 0.470307
G1 X130.798 Y131.496 E.0041
; LINE_WIDTH: 0.424475
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378643
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332811
G1 X130.77 Y130.513 E.02132
; LINE_WIDTH: 0.350615
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382249
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z9.38 F42000
G1 Z8.98
G1 E.8 F1800
; LINE_WIDTH: 0.360701
G1 F1200
G1 X128.142 Y130.261 E.01166
G1 X128.12 Y130.35 E.00239
G1 X128.092 Y130.278 E.00201
G1 X127.755 Y129.822 E.01469
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530836
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429737
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474481
G1 X128.219 Y131.354 E.00291
; LINE_WIDTH: 0.519224
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.563968
G1 X128.246 Y131.518 E.00352
; LINE_WIDTH: 0.608711
G1 X128.259 Y131.599 E.00382
; LINE_WIDTH: 0.62872
G1 X128.535 Y131.815 E.01672
G3 X128.602 Y132.46 I-25.802 J2.996 E.03096
G1 X128.462 Y132.61 E.00978
; LINE_WIDTH: 0.622453
G1 X128.462 Y132.683 E.00343
; LINE_WIDTH: 0.578991
G1 X128.461 Y132.755 E.00317
; LINE_WIDTH: 0.535528
G1 X128.461 Y132.816 E.00242
G1 X128.461 Y132.828 E.0005
; LINE_WIDTH: 0.492065
G1 X128.46 Y132.872 E.00162
G1 X128.46 Y132.901 E.00104
; LINE_WIDTH: 0.448602
G1 X128.46 Y132.929 E.00094
G1 X128.46 Y132.973 E.00146
; LINE_WIDTH: 0.405139
G1 X128.459 Y133.046 E.00214
; LINE_WIDTH: 0.404449
G1 X128.467 Y133.136 E.00266
; LINE_WIDTH: 0.447222
G1 X128.475 Y133.226 E.00297
; LINE_WIDTH: 0.489995
G1 X128.483 Y133.316 E.00329
; LINE_WIDTH: 0.532768
G1 X128.488 Y133.382 E.00265
G1 X128.49 Y133.406 E.00095
; LINE_WIDTH: 0.575541
G1 X128.492 Y133.422 E.00073
G1 X128.498 Y133.496 E.00319
; LINE_WIDTH: 0.618313
G1 X128.506 Y133.585 E.00423
; LINE_WIDTH: 0.635439
G1 X128.718 Y133.771 E.01361
G2 X128.808 Y134.304 I2.175 J-.09 E.02618
; LINE_WIDTH: 0.589095
G1 X128.846 Y134.449 E.00665
; LINE_WIDTH: 0.542751
G1 X128.883 Y134.593 E.00609
; LINE_WIDTH: 0.505257
G2 X128.981 Y135.396 I4.702 J-.166 E.03051
; LINE_WIDTH: 0.462628
G1 X129.03 Y135.666 E.00938
; LINE_WIDTH: 0.419999
G1 X129.032 Y136.185 E.01594
G1 X128.907 Y136.789 E.01898
G1 X128.674 Y137.29 E.01695
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.477 Y138.329 E.01547
G1 X126.964 Y138.492 E.01654
G1 X126.348 Y138.542 E.01898
G1 X125.802 Y138.461 E.01695
G1 X125.285 Y138.265 E.017
G1 X124.86 Y137.99 E.01556
G1 X124.474 Y137.619 E.01645
G1 X124.134 Y137.103 E.01898
G1 X123.943 Y136.586 E.01695
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536823
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580639
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566568
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.864 Y129.986 I-.605 J-.155 E.01351
; LINE_WIDTH: 0.517863
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.477209
G1 X123.821 Y129.689 E.00531
; LINE_WIDTH: 0.436554
G1 X123.8 Y129.394 E.00948
; LINE_WIDTH: 0.396276
G1 X123.78 Y129.099 E.00851
; LINE_WIDTH: 0.398708
G1 X123.801 Y128.593 E.01468
; LINE_WIDTH: 0.443781
G1 X123.823 Y128.442 E.00499
; LINE_WIDTH: 0.488854
G1 X123.846 Y128.291 E.00555
; LINE_WIDTH: 0.533927
G1 X123.868 Y128.14 E.00612
; LINE_WIDTH: 0.578999
G1 X123.891 Y127.989 E.00668
G1 X123.886 Y125.054 E.12818
; LINE_WIDTH: 0.573606
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573606
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578999
G2 X124.427 Y128.103 I1659.937 J-4.312 E.13324
G2 X124.292 Y128.306 I.162 J.255 E.01096
; LINE_WIDTH: 0.533927
G1 X124.243 Y128.422 E.00504
G1 X124.24 Y128.429 E.0003
; LINE_WIDTH: 0.488854
G1 X124.189 Y128.552 E.00484
; LINE_WIDTH: 0.443781
G1 X124.137 Y128.674 E.00435
; LINE_WIDTH: 0.398708
G1 X124.094 Y129.078 E.01178
; LINE_WIDTH: 0.383456
G1 X124.132 Y129.41 E.00926
; LINE_WIDTH: 0.422692
G1 X124.172 Y129.525 E.00376
; LINE_WIDTH: 0.461928
G1 X124.212 Y129.639 E.00415
; LINE_WIDTH: 0.501164
G1 X124.253 Y129.754 E.00454
; LINE_WIDTH: 0.540399
G1 X124.293 Y129.869 E.00493
; LINE_WIDTH: 0.565162
G1 X124.527 Y130.102 E.01406
G2 X124.358 Y130.326 I.157 J.294 E.01234
; LINE_WIDTH: 0.530092
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.495022
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566568
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482599
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.804 Y137.552 E.01516
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01296
G1 X128.285 Y135.561 E.00848
; LINE_WIDTH: 0.461161
G1 X128.378 Y135.334 E.00834
; LINE_WIDTH: 0.502322
G1 X128.471 Y135.108 E.00916
; LINE_WIDTH: 0.549529
G1 X128.433 Y134.756 E.0146
; LINE_WIDTH: 0.596735
G1 X128.42 Y134.633 E.00559
G1 X128.396 Y134.405 E.01037
; LINE_WIDTH: 0.635439
G1 X128.214 Y134.114 E.01655
G1 X127.908 Y133.869 E.01895
; LINE_WIDTH: 0.618313
G1 X128.058 Y133.635 E.01302
G1 X128.07 Y133.546 E.00424
; LINE_WIDTH: 0.571392
G1 X128.082 Y133.456 E.00389
; LINE_WIDTH: 0.524471
G1 X128.091 Y133.388 E.00269
G1 X128.094 Y133.367 E.00085
; LINE_WIDTH: 0.47755
G1 X128.106 Y133.277 E.0032
; LINE_WIDTH: 0.430629
G1 X128.118 Y133.187 E.00285
; LINE_WIDTH: 0.431457
G1 X128.14 Y133.066 E.00391
; LINE_WIDTH: 0.479206
G1 X128.159 Y132.964 E.00369
G1 X128.162 Y132.945 E.0007
; LINE_WIDTH: 0.526955
G1 X128.177 Y132.865 E.00318
G1 X128.185 Y132.823 E.00168
; LINE_WIDTH: 0.574704
G1 X128.189 Y132.796 E.0012
G1 X128.207 Y132.702 E.00415
; LINE_WIDTH: 0.622453
G1 X128.229 Y132.581 E.00582
; LINE_WIDTH: 0.62872
G1 X128.048 Y132.194 E.02038
G1 X127.878 Y132.018 E.01168
; LINE_WIDTH: 0.608711
G1 X127.631 Y131.827 E.01439
G1 X127.761 Y131.688 E.00878
G1 X127.779 Y131.62 E.00324
; LINE_WIDTH: 0.581489
G1 X127.797 Y131.552 E.00308
; LINE_WIDTH: 0.554266
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509987
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.53879
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500954
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.044 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.514 Y133.73 E.03105
G1 X130.493 Y133.721 E.00068
G1 X130.445 Y133.699 E.00164
G1 X130.311 Y133.639 E.00449
G1 X130.448 Y133.508 E.00581
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.818 I27.164 J-1.755 E.04787
G1 X130.408 Y131.713 E.00352
G1 X130.368 Y131.69 E.00142
G1 X130.232 Y131.612 E.00481
M73 P96 R0
G1 X130.382 Y131.49 E.00594
G1 X130.406 Y131.471 E.00091
G1 X130.447 Y131.36 E.00363
G1 X130.443 Y130.518 E.02587
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02583
G1 X128.45 Y129.632 E-.00079
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.019
G1 X128.665 Y129.736 E-.06527
G1 X128.525 Y129.856 E-.06999
G1 X128.491 Y129.898 E-.02059
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X124.347 Y136.349 Z9.38 F42000
G1 Z8.98
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5305
G1 F1200
G1 X124.46 Y136.736 E.01601
; LINE_WIDTH: 0.547964
G1 X124.76 Y137.251 E.02453
; LINE_WIDTH: 0.580486
G1 X125.114 Y137.609 E.02207
; LINE_WIDTH: 0.604466
G1 X125.498 Y137.844 E.02061
; LINE_WIDTH: 0.617364
G1 X125.923 Y137.998 E.02114
; LINE_WIDTH: 0.621672
G1 X126.364 Y138.062 E.021
G1 X126.921 Y138.004 E.02643
; LINE_WIDTH: 0.61336
G1 X127.507 Y137.775 E.02924
; LINE_WIDTH: 0.618332
G1 X128.003 Y137.387 E.02953
G1 X128.356 Y136.869 E.02941
; LINE_WIDTH: 0.597956
G1 X128.531 Y136.35 E.02476
; LINE_WIDTH: 0.583444
G1 X128.57 Y135.936 E.01833
; WIPE_START
G1 F6660.204
G1 X128.531 Y136.35 E-.15813
G1 X128.356 Y136.869 E-.20805
G1 X128.003 Y137.387 E-.23831
G1 X127.681 Y137.639 E-.15551
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z9.38 F42000
G1 Z8.98
G1 E.8 F1800
; LINE_WIDTH: 0.573203
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648196
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23724
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19056
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z9.38 F42000
G1 Z8.98
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590106
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530408
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500911
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 9.18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F7860.425
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 46/50
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change
G17
G3 Z9.38 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z9.38
G1 Z9.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554835
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512865
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407988
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379911
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332819
G1 X131.067 Y131.411 E.02097
; LINE_WIDTH: 0.381766
G1 X131.044 Y131.483 E.00207
; LINE_WIDTH: 0.430712
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479659
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528605
G1 X130.978 Y131.698 E.00297
; LINE_WIDTH: 0.577552
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.0031
; LINE_WIDTH: 0.587493
G1 X130.868 Y131.728 E.0029
; LINE_WIDTH: 0.548488
G1 X130.836 Y131.671 E.00269
; LINE_WIDTH: 0.509483
G1 X130.803 Y131.615 E.00248
; LINE_WIDTH: 0.470477
G1 X130.799 Y131.497 E.0041
; LINE_WIDTH: 0.424591
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378705
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332819
G1 X130.77 Y130.513 E.02133
; LINE_WIDTH: 0.350615
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382248
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z9.58 F42000
G1 Z9.18
G1 E.8 F1800
; LINE_WIDTH: 0.3607
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X127.755 Y129.822 E.01657
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530838
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429771
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474549
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519327
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564105
G1 X128.246 Y131.518 E.00352
; LINE_WIDTH: 0.608883
G1 X128.259 Y131.599 E.00382
; LINE_WIDTH: 0.628637
G1 X128.535 Y131.815 E.01671
G3 X128.602 Y132.46 I-25.158 J2.931 E.03094
G1 X128.475 Y132.581 E.0084
G1 X128.461 Y132.645 E.00311
; LINE_WIDTH: 0.596515
G1 X128.447 Y132.709 E.00294
; LINE_WIDTH: 0.564392
G1 X128.449 Y132.778 E.00293
; LINE_WIDTH: 0.523928
G1 X128.452 Y132.847 E.00271
; LINE_WIDTH: 0.483463
G1 X128.454 Y132.902 E.00197
G1 X128.454 Y132.916 E.00051
; LINE_WIDTH: 0.442998
G1 X128.457 Y132.974 E.00191
G1 X128.457 Y132.985 E.00034
; LINE_WIDTH: 0.402533
G1 X128.459 Y133.054 E.00202
; LINE_WIDTH: 0.404737
G1 X128.467 Y133.143 E.00263
; LINE_WIDTH: 0.447406
G1 X128.475 Y133.231 E.00294
; LINE_WIDTH: 0.490075
G1 X128.483 Y133.32 E.00325
; LINE_WIDTH: 0.532744
G1 X128.489 Y133.383 E.00252
G1 X128.491 Y133.409 E.00104
; LINE_WIDTH: 0.575413
G1 X128.492 Y133.423 E.00061
G1 X128.499 Y133.498 E.00325
; LINE_WIDTH: 0.618082
G1 X128.507 Y133.587 E.00418
; LINE_WIDTH: 0.635422
G1 X128.72 Y133.772 E.01364
G2 X128.808 Y134.302 I2.159 J-.084 E.026
; LINE_WIDTH: 0.588982
G1 X128.846 Y134.45 E.00682
; LINE_WIDTH: 0.542542
G1 X128.884 Y134.598 E.00624
; LINE_WIDTH: 0.505651
G2 X128.982 Y135.407 I4.801 J-.173 E.03076
; LINE_WIDTH: 0.462825
G1 X129.032 Y135.685 E.00966
; LINE_WIDTH: 0.419999
G1 X129.031 Y136.196 E.01571
G1 X128.907 Y136.789 E.01862
G1 X128.674 Y137.29 E.01696
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.01701
G1 X126.952 Y138.494 E.01538
G1 X126.348 Y138.542 E.01862
G1 X125.802 Y138.461 E.01696
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.01701
G1 X124.466 Y137.61 E.01538
G1 X124.134 Y137.104 E.01862
G1 X123.943 Y136.586 E.01696
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445316
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536823
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580639
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566565
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523623
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.864 Y129.986 I-.604 J-.155 E.01351
; LINE_WIDTH: 0.517813
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.477108
G1 X123.821 Y129.689 E.00531
; LINE_WIDTH: 0.436402
G1 X123.8 Y129.392 E.00955
; LINE_WIDTH: 0.396139
G1 X123.78 Y129.094 E.00858
; LINE_WIDTH: 0.399444
G1 X123.801 Y128.589 E.0147
; LINE_WIDTH: 0.444333
G1 X123.824 Y128.439 E.00497
; LINE_WIDTH: 0.489221
G1 X123.846 Y128.289 E.00552
; LINE_WIDTH: 0.53411
G1 X123.868 Y128.138 E.00608
; LINE_WIDTH: 0.578998
G1 X123.891 Y127.988 E.00663
G1 X123.886 Y125.055 E.12814
; LINE_WIDTH: 0.573607
G1 X123.906 Y120.723 E.18735
; LINE_WIDTH: 0.547776
G1 X123.936 Y117.89 E.11653
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01005
; LINE_WIDTH: 0.547776
G1 X124.41 Y120.723 E.11644
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.18726
; LINE_WIDTH: 0.578998
G2 X124.427 Y128.103 I1651.92 J-4.284 E.13321
G2 X124.292 Y128.305 I.161 J.255 E.01093
; LINE_WIDTH: 0.53411
G1 X124.242 Y128.423 E.00515
G1 X124.241 Y128.427 E.00014
; LINE_WIDTH: 0.489221
G1 X124.189 Y128.549 E.00481
; LINE_WIDTH: 0.444333
G1 X124.138 Y128.671 E.00433
; LINE_WIDTH: 0.399444
G1 X124.094 Y129.073 E.01175
; LINE_WIDTH: 0.384078
G1 X124.133 Y129.414 E.00955
; LINE_WIDTH: 0.423477
G1 X124.173 Y129.528 E.00376
; LINE_WIDTH: 0.462876
G1 X124.214 Y129.643 E.00415
; LINE_WIDTH: 0.502275
G1 X124.254 Y129.757 E.00454
; LINE_WIDTH: 0.541673
G1 X124.294 Y129.872 E.00493
; LINE_WIDTH: 0.565077
G1 X124.528 Y130.101 E.01393
G2 X124.358 Y130.326 I.157 J.295 E.01235
; LINE_WIDTH: 0.530035
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.494993
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523623
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566565
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518862
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.47757
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445316
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.804 Y137.552 E.01516
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.78 E.01295
G1 X128.284 Y135.562 E.00843
; LINE_WIDTH: 0.461391
G1 X128.378 Y135.337 E.00831
; LINE_WIDTH: 0.502783
G1 X128.471 Y135.112 E.00913
; LINE_WIDTH: 0.55131
G1 X128.44 Y134.826 E.01193
G1 X128.437 Y134.798 E.00118
G1 X128.433 Y134.757 E.00171
; LINE_WIDTH: 0.599837
G1 X128.419 Y134.625 E.00599
G1 X128.395 Y134.401 E.01025
; LINE_WIDTH: 0.635422
G1 X128.215 Y134.115 E.01631
G1 X127.906 Y133.868 E.01908
; LINE_WIDTH: 0.618082
G1 X128.058 Y133.635 E.01305
G1 X128.071 Y133.543 E.00431
; LINE_WIDTH: 0.570828
G1 X128.083 Y133.452 E.00396
; LINE_WIDTH: 0.523573
G1 X128.092 Y133.383 E.00272
G1 X128.095 Y133.361 E.00088
; LINE_WIDTH: 0.476319
G1 X128.107 Y133.272 E.00316
G1 X128.107 Y133.27 E.0001
; LINE_WIDTH: 0.429064
G1 X128.12 Y133.178 E.0029
; LINE_WIDTH: 0.431175
G1 X128.143 Y133.061 E.00377
; LINE_WIDTH: 0.480541
G1 X128.159 Y132.978 E.00302
G1 X128.166 Y132.945 E.00123
; LINE_WIDTH: 0.529906
G1 X128.178 Y132.884 E.00243
G1 X128.189 Y132.828 E.0023
; LINE_WIDTH: 0.579272
G1 X128.193 Y132.81 E.00077
G1 X128.213 Y132.711 E.00444
; LINE_WIDTH: 0.628637
G1 X128.236 Y132.594 E.00569
G1 X128.056 Y132.208 E.02029
G1 X127.877 Y132.017 E.01254
; LINE_WIDTH: 0.608883
G1 X127.632 Y131.827 E.0143
G1 X127.761 Y131.688 E.00874
G1 X127.779 Y131.62 E.00325
; LINE_WIDTH: 0.581577
G1 X127.797 Y131.552 E.00309
; LINE_WIDTH: 0.55427
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500956
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460478
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.04 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.298 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.451 Y133.701 E.00144
G1 X130.311 Y133.639 E.00469
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.819 I27.164 J-1.755 E.04787
G1 X130.408 Y131.713 E.00352
G1 X130.362 Y131.686 E.00162
G1 X130.234 Y131.613 E.00454
G1 X130.381 Y131.492 E.00583
G1 X130.406 Y131.472 E.00098
G1 X130.447 Y131.361 E.00364
G1 X130.443 Y130.518 E.02589
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00211
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512393
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.55859
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604786
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565557
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.146
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01704
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X128.57 Y135.928 Z9.58 F42000
G1 Z9.18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.582712
G1 F1200
G1 X128.532 Y136.35 E.01862
; LINE_WIDTH: 0.597956
G1 X128.356 Y136.869 E.02476
; LINE_WIDTH: 0.618332
G1 X128.003 Y137.387 E.02941
G1 X127.507 Y137.775 E.02953
; LINE_WIDTH: 0.613358
G1 X126.922 Y138.005 E.02924
; LINE_WIDTH: 0.621868
G1 X126.365 Y138.062 E.0264
G1 X125.923 Y137.998 E.02105
; LINE_WIDTH: 0.617362
G1 X125.498 Y137.844 E.02114
; LINE_WIDTH: 0.604468
G1 X125.114 Y137.609 E.02062
; LINE_WIDTH: 0.5805
G1 X124.759 Y137.251 E.02209
; LINE_WIDTH: 0.549166
G1 X124.46 Y136.736 E.02457
; LINE_WIDTH: 0.5305
G1 X124.347 Y136.349 E.01601
; WIPE_START
G1 F7383.404
G1 X124.46 Y136.736 E-.15308
G1 X124.759 Y137.251 E-.22629
G1 X125.114 Y137.609 E-.19166
G1 X125.498 Y137.844 E-.1712
G1 X125.542 Y137.86 E-.01777
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z9.58 F42000
G1 Z9.18
G1 E.8 F1800
; LINE_WIDTH: 0.573198
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601266
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648176
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.04299
; LINE_WIDTH: 0.6305
G1 X130.933 Y131.841 E.02989
; WIPE_START
G1 F6126.825
G1 X130.951 Y132.465 E-.23725
G1 X130.995 Y133.338 E-.33212
G1 X131.044 Y133.837 E-.19063
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z9.58 F42000
G1 Z9.18
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590109
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586815
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559041
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530405
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500907
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 9.38
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.485
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 47/50
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change
G17
G3 Z9.58 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z9.58
G1 Z9.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638773
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554833
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512863
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481431
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.37991
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332817
G1 X131.067 Y131.411 E.02096
; LINE_WIDTH: 0.381764
G1 X131.044 Y131.483 E.00207
; LINE_WIDTH: 0.43071
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479657
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528603
G1 X130.978 Y131.698 E.00297
; LINE_WIDTH: 0.57755
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.0031
; LINE_WIDTH: 0.587482
G1 X130.868 Y131.728 E.0029
; LINE_WIDTH: 0.548467
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509453
G1 X130.803 Y131.615 E.00248
; LINE_WIDTH: 0.470438
G1 X130.799 Y131.497 E.0041
; LINE_WIDTH: 0.424565
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378691
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332817
G1 X130.77 Y130.513 E.02133
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.59158
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638773
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.759
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z9.78 F42000
G1 Z9.38
G1 E.8 F1800
; LINE_WIDTH: 0.360699
G1 F1200
G1 X128.129 Y130.341 E.01374
G1 X127.755 Y129.822 E.01657
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530838
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493892
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456946
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429805
G1 X128.205 Y131.272 E.00261
; LINE_WIDTH: 0.474617
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519429
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564241
G1 X128.246 Y131.518 E.00352
; LINE_WIDTH: 0.609053
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.628602
G1 X128.535 Y131.815 E.01671
G3 X128.602 Y132.459 I-24.883 J2.903 E.03092
G1 X128.477 Y132.578 E.00824
G1 X128.462 Y132.641 E.00309
; LINE_WIDTH: 0.598501
G1 X128.447 Y132.704 E.00294
; LINE_WIDTH: 0.5684
G1 X128.449 Y132.776 E.00306
; LINE_WIDTH: 0.527187
G1 X128.452 Y132.847 E.00282
; LINE_WIDTH: 0.485974
G1 X128.454 Y132.898 E.00184
G1 X128.454 Y132.919 E.00074
; LINE_WIDTH: 0.444761
G1 X128.456 Y132.973 E.00178
G1 X128.457 Y132.99 E.00055
; LINE_WIDTH: 0.403548
G1 X128.459 Y133.061 E.0021
; LINE_WIDTH: 0.404923
G1 X128.467 Y133.149 E.0026
; LINE_WIDTH: 0.447511
G1 X128.475 Y133.237 E.00291
; LINE_WIDTH: 0.490099
G1 X128.483 Y133.325 E.00321
; LINE_WIDTH: 0.532687
G1 X128.489 Y133.384 E.00239
G1 X128.491 Y133.412 E.00112
; LINE_WIDTH: 0.575275
G1 X128.493 Y133.424 E.00051
G1 X128.499 Y133.5 E.00332
; LINE_WIDTH: 0.617863
G1 X128.507 Y133.588 E.00413
; LINE_WIDTH: 0.635386
G1 X128.722 Y133.773 E.01367
G2 X128.807 Y134.3 I2.142 J-.078 E.02583
; LINE_WIDTH: 0.588835
G1 X128.846 Y134.452 E.00699
; LINE_WIDTH: 0.542284
G1 X128.885 Y134.604 E.00639
; LINE_WIDTH: 0.506047
G2 X128.982 Y135.409 I4.689 J-.16 E.03063
; LINE_WIDTH: 0.463023
G1 X129.032 Y135.685 E.0096
; LINE_WIDTH: 0.419999
G1 X129.031 Y136.208 E.01607
G1 X128.907 Y136.789 E.01826
G1 X128.674 Y137.29 E.01697
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.01701
G1 X126.941 Y138.497 E.01574
G1 X126.349 Y138.542 E.01826
G1 X125.802 Y138.461 E.01697
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.01701
G1 X124.459 Y137.602 E.01574
G1 X124.134 Y137.104 E.01826
G1 X123.943 Y136.586 E.01697
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566567
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523625
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437739
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.864 Y129.986 I-.604 J-.155 E.01351
; LINE_WIDTH: 0.517758
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.476998
G1 X123.821 Y129.689 E.00531
; LINE_WIDTH: 0.436238
G1 X123.8 Y129.389 E.00964
; LINE_WIDTH: 0.395981
G1 X123.78 Y129.089 E.00865
; LINE_WIDTH: 0.400185
G1 X123.802 Y128.585 E.01469
; LINE_WIDTH: 0.444888
G1 X123.824 Y128.436 E.00494
; LINE_WIDTH: 0.489591
G1 X123.846 Y128.286 E.00549
; LINE_WIDTH: 0.534294
G1 X123.868 Y128.137 E.00604
; LINE_WIDTH: 0.578997
G1 X123.891 Y127.988 E.00659
G1 X123.886 Y125.055 E.12813
; LINE_WIDTH: 0.573607
G1 X123.905 Y120.743 E.18648
; LINE_WIDTH: 0.547953
G1 X123.936 Y117.89 E.11739
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00943
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.893 E.01005
; LINE_WIDTH: 0.547953
G1 X124.41 Y120.743 E.1173
; LINE_WIDTH: 0.573607
G1 X124.417 Y125.054 E.18639
; LINE_WIDTH: 0.578997
G2 X124.427 Y128.103 I1661.708 J-4.318 E.1332
G2 X124.292 Y128.304 I.16 J.254 E.01089
; LINE_WIDTH: 0.534294
G1 X124.241 Y128.425 E.00526
; LINE_WIDTH: 0.489591
G1 X124.19 Y128.546 E.00478
; LINE_WIDTH: 0.444888
G1 X124.139 Y128.667 E.0043
; LINE_WIDTH: 0.400185
G1 X124.093 Y129.066 E.01171
; LINE_WIDTH: 0.384654
G1 X124.134 Y129.418 E.00984
; LINE_WIDTH: 0.424228
G1 X124.174 Y129.532 E.00377
; LINE_WIDTH: 0.463801
G1 X124.215 Y129.646 E.00416
; LINE_WIDTH: 0.503374
G1 X124.255 Y129.76 E.00455
; LINE_WIDTH: 0.542947
G1 X124.296 Y129.875 E.00494
; LINE_WIDTH: 0.564991
G1 X124.528 Y130.101 E.01381
G2 X124.358 Y130.326 I.157 J.295 E.01235
; LINE_WIDTH: 0.529978
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.494965
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.459951
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437739
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523625
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566567
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518863
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477572
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441474
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553523
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518061
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.482598
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451187
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.804 Y137.552 E.01516
G1 X127.264 Y137.373 E.01516
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.781 E.01295
G1 X128.283 Y135.564 E.00837
; LINE_WIDTH: 0.450585
G1 X128.366 Y135.377 E.00679
; LINE_WIDTH: 0.481171
G1 X128.449 Y135.19 E.0073
; LINE_WIDTH: 0.489907
G1 X128.456 Y134.773 E.0152
; LINE_WIDTH: 0.5384
G1 X128.426 Y134.618 E.00637
; LINE_WIDTH: 0.586893
G1 X128.395 Y134.463 E.00699
; LINE_WIDTH: 0.635386
G1 X128.365 Y134.309 E.00761
G1 X128.149 Y134.04 E.01663
; LINE_WIDTH: 0.623346
G1 X127.905 Y133.867 E.01415
; LINE_WIDTH: 0.617863
G1 X128.059 Y133.634 E.01307
G1 X128.071 Y133.541 E.00439
; LINE_WIDTH: 0.57027
G1 X128.084 Y133.448 E.00403
; LINE_WIDTH: 0.522677
G1 X128.093 Y133.379 E.00275
G1 X128.096 Y133.355 E.00092
; LINE_WIDTH: 0.475084
G1 X128.108 Y133.269 E.00305
G1 X128.108 Y133.262 E.00025
; LINE_WIDTH: 0.427491
G1 X128.121 Y133.17 E.00294
; LINE_WIDTH: 0.429639
G1 X128.144 Y133.054 E.00373
; LINE_WIDTH: 0.47938
G1 X128.159 Y132.978 E.00275
G1 X128.167 Y132.938 E.00145
; LINE_WIDTH: 0.529121
G1 X128.178 Y132.882 E.00224
G1 X128.189 Y132.822 E.00244
; LINE_WIDTH: 0.578862
G1 X128.193 Y132.806 E.0007
G1 X128.212 Y132.706 E.00447
; LINE_WIDTH: 0.628602
G1 X128.235 Y132.59 E.00564
G1 X128.061 Y132.215 E.01971
G1 X127.875 Y132.016 E.01301
; LINE_WIDTH: 0.609053
G1 X127.632 Y131.826 E.01422
G1 X127.761 Y131.689 E.00871
G1 X127.779 Y131.62 E.00326
; LINE_WIDTH: 0.581662
G1 X127.797 Y131.552 E.0031
; LINE_WIDTH: 0.55427
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576626
M73 P97 R0
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538791
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500955
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460477
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.036 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.819 I27.161 J-1.754 E.04787
G1 X130.408 Y131.713 E.00352
G1 X130.363 Y131.687 E.0016
G1 X130.229 Y131.611 E.00471
G1 X130.377 Y131.494 E.0058
G1 X130.406 Y131.471 E.00112
G1 X130.447 Y131.361 E.00363
G1 X130.443 Y130.518 E.02589
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00323
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600277
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565558
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.14
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.0008
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01898
G1 X128.665 Y129.736 E-.0653
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04677
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X128.571 Y135.929 Z9.78 F42000
G1 Z9.38
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.585164
G1 F1200
G1 X128.532 Y136.35 E.01868
; LINE_WIDTH: 0.597956
G1 X128.356 Y136.869 E.02476
; LINE_WIDTH: 0.61833
G1 X128.003 Y137.387 E.02941
G1 X127.507 Y137.775 E.02953
; LINE_WIDTH: 0.613358
G1 X126.922 Y138.006 E.02924
; LINE_WIDTH: 0.622078
G1 X126.366 Y138.062 E.02638
G1 X125.923 Y137.998 E.0211
; LINE_WIDTH: 0.617362
G1 X125.498 Y137.844 E.02114
; LINE_WIDTH: 0.604468
G1 X125.114 Y137.609 E.02062
; LINE_WIDTH: 0.580518
G1 X124.758 Y137.251 E.02212
; LINE_WIDTH: 0.550404
G1 X124.46 Y136.736 E.02461
; LINE_WIDTH: 0.5305
G1 X124.347 Y136.349 E.016
; WIPE_START
G1 F7383.404
G1 X124.46 Y136.736 E-.15304
G1 X124.758 Y137.251 E-.22612
G1 X125.114 Y137.609 E-.1919
G1 X125.498 Y137.844 E-.17124
G1 X125.542 Y137.86 E-.0177
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z9.78 F42000
G1 Z9.38
G1 E.8 F1800
; LINE_WIDTH: 0.573202
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601272
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02988
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23715
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19066
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z9.78 F42000
G1 Z9.38
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586814
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559042
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530407
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500909
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 9.58
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.451
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 48/50
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change
G17
G3 Z9.78 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z9.78
G1 Z9.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638774
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596804
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01691
G3 X130.616 Y127.656 I-.545 J1.684 E.03469
G1 X130.788 Y127.965 E.01173
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407987
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.37991
G1 X131.003 Y129.667 E.01195
; LINE_WIDTH: 0.351833
G1 X131.046 Y130.524 E.0216
; LINE_WIDTH: 0.332816
G1 X131.067 Y131.411 E.02096
; LINE_WIDTH: 0.381763
G1 X131.044 Y131.483 E.00207
; LINE_WIDTH: 0.43071
G1 X131.022 Y131.554 E.00237
; LINE_WIDTH: 0.479656
G1 X131 Y131.626 E.00267
; LINE_WIDTH: 0.528603
G1 X130.978 Y131.698 E.00297
; LINE_WIDTH: 0.57755
G1 X130.955 Y131.769 E.00327
; LINE_WIDTH: 0.626496
G1 X130.933 Y131.841 E.00357
G1 X130.901 Y131.784 E.0031
; LINE_WIDTH: 0.587474
G1 X130.868 Y131.728 E.0029
; LINE_WIDTH: 0.548451
G1 X130.835 Y131.671 E.00269
; LINE_WIDTH: 0.509428
G1 X130.803 Y131.615 E.00248
; LINE_WIDTH: 0.470405
G1 X130.799 Y131.497 E.00411
; LINE_WIDTH: 0.424542
G1 X130.788 Y131.456 E.00131
; LINE_WIDTH: 0.378679
G1 X130.777 Y131.415 E.00115
; LINE_WIDTH: 0.332816
G1 X130.77 Y130.513 E.02133
; LINE_WIDTH: 0.350614
G1 X130.712 Y130.021 E.0124
; LINE_WIDTH: 0.382247
G3 X130.657 Y129.312 I2.668 J-.563 E.01974
; LINE_WIDTH: 0.397354
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424405
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544387
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591581
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638774
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.749
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.141 Y129.811 Z9.98 F42000
G1 Z9.58
G1 E.8 F1800
; LINE_WIDTH: 0.360701
G1 F1200
G1 X128.145 Y130.317 E.01311
G1 X128.129 Y130.341 E.00076
G1 X127.755 Y129.822 E.01657
G1 X127.998 Y129.546 E.00953
G1 X128.113 Y129.758 E.00623
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530836
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493891
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456945
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429839
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474685
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.51953
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564376
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609221
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.628616
G1 X128.535 Y131.815 E.0167
G3 X128.602 Y132.459 I-25.046 J2.919 E.0309
G1 X128.465 Y132.6 E.00937
G1 X128.464 Y132.679 E.00376
; LINE_WIDTH: 0.58397
G1 X128.462 Y132.753 E.00329
G1 X128.462 Y132.758 E.00019
; LINE_WIDTH: 0.539324
G1 X128.461 Y132.81 E.00212
G1 X128.461 Y132.836 E.00106
; LINE_WIDTH: 0.494678
G1 X128.46 Y132.867 E.00112
G1 X128.46 Y132.915 E.00178
; LINE_WIDTH: 0.450032
G1 X128.459 Y132.938 E.00074
G1 X128.458 Y132.994 E.00187
; LINE_WIDTH: 0.405386
G1 X128.457 Y133.073 E.00233
; LINE_WIDTH: 0.40356
G1 X128.465 Y133.159 E.00254
; LINE_WIDTH: 0.446379
G1 X128.474 Y133.245 E.00284
; LINE_WIDTH: 0.489198
G1 X128.482 Y133.329 E.00309
G1 X128.482 Y133.331 E.00006
; LINE_WIDTH: 0.532018
G1 X128.488 Y133.383 E.00207
G1 X128.491 Y133.417 E.00138
; LINE_WIDTH: 0.574837
G1 X128.492 Y133.423 E.00024
G1 X128.5 Y133.503 E.0035
; LINE_WIDTH: 0.617656
G1 X128.508 Y133.589 E.00405
; LINE_WIDTH: 0.635326
G1 X128.724 Y133.774 E.0137
G2 X128.807 Y134.297 I2.117 J-.07 E.02565
; LINE_WIDTH: 0.588693
G1 X128.846 Y134.453 E.00715
; LINE_WIDTH: 0.542059
G1 X128.886 Y134.609 E.00654
; LINE_WIDTH: 0.506442
G2 X128.983 Y135.41 I4.587 J-.149 E.03052
; LINE_WIDTH: 0.463221
G1 X129.032 Y135.685 E.00955
; LINE_WIDTH: 0.419999
G1 X129.03 Y136.219 E.01643
G1 X128.907 Y136.789 E.0179
G1 X128.674 Y137.29 E.01698
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.01701
G1 X126.93 Y138.499 E.0161
G1 X126.349 Y138.543 E.0179
G1 X125.802 Y138.461 E.01698
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.01701
G1 X124.451 Y137.593 E.0161
G1 X124.134 Y137.104 E.0179
G1 X123.943 Y136.586 E.01697
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454699
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489794
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.524889
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.433599
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449191
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493006
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536822
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580637
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566566
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523624
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480681
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.517109
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558517
G2 X123.864 Y129.986 I-.603 J-.154 E.01351
; LINE_WIDTH: 0.517696
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.476874
G1 X123.82 Y129.689 E.00531
; LINE_WIDTH: 0.436052
G1 X123.8 Y129.386 E.00972
; LINE_WIDTH: 0.395826
G1 X123.78 Y129.084 E.00872
; LINE_WIDTH: 0.400928
G1 X123.802 Y128.58 E.01471
; LINE_WIDTH: 0.445446
G1 X123.824 Y128.432 E.00491
; LINE_WIDTH: 0.489963
G1 X123.846 Y128.284 E.00546
; LINE_WIDTH: 0.53448
G1 X123.869 Y128.136 E.006
; LINE_WIDTH: 0.578997
G1 X123.891 Y127.988 E.00654
G1 X123.886 Y125.054 E.12814
; LINE_WIDTH: 0.573605
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573605
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578997
G2 X124.427 Y128.103 I1655.716 J-4.297 E.13322
G2 X124.292 Y128.303 I.159 J.254 E.01086
; LINE_WIDTH: 0.53448
G1 X124.241 Y128.423 E.00522
; LINE_WIDTH: 0.489963
G1 X124.19 Y128.543 E.00475
; LINE_WIDTH: 0.445446
G1 X124.14 Y128.663 E.00428
; LINE_WIDTH: 0.400928
G1 X124.093 Y129.061 E.01168
; LINE_WIDTH: 0.385288
G1 X124.135 Y129.422 E.01014
; LINE_WIDTH: 0.425027
G1 X124.175 Y129.536 E.00377
; LINE_WIDTH: 0.464765
G1 X124.216 Y129.649 E.00416
; LINE_WIDTH: 0.504503
G1 X124.256 Y129.763 E.00455
; LINE_WIDTH: 0.544241
G1 X124.297 Y129.877 E.00494
; LINE_WIDTH: 0.564901
G1 X124.528 Y130.101 E.01368
G2 X124.358 Y130.326 I.158 J.295 E.01236
; LINE_WIDTH: 0.529918
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.494934
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431526
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480681
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523624
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566566
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601445
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560154
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.518863
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477571
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441473
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464392
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512188
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588986
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518062
G1 X124.293 Y134.666 E.00579
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451189
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.798 Y137.553 E.01499
G1 X127.264 Y137.373 E.01533
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.781 E.01295
G1 X128.282 Y135.566 E.00832
; LINE_WIDTH: 0.450577
G1 X128.365 Y135.38 E.00676
; LINE_WIDTH: 0.481154
G1 X128.448 Y135.194 E.00726
; LINE_WIDTH: 0.489693
G1 X128.457 Y134.779 E.01512
; LINE_WIDTH: 0.538238
G1 X128.426 Y134.621 E.00651
; LINE_WIDTH: 0.586782
G1 X128.394 Y134.462 E.00715
; LINE_WIDTH: 0.635326
G1 X128.362 Y134.304 E.00779
G1 X128.146 Y134.038 E.01655
; LINE_WIDTH: 0.622686
G1 X127.904 Y133.866 E.01405
; LINE_WIDTH: 0.617656
G1 X128.059 Y133.634 E.01309
G1 X128.073 Y133.532 E.00481
; LINE_WIDTH: 0.568239
G1 X128.084 Y133.443 E.00384
G1 X128.086 Y133.43 E.00056
; LINE_WIDTH: 0.518822
G1 X128.094 Y133.368 E.00243
G1 X128.1 Y133.328 E.00155
; LINE_WIDTH: 0.469405
G1 X128.109 Y133.257 E.00249
G1 X128.113 Y133.227 E.00108
; LINE_WIDTH: 0.419988
G1 X128.127 Y133.125 E.00315
; LINE_WIDTH: 0.413579
G1 X128.145 Y133.035 E.00277
; LINE_WIDTH: 0.456586
G1 X128.146 Y133.027 E.00029
G1 X128.163 Y132.945 E.0028
; LINE_WIDTH: 0.499594
G1 X128.166 Y132.928 E.00064
G1 X128.181 Y132.855 E.00277
; LINE_WIDTH: 0.542601
G1 X128.182 Y132.847 E.00032
G1 X128.199 Y132.765 E.00341
; LINE_WIDTH: 0.585609
G1 X128.216 Y132.676 E.00405
; LINE_WIDTH: 0.628616
G1 X128.234 Y132.586 E.00437
G1 X128.066 Y132.222 E.01914
G1 X127.874 Y132.015 E.01349
; LINE_WIDTH: 0.609221
G1 X127.632 Y131.826 E.01414
G1 X127.761 Y131.689 E.00867
G1 X127.779 Y131.621 E.00327
; LINE_WIDTH: 0.581746
G1 X127.797 Y131.552 E.00312
; LINE_WIDTH: 0.55427
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421429
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562269
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609692
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538789
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500953
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460476
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.137 Y126.771 E.01419
G1 X130.502 Y126.984 E.01298
G1 X130.867 Y127.329 E.01545
G1 X131.116 Y127.724 E.01432
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.042 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.819 I27.163 J-1.754 E.04787
G1 X130.408 Y131.713 E.00352
G1 X130.362 Y131.687 E.00161
G1 X130.229 Y131.612 E.0047
G1 X130.377 Y131.494 E.00581
G1 X130.406 Y131.471 E.00111
G1 X130.447 Y131.361 E.00363
G1 X130.443 Y130.518 E.02589
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.656 Y128.4 E.01205
G1 X129.275 Y128.354 E.01182
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558588
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604784
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565556
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.159
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02582
G1 X128.45 Y129.632 E-.00081
G1 X128.465 Y129.64 E-.00626
G1 X128.51 Y129.661 E-.01899
G1 X128.665 Y129.736 E-.06529
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06986
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z9.98 F42000
G1 Z9.58
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.573205
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601274
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646516
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02988
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23712
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19068
; WIPE_END
G1 E-.04 F1800
G1 X128.571 Y135.93 Z9.98 F42000
G1 Z9.58
G1 E.8 F1800
; LINE_WIDTH: 0.599622
G1 F1200
G1 X128.563 Y136.169 E.01085
; LINE_WIDTH: 0.621074
G1 X128.451 Y136.636 E.02262
; LINE_WIDTH: 0.625284
G1 X128.261 Y137.041 E.02125
G1 X127.944 Y137.445 E.02437
; LINE_WIDTH: 0.615308
G1 X127.434 Y137.815 E.02937
; LINE_WIDTH: 0.61984
G1 X126.816 Y138.03 E.03075
G1 X126.22 Y138.051 E.02805
; LINE_WIDTH: 0.600726
G1 X125.658 Y137.916 E.02624
; LINE_WIDTH: 0.583736
G1 X125.112 Y137.608 E.02766
; LINE_WIDTH: 0.580992
G1 X124.719 Y137.197 E.02492
; LINE_WIDTH: 0.546344
G1 X124.459 Y136.736 E.0217
; LINE_WIDTH: 0.530456
G1 X124.347 Y136.349 E.01601
; WIPE_START
G1 F7384.07
G1 X124.459 Y136.736 E-.15309
G1 X124.719 Y137.197 E-.20102
G1 X125.112 Y137.608 E-.21597
G1 X125.547 Y137.853 E-.18992
; WIPE_END
G1 E-.04 F1800
G1 X127.963 Y130.613 Z9.98 F42000
G1 X128.986 Y127.549 Z9.98
G1 Z9.58
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586816
G1 X129.614 Y127.537 E.01156
; LINE_WIDTH: 0.559043
G1 X129.87 Y127.588 E.01097
; LINE_WIDTH: 0.530408
G1 X129.966 Y127.642 E.0044
; LINE_WIDTH: 0.500911
G1 X130.063 Y127.696 E.00413
; CHANGE_LAYER
; Z_HEIGHT: 9.78
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7860.425
G1 X129.966 Y127.642 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 49/50
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change
G17
G3 Z9.98 I-.506 J-1.107 P1  F42000
G1 X128.13 Y128.481 Z9.98
G1 Z9.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.638772
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X127.975 Y128.126 E.01881
G3 X128.15 Y127.739 I.755 J.109 E.02088
; LINE_WIDTH: 0.596803
G1 X128.262 Y127.565 E.00934
; LINE_WIDTH: 0.554834
G1 X128.374 Y127.391 E.00863
; LINE_WIDTH: 0.512864
G1 X128.566 Y127.255 E.00901
; LINE_WIDTH: 0.481432
G1 X128.758 Y127.119 E.0084
; LINE_WIDTH: 0.449999
G1 X129.265 Y127 E.01729
G1 X129.771 Y127.066 E.01692
G3 X130.615 Y127.656 I-.538 J1.671 E.03467
G1 X130.788 Y127.965 E.01175
G1 X130.919 Y128.476 E.0175
; LINE_WIDTH: 0.438164
G1 X130.948 Y128.798 E.01042
; LINE_WIDTH: 0.407991
G1 X130.975 Y129.233 E.01295
; LINE_WIDTH: 0.379905
G1 X131.003 Y129.667 E.01196
; LINE_WIDTH: 0.351818
G1 X131.047 Y130.539 E.02197
; LINE_WIDTH: 0.341235
G1 X131.063 Y131.439 E.02188
; LINE_WIDTH: 0.388779
G1 X131.042 Y131.506 E.00198
; LINE_WIDTH: 0.436323
G1 X131.02 Y131.573 E.00226
; LINE_WIDTH: 0.483867
G1 X130.998 Y131.64 E.00253
; LINE_WIDTH: 0.531411
G1 X130.977 Y131.707 E.0028
; LINE_WIDTH: 0.578955
G1 X130.955 Y131.774 E.00308
; LINE_WIDTH: 0.626498
G1 X130.933 Y131.841 E.00335
G1 X130.905 Y131.774 E.00344
; LINE_WIDTH: 0.578955
G1 X130.877 Y131.708 E.00316
; LINE_WIDTH: 0.531411
G1 X130.849 Y131.641 E.00288
; LINE_WIDTH: 0.483867
G1 X130.821 Y131.574 E.0026
; LINE_WIDTH: 0.436323
G1 X130.793 Y131.508 E.00232
; LINE_WIDTH: 0.388779
G1 X130.765 Y131.441 E.00204
; LINE_WIDTH: 0.341235
G1 X130.77 Y130.523 E.02231
; LINE_WIDTH: 0.350643
G1 X130.712 Y130.027 E.01253
; LINE_WIDTH: 0.382246
G3 X130.657 Y129.312 I2.709 J-.568 E.01988
; LINE_WIDTH: 0.397355
G1 X130.611 Y129.038 E.00801
; LINE_WIDTH: 0.424407
G1 X130.564 Y128.765 E.00862
; LINE_WIDTH: 0.449999
G1 X130.25 Y128.311 E.01832
G1 X129.775 Y128.033 E.01826
G1 X129.228 Y127.969 E.01826
; LINE_WIDTH: 0.497193
G1 X129.077 Y127.995 E.0057
; LINE_WIDTH: 0.544386
G1 X128.925 Y128.021 E.00629
; LINE_WIDTH: 0.591579
G1 X128.773 Y128.046 E.00688
; LINE_WIDTH: 0.638772
G1 X128.621 Y128.072 E.00748
G1 X128.176 Y128.443 E.02812
; WIPE_START
G1 F6041.769
G1 X127.975 Y128.126 E-.14251
G1 X128.038 Y127.914 E-.08418
G1 X128.15 Y127.739 E-.07866
G1 X128.262 Y127.565 E-.07866
G1 X128.374 Y127.391 E-.07866
G1 X128.566 Y127.255 E-.08936
G1 X128.758 Y127.119 E-.08936
G1 X129.062 Y127.048 E-.11861
; WIPE_END
G1 E-.04 F1800
G1 X128.147 Y129.8 Z10.18 F42000
G1 Z9.78
G1 E.8 F1800
; LINE_WIDTH: 0.360695
G1 F1200
G1 X128.129 Y130.341 E.01403
G1 X127.755 Y129.822 E.01657
G1 X127.998 Y129.546 E.00953
G1 X128.117 Y129.748 E.00606
G1 X128.355 Y129.445 F42000
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530861
G1 F1200
G1 X128.387 Y129.508 E.00279
; LINE_WIDTH: 0.493907
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456953
G1 X128.449 Y129.631 E.00229
G1 X128.45 Y129.632 E.00007
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.00051
G1 X128.51 Y129.661 E.00153
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429875
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474756
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519637
G1 X128.232 Y131.436 E.00322
; LINE_WIDTH: 0.564518
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609399
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.628681
G1 X128.535 Y131.815 E.0167
G1 X128.596 Y132.399 E.02801
G1 X128.467 Y132.597 E.01128
G1 X128.465 Y132.677 E.00383
; LINE_WIDTH: 0.58412
G1 X128.464 Y132.75 E.00321
G1 X128.464 Y132.758 E.00033
; LINE_WIDTH: 0.539558
G1 X128.463 Y132.806 E.00196
G1 X128.462 Y132.838 E.00129
; LINE_WIDTH: 0.494997
G1 X128.462 Y132.862 E.00089
G1 X128.46 Y132.918 E.00207
; LINE_WIDTH: 0.450435
G1 X128.46 Y132.93 E.00038
G1 X128.459 Y132.998 E.00229
; LINE_WIDTH: 0.405874
G1 X128.457 Y133.079 E.00238
; LINE_WIDTH: 0.404004
G1 X128.466 Y133.164 E.00252
; LINE_WIDTH: 0.446696
G1 X128.474 Y133.246 E.00272
G1 X128.474 Y133.249 E.0001
; LINE_WIDTH: 0.489388
G1 X128.482 Y133.329 E.0029
G1 X128.483 Y133.335 E.00022
; LINE_WIDTH: 0.53208
G1 X128.488 Y133.384 E.002
G1 X128.492 Y133.42 E.00141
; LINE_WIDTH: 0.574772
G1 X128.492 Y133.424 E.00018
G1 X128.5 Y133.505 E.00353
; LINE_WIDTH: 0.617464
G1 X128.509 Y133.59 E.00401
; LINE_WIDTH: 0.635244
G1 X128.725 Y133.775 E.01373
G2 X128.807 Y134.295 I2.087 J-.062 E.02546
; LINE_WIDTH: 0.588536
G1 X128.847 Y134.455 E.00732
; LINE_WIDTH: 0.541828
G1 X128.886 Y134.614 E.00669
; LINE_WIDTH: 0.50685
G2 X128.983 Y135.412 I4.487 J-.137 E.03042
; LINE_WIDTH: 0.463425
G1 X129.032 Y135.685 E.00949
; LINE_WIDTH: 0.419999
G1 X129.029 Y136.23 E.01675
G1 X128.907 Y136.789 E.01757
G1 X128.674 Y137.29 E.01698
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.92 Y138.502 E.01643
G1 X126.349 Y138.543 E.01757
G1 X125.802 Y138.461 E.01698
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.432 Y137.571 E.017
G1 X124.144 Y137.121 E.01643
G1 X123.943 Y136.585 E.01757
G1 X123.868 Y136.051 E.01659
; LINE_WIDTH: 0.445318
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.4547
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489503
G1 X123.887 Y134.503 E.00732
; LINE_WIDTH: 0.524305
G1 X123.903 Y134.302 E.00789
; LINE_WIDTH: 0.559107
G2 X123.893 Y133.89 I-1.029 J-.182 E.01744
; LINE_WIDTH: 0.511604
G1 X123.868 Y133.679 E.00813
; LINE_WIDTH: 0.4641
G1 X123.842 Y133.468 E.00731
; LINE_WIDTH: 0.447717
G1 X123.851 Y132.66 E.02665
; LINE_WIDTH: 0.494859
G1 X123.873 Y132.491 E.00626
; LINE_WIDTH: 0.542
G1 X123.895 Y132.322 E.00692
; LINE_WIDTH: 0.589141
G2 X123.905 Y132.007 I-.713 J-.18 E.01414
; LINE_WIDTH: 0.566569
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.523626
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480682
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437738
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.475701
G1 X123.847 Y130.473 E.00601
; LINE_WIDTH: 0.51711
G1 X123.866 Y130.304 E.00659
; LINE_WIDTH: 0.558518
G2 X123.864 Y129.986 I-.603 J-.154 E.01351
; LINE_WIDTH: 0.51763
G1 X123.842 Y129.838 E.00581
; LINE_WIDTH: 0.476742
G1 X123.82 Y129.689 E.00531
; LINE_WIDTH: 0.435854
G1 X123.8 Y129.384 E.00979
; LINE_WIDTH: 0.395663
G1 X123.78 Y129.079 E.00879
; LINE_WIDTH: 0.402692
G1 X123.803 Y128.572 E.01488
; LINE_WIDTH: 0.446768
G1 X123.825 Y128.425 E.00488
; LINE_WIDTH: 0.490843
G1 X123.847 Y128.279 E.00541
; LINE_WIDTH: 0.534918
G1 X123.869 Y128.132 E.00594
; LINE_WIDTH: 0.578993
G1 X123.891 Y127.986 E.00647
G1 X123.886 Y125.054 E.12805
; LINE_WIDTH: 0.573605
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522564
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573605
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578993
G2 X124.427 Y128.102 I1664.645 J-4.33 E.13318
G2 X124.291 Y128.301 I.153 J.251 E.01084
; LINE_WIDTH: 0.534918
G1 X124.241 Y128.419 E.00517
; LINE_WIDTH: 0.490843
G1 X124.191 Y128.538 E.00471
; LINE_WIDTH: 0.446768
G1 X124.141 Y128.657 E.00425
; LINE_WIDTH: 0.402692
G1 X124.093 Y129.055 E.01174
; LINE_WIDTH: 0.38592
G1 X124.136 Y129.426 E.01043
; LINE_WIDTH: 0.42584
G1 X124.176 Y129.539 E.00377
; LINE_WIDTH: 0.46576
G1 X124.217 Y129.653 E.00416
; LINE_WIDTH: 0.50568
G1 X124.258 Y129.767 E.00455
; LINE_WIDTH: 0.545599
G1 X124.299 Y129.88 E.00495
; LINE_WIDTH: 0.564803
G1 X124.528 Y130.101 E.01355
G2 X124.358 Y130.326 I.158 J.295 E.01236
; LINE_WIDTH: 0.529852
G1 X124.293 Y130.463 E.00603
; LINE_WIDTH: 0.494901
G1 X124.229 Y130.601 E.0056
; LINE_WIDTH: 0.45995
G1 X124.201 Y130.818 E.00743
; LINE_WIDTH: 0.431525
G1 X124.173 Y131.034 E.00692
; LINE_WIDTH: 0.437738
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480682
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.523626
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566569
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.602184
G1 X124.612 Y132.105 E.0148
G2 X124.405 Y132.366 I.269 J.425 E.01546
; LINE_WIDTH: 0.561148
G1 X124.335 Y132.499 E.00636
; LINE_WIDTH: 0.520112
G1 X124.265 Y132.632 E.00585
; LINE_WIDTH: 0.479076
G1 X124.228 Y132.838 E.00744
; LINE_WIDTH: 0.442226
G1 X124.19 Y133.044 E.00681
; LINE_WIDTH: 0.416596
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.4641
G1 X124.264 Y133.605 E.00566
; LINE_WIDTH: 0.511604
G1 X124.313 Y133.762 E.0063
; LINE_WIDTH: 0.559107
G1 X124.362 Y133.92 E.00693
; LINE_WIDTH: 0.588909
G1 X124.579 Y134.164 E.01457
G2 X124.424 Y134.398 I.325 J.384 E.01263
; LINE_WIDTH: 0.553473
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518037
G1 X124.293 Y134.666 E.00578
; LINE_WIDTH: 0.4826
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451188
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445318
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.789 Y137.554 E.01469
G1 X127.264 Y137.373 E.01561
G1 X127.653 Y137.07 E.01516
G1 X127.939 Y136.668 E.01516
G1 X128.099 Y136.202 E.01516
G1 X128.118 Y135.781 E.01295
G1 X128.209 Y135.662 E.00458
; LINE_WIDTH: 0.450565
G1 X128.328 Y135.43 E.00867
; LINE_WIDTH: 0.48113
G1 X128.448 Y135.198 E.00932
; LINE_WIDTH: 0.489486
G1 X128.458 Y134.785 E.01505
; LINE_WIDTH: 0.538072
G1 X128.425 Y134.623 E.00666
; LINE_WIDTH: 0.586658
G1 X128.393 Y134.461 E.00731
; LINE_WIDTH: 0.635244
G1 X128.36 Y134.3 E.00797
G1 X128.144 Y134.036 E.01647
; LINE_WIDTH: 0.621995
G1 X127.902 Y133.865 E.01394
; LINE_WIDTH: 0.617464
G1 X128.059 Y133.633 E.01311
G1 X128.073 Y133.532 E.00476
; LINE_WIDTH: 0.568215
G1 X128.085 Y133.443 E.00387
G1 X128.086 Y133.432 E.00049
; LINE_WIDTH: 0.518965
G1 X128.095 Y133.366 E.00258
G1 X128.1 Y133.331 E.00137
; LINE_WIDTH: 0.469715
G1 X128.11 Y133.257 E.00258
G1 X128.113 Y133.23 E.00096
; LINE_WIDTH: 0.420465
G1 X128.127 Y133.129 E.00313
; LINE_WIDTH: 0.414126
G1 X128.145 Y133.038 E.00281
; LINE_WIDTH: 0.457037
G1 X128.148 Y133.019 E.00063
G1 X128.162 Y132.947 E.0025
; LINE_WIDTH: 0.499948
G1 X128.166 Y132.928 E.0007
G1 X128.18 Y132.855 E.00276
; LINE_WIDTH: 0.542859
G1 X128.182 Y132.845 E.00043
G1 X128.198 Y132.764 E.00335
; LINE_WIDTH: 0.58577
G1 X128.216 Y132.673 E.00411
; LINE_WIDTH: 0.628681
G1 X128.234 Y132.582 E.00444
G1 X128.072 Y132.229 E.01849
G1 X127.872 Y132.014 E.01404
; LINE_WIDTH: 0.609399
G1 X127.633 Y131.826 E.01405
G1 X127.761 Y131.69 E.00864
G1 X127.779 Y131.621 E.00329
; LINE_WIDTH: 0.581833
G1 X127.797 Y131.552 E.00313
; LINE_WIDTH: 0.554266
M73 P98 R0
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.509987
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465707
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.789 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467423
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514846
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.56227
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609693
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.61446
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00187
; LINE_WIDTH: 0.576625
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.538789
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.500953
G1 X127.662 Y128.623 E.00662
; LINE_WIDTH: 0.460476
G1 X127.599 Y128.457 E.00604
; LINE_WIDTH: 0.419999
G1 X127.431 Y128.189 E.00974
G1 X127.498 Y127.945 E.00778
G1 X127.713 Y127.492 E.01539
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.229 Y126.61 E.01382
G1 X129.695 Y126.636 E.01434
G1 X130.138 Y126.771 E.01422
G1 X130.501 Y126.983 E.0129
G1 X130.866 Y127.328 E.01545
G1 X131.116 Y127.724 E.01437
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.04 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.062 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01583
G1 X130.754 Y134.711 E.01968
G1 X130.513 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.818 I27.163 J-1.755 E.04787
G1 X130.408 Y131.713 E.00352
G1 X130.362 Y131.687 E.00163
G1 X130.229 Y131.612 E.00467
G1 X130.378 Y131.494 E.00583
G1 X130.406 Y131.471 E.0011
G1 X130.447 Y131.361 E.00363
G1 X130.443 Y130.518 E.02588
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.0017
G1 X130.094 Y129.527 E.00535
G2 X130.238 Y129.414 I-.098 J-.275 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.68 Y128.413 E.01123
G1 X129.275 Y128.354 E.01258
G1 X128.892 Y128.467 E.01226
G1 X128.717 Y128.606 E.00686
; LINE_WIDTH: 0.466196
G1 X128.624 Y128.709 E.00479
; LINE_WIDTH: 0.512392
G1 X128.547 Y128.795 E.00443
G1 X128.531 Y128.812 E.00088
; LINE_WIDTH: 0.558589
G1 X128.49 Y128.858 E.0026
G1 X128.438 Y128.915 E.00324
; LINE_WIDTH: 0.604785
G1 X128.437 Y128.916 E.00004
G2 X128.317 Y129.122 I.142 J.221 E.01135
; LINE_WIDTH: 0.600276
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565569
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6887.994
G1 X128.387 Y129.508 E-.04865
G1 X128.419 Y129.57 E-.02662
G1 X128.449 Y129.631 E-.02584
G1 X128.45 Y129.632 E-.00079
G1 X128.465 Y129.64 E-.00627
G1 X128.51 Y129.661 E-.01897
G1 X128.665 Y129.736 E-.0653
G1 X128.525 Y129.856 E-.07
G1 X128.491 Y129.898 E-.02057
G1 X128.463 Y129.933 E-.01704
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06985
; WIPE_END
G1 E-.04 F1800
G1 X128.571 Y135.93 Z10.18 F42000
G1 Z9.78
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.584578
G1 F1200
G1 X128.533 Y136.351 E.01863
; LINE_WIDTH: 0.59796
G1 X128.356 Y136.869 E.02476
; LINE_WIDTH: 0.61833
G1 X128.003 Y137.387 E.02941
G1 X127.507 Y137.775 E.02953
; LINE_WIDTH: 0.613358
G1 X126.905 Y138.008 E.03002
; LINE_WIDTH: 0.622424
G1 X126.368 Y138.062 E.0255
G1 X125.923 Y137.998 E.0212
; LINE_WIDTH: 0.617366
G1 X125.498 Y137.844 E.02114
; LINE_WIDTH: 0.604468
G1 X125.111 Y137.607 E.02076
; LINE_WIDTH: 0.581114
G1 X124.745 Y137.238 E.0228
; LINE_WIDTH: 0.551612
G1 X124.46 Y136.736 E.02396
; LINE_WIDTH: 0.530458
G1 X124.347 Y136.349 E.01599
; WIPE_START
G1 F7384.04
G1 X124.46 Y136.736 E-.15293
G1 X124.745 Y137.238 E-.21967
G1 X125.111 Y137.607 E-.19754
G1 X125.498 Y137.844 E-.17243
G1 X125.541 Y137.86 E-.01744
; WIPE_END
G1 E-.04 F1800
G1 X131.401 Y135.093 Z10.18 F42000
G1 Z9.78
G1 E.8 F1800
; LINE_WIDTH: 0.573199
G1 F1200
G1 X131.31 Y134.865 E.01062
; LINE_WIDTH: 0.601266
G1 X131.218 Y134.637 E.01118
; LINE_WIDTH: 0.648174
G1 X131.045 Y133.849 E.03979
G1 X130.995 Y133.338 E.02533
; LINE_WIDTH: 0.646514
G1 X130.951 Y132.465 E.043
; LINE_WIDTH: 0.630496
G1 X130.933 Y131.841 E.02987
; WIPE_START
G1 F6126.867
G1 X130.951 Y132.465 E-.23709
G1 X130.995 Y133.338 E-.3322
G1 X131.044 Y133.837 E-.19072
; WIPE_END
G1 E-.04 F1800
G1 X128.986 Y127.549 Z10.18 F42000
G1 Z9.78
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.590108
G1 F1200
G1 X129.358 Y127.485 E.01686
; LINE_WIDTH: 0.586853
G1 X129.614 Y127.537 E.01157
; LINE_WIDTH: 0.559159
G1 X129.87 Y127.588 E.01098
; LINE_WIDTH: 0.530873
G1 X129.961 Y127.638 E.00413
; LINE_WIDTH: 0.501995
G1 X130.052 Y127.688 E.00389
; CHANGE_LAYER
; Z_HEIGHT: 9.98
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7841.856
G1 X129.961 Y127.638 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 50/50
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change
M106 S201.45
G17
G3 Z10.18 I-.91 J-.809 P1  F42000
G1 X128.355 Y129.445 Z10.18
G1 Z9.98
G1 E.8 F1800
M204 S5000
; FEATURE: Outer wall
; LINE_WIDTH: 0.530829
G1 F1589
G1 X128.387 Y129.508 E.00278
; LINE_WIDTH: 0.493886
G1 X128.419 Y129.57 E.00257
; LINE_WIDTH: 0.456943
G1 X128.449 Y129.63 E.00229
G1 X128.45 Y129.632 E.00008
; LINE_WIDTH: 0.419999
G1 X128.465 Y129.64 E.0005
G1 X128.51 Y129.661 E.00154
G1 X128.665 Y129.736 E.00528
G2 X128.525 Y129.856 I.134 J.3 E.00574
G1 X128.491 Y129.898 E.00166
G1 X128.463 Y129.933 E.00138
G1 X128.508 Y130.485 E.01703
G1 X128.403 Y130.549 E.00378
G1 X128.219 Y130.847 E.01073
; LINE_WIDTH: 0.391221
G1 X128.192 Y131.19 E.00979
; LINE_WIDTH: 0.429908
G1 X128.205 Y131.272 E.00262
; LINE_WIDTH: 0.474823
G1 X128.219 Y131.354 E.00292
; LINE_WIDTH: 0.519738
G1 X128.232 Y131.436 E.00323
; LINE_WIDTH: 0.564653
G1 X128.246 Y131.518 E.00353
; LINE_WIDTH: 0.609567
G1 X128.259 Y131.6 E.00383
; LINE_WIDTH: 0.628799
G1 X128.535 Y131.815 E.0167
G1 X128.596 Y132.401 E.0281
G1 X128.469 Y132.594 E.01104
G1 X128.467 Y132.676 E.00391
; LINE_WIDTH: 0.584315
G1 X128.465 Y132.747 E.00314
G1 X128.465 Y132.758 E.00047
; LINE_WIDTH: 0.539831
G1 X128.464 Y132.802 E.0018
G1 X128.463 Y132.839 E.00152
; LINE_WIDTH: 0.495347
G1 X128.463 Y132.857 E.00065
G1 X128.461 Y132.921 E.00236
; LINE_WIDTH: 0.450863
G1 X128.461 Y132.921 E.00001
G1 X128.459 Y133.003 E.00271
; LINE_WIDTH: 0.406379
G1 X128.457 Y133.085 E.00242
; LINE_WIDTH: 0.404457
G1 X128.466 Y133.169 E.0025
; LINE_WIDTH: 0.447019
G1 X128.474 Y133.249 E.00265
G1 X128.475 Y133.254 E.00014
; LINE_WIDTH: 0.489581
G1 X128.483 Y133.329 E.00275
G1 X128.484 Y133.338 E.00034
; LINE_WIDTH: 0.532144
G1 X128.489 Y133.387 E.00194
G1 X128.492 Y133.423 E.00145
; LINE_WIDTH: 0.574706
G1 X128.493 Y133.425 E.00012
G1 X128.501 Y133.507 E.00356
; LINE_WIDTH: 0.617268
G1 X128.51 Y133.592 E.00397
; LINE_WIDTH: 0.635131
G1 X128.727 Y133.776 E.01376
G2 X128.807 Y134.292 I2.05 J-.052 E.02527
; LINE_WIDTH: 0.588359
G1 X128.847 Y134.456 E.00749
; LINE_WIDTH: 0.541587
G1 X128.887 Y134.619 E.00684
; LINE_WIDTH: 0.507239
G2 X128.983 Y135.414 I4.392 J-.127 E.03031
; LINE_WIDTH: 0.463619
G1 X129.032 Y135.684 E.00943
; LINE_WIDTH: 0.419999
G1 X129.028 Y136.248 E.01733
G1 X128.907 Y136.788 E.017
G1 X128.674 Y137.29 E.017
G1 X128.34 Y137.731 E.017
G1 X127.92 Y138.091 E.017
G1 X127.433 Y138.353 E.017
G1 X126.908 Y138.504 E.01678
G1 X126.349 Y138.543 E.01721
G1 X125.802 Y138.461 E.01699
G1 X125.285 Y138.265 E.017
G1 X124.821 Y137.964 E.017
G1 X124.436 Y137.577 E.01678
G1 X124.134 Y137.105 E.01721
G1 X123.943 Y136.586 E.01699
G1 X123.868 Y136.051 E.01661
; LINE_WIDTH: 0.445319
G1 X123.874 Y135.542 E.01667
; LINE_WIDTH: 0.454702
G1 X123.872 Y134.703 E.02816
; LINE_WIDTH: 0.489796
G1 X123.888 Y134.503 E.0073
; LINE_WIDTH: 0.52489
G1 X123.903 Y134.304 E.00787
; LINE_WIDTH: 0.559984
G2 X123.897 Y133.935 I-.863 J-.169 E.01567
; LINE_WIDTH: 0.517856
G1 X123.874 Y133.765 E.00661
; LINE_WIDTH: 0.475728
G1 X123.852 Y133.596 E.00602
; LINE_WIDTH: 0.4336
G1 X123.833 Y133.003 E.01888
; LINE_WIDTH: 0.449192
G1 X123.853 Y132.796 E.00689
; LINE_WIDTH: 0.493007
G1 X123.873 Y132.589 E.00763
; LINE_WIDTH: 0.536823
G1 X123.893 Y132.382 E.00838
; LINE_WIDTH: 0.580638
G2 X123.905 Y132.007 I-1.254 J-.227 E.01647
; LINE_WIDTH: 0.566562
G1 X123.882 Y131.838 E.0073
; LINE_WIDTH: 0.52362
G1 X123.859 Y131.668 E.0067
; LINE_WIDTH: 0.480678
G1 X123.836 Y131.499 E.0061
; LINE_WIDTH: 0.437735
G1 X123.828 Y130.643 E.02754
; LINE_WIDTH: 0.471814
G1 X123.845 Y130.453 E.00668
; LINE_WIDTH: 0.509334
G1 X123.862 Y130.262 E.00726
; LINE_WIDTH: 0.546853
G2 X123.855 Y129.907 I-.74 J-.163 E.01475
; LINE_WIDTH: 0.500059
G1 X123.83 Y129.741 E.00623
; LINE_WIDTH: 0.453265
G1 X123.806 Y129.575 E.00559
; LINE_WIDTH: 0.40647
G1 X123.793 Y129.325 E.00744
; LINE_WIDTH: 0.38091
G1 X123.78 Y129.074 E.00692
; LINE_WIDTH: 0.402823
G1 X123.803 Y128.57 E.01479
; LINE_WIDTH: 0.446866
G1 X123.825 Y128.424 E.00486
; LINE_WIDTH: 0.490909
G1 X123.847 Y128.278 E.00538
; LINE_WIDTH: 0.534952
G1 X123.869 Y128.132 E.00591
; LINE_WIDTH: 0.578994
G1 X123.891 Y127.986 E.00644
G1 X123.886 Y125.054 E.12809
; LINE_WIDTH: 0.573605
G1 X123.892 Y122.885 E.09381
; LINE_WIDTH: 0.563164
G1 X123.914 Y119.816 E.13011
; LINE_WIDTH: 0.539758
G1 X123.936 Y117.891 E.07796
; LINE_WIDTH: 0.522565
G1 X123.96 Y117.65 E.00944
G1 X124.08 Y117.53 E.00663
G1 X124.25 Y117.533 E.00664
G1 X124.384 Y117.637 E.00664
G1 X124.412 Y117.894 E.01008
; LINE_WIDTH: 0.539758
G1 X124.41 Y119.818 E.07789
; LINE_WIDTH: 0.563164
G1 X124.412 Y122.885 E.13005
; LINE_WIDTH: 0.573605
G1 X124.417 Y125.053 E.09374
; LINE_WIDTH: 0.578994
G2 X124.427 Y128.102 I1651.334 J-4.282 E.13319
G2 X124.292 Y128.3 I.156 J.252 E.01079
; LINE_WIDTH: 0.534952
G1 X124.242 Y128.418 E.00515
; LINE_WIDTH: 0.490909
G1 X124.192 Y128.537 E.00469
; LINE_WIDTH: 0.446866
G1 X124.142 Y128.655 E.00422
; LINE_WIDTH: 0.402823
G1 X124.093 Y129.049 E.01166
; LINE_WIDTH: 0.38656
G1 X124.137 Y129.43 E.01072
; LINE_WIDTH: 0.426634
G1 X124.177 Y129.543 E.00377
; LINE_WIDTH: 0.466707
G1 X124.218 Y129.656 E.00416
; LINE_WIDTH: 0.50678
G1 X124.259 Y129.77 E.00455
; LINE_WIDTH: 0.546853
G1 X124.3 Y129.883 E.00495
; LINE_WIDTH: 0.565203
G1 X124.527 Y130.101 E.01341
G2 X124.362 Y130.322 I.158 J.291 E.01214
; LINE_WIDTH: 0.530296
G1 X124.295 Y130.461 E.00611
; LINE_WIDTH: 0.495389
G1 X124.229 Y130.6 E.00567
; LINE_WIDTH: 0.460482
G1 X124.201 Y130.817 E.00745
; LINE_WIDTH: 0.431792
G1 X124.173 Y131.034 E.00694
; LINE_WIDTH: 0.437735
G1 X124.227 Y131.459 E.01377
; LINE_WIDTH: 0.480678
G1 X124.282 Y131.595 E.00523
; LINE_WIDTH: 0.52362
G1 X124.336 Y131.731 E.00574
; LINE_WIDTH: 0.566562
G1 X124.39 Y131.868 E.00626
; LINE_WIDTH: 0.601444
G1 X124.612 Y132.105 E.0148
G2 X124.396 Y132.375 I.258 J.427 E.01604
; LINE_WIDTH: 0.560152
G1 X124.33 Y132.505 E.00615
; LINE_WIDTH: 0.51886
G1 X124.265 Y132.635 E.00566
; LINE_WIDTH: 0.477567
G1 X124.227 Y132.84 E.00737
; LINE_WIDTH: 0.441472
G1 X124.19 Y133.044 E.00676
; LINE_WIDTH: 0.416598
G1 X124.215 Y133.447 E.0123
; LINE_WIDTH: 0.464394
G1 X124.264 Y133.605 E.00567
; LINE_WIDTH: 0.512189
G1 X124.313 Y133.763 E.00632
; LINE_WIDTH: 0.559984
G1 X124.362 Y133.921 E.00696
; LINE_WIDTH: 0.588985
G1 X124.591 Y134.177 E.0153
G2 X124.424 Y134.398 I.168 J.3 E.01266
; LINE_WIDTH: 0.553524
G1 X124.359 Y134.532 E.00622
; LINE_WIDTH: 0.518063
G1 X124.293 Y134.666 E.00578
; LINE_WIDTH: 0.482602
G1 X124.262 Y134.879 E.0077
; LINE_WIDTH: 0.451189
G1 X124.231 Y135.091 E.00715
; LINE_WIDTH: 0.445319
G1 X124.274 Y135.508 E.01375
G1 X124.465 Y135.85 E.01284
; LINE_WIDTH: 0.419999
G1 X124.734 Y136.113 E.01155
G1 X124.814 Y136.471 E.01128
G1 X125.048 Y136.905 E.01515
G1 X125.396 Y137.255 E.01516
G1 X125.829 Y137.491 E.01516
G1 X126.312 Y137.592 E.01516
G1 X126.778 Y137.555 E.01437
G1 X127.264 Y137.373 E.01592
G1 X127.647 Y137.076 E.01491
G1 X127.939 Y136.669 E.01538
G1 X128.099 Y136.202 E.01518
G1 X128.118 Y135.781 E.01294
G1 X128.209 Y135.663 E.00458
; LINE_WIDTH: 0.450551
G1 X128.328 Y135.432 E.00861
; LINE_WIDTH: 0.481103
G1 X128.447 Y135.202 E.00926
; LINE_WIDTH: 0.489284
G1 X128.459 Y134.791 E.01497
; LINE_WIDTH: 0.5379
G1 X128.425 Y134.625 E.0068
; LINE_WIDTH: 0.586516
G1 X128.391 Y134.46 E.00747
; LINE_WIDTH: 0.635131
G1 X128.357 Y134.295 E.00814
G1 X128.141 Y134.033 E.01638
; LINE_WIDTH: 0.621248
G1 X127.901 Y133.864 E.01383
; LINE_WIDTH: 0.617268
G1 X128.06 Y133.633 E.01314
G1 X128.073 Y133.533 E.00472
; LINE_WIDTH: 0.568186
G1 X128.085 Y133.443 E.0039
G1 X128.087 Y133.433 E.00042
; LINE_WIDTH: 0.519104
G1 X128.096 Y133.363 E.00273
G1 X128.1 Y133.333 E.00119
; LINE_WIDTH: 0.470022
G1 X128.11 Y133.257 E.00266
G1 X128.113 Y133.233 E.00085
; LINE_WIDTH: 0.42094
G1 X128.127 Y133.133 E.00311
; LINE_WIDTH: 0.414681
G1 X128.144 Y133.04 E.00286
; LINE_WIDTH: 0.457505
G1 X128.15 Y133.012 E.00096
G1 X128.162 Y132.948 E.00222
; LINE_WIDTH: 0.500328
G1 X128.166 Y132.928 E.00077
G1 X128.18 Y132.855 E.00275
; LINE_WIDTH: 0.543152
G1 X128.182 Y132.843 E.00051
G1 X128.197 Y132.763 E.00333
; LINE_WIDTH: 0.585976
G1 X128.215 Y132.67 E.00417
; LINE_WIDTH: 0.628799
G1 X128.233 Y132.577 E.0045
G1 X128.077 Y132.236 E.01791
G1 X127.871 Y132.013 E.01451
; LINE_WIDTH: 0.609567
G1 X127.633 Y131.826 E.01398
G1 X127.76 Y131.69 E.00859
G1 X127.779 Y131.621 E.0033
; LINE_WIDTH: 0.581919
G1 X127.797 Y131.552 E.00314
; LINE_WIDTH: 0.55427
G1 X127.812 Y131.421 E.00549
G1 X127.815 Y131.387 E.00141
; LINE_WIDTH: 0.50999
G1 X127.82 Y131.347 E.00152
G1 X127.834 Y131.222 E.00478
; LINE_WIDTH: 0.465709
G1 X127.852 Y131.058 E.00571
; LINE_WIDTH: 0.421428
G1 X127.852 Y131.055 E.00008
G1 X127.854 Y131.037 E.00056
G1 X127.87 Y130.893 E.00447
; LINE_WIDTH: 0.419999
G1 X127.79 Y130.449 E.01386
G1 X127.559 Y130.113 E.01254
G1 X127.317 Y129.929 E.00934
G1 X127.275 Y129.825 E.00343
G1 X127.455 Y129.646 E.00781
; LINE_WIDTH: 0.467424
G1 X127.528 Y129.545 E.00433
; LINE_WIDTH: 0.514849
G1 X127.602 Y129.443 E.00481
; LINE_WIDTH: 0.562274
G1 X127.676 Y129.342 E.0053
; LINE_WIDTH: 0.609699
G1 X127.75 Y129.241 E.00578
; LINE_WIDTH: 0.614461
G1 X127.786 Y128.892 E.01633
G1 X127.766 Y128.858 E.00186
; LINE_WIDTH: 0.576791
G1 X127.746 Y128.823 E.00174
; LINE_WIDTH: 0.539121
G1 X127.726 Y128.789 E.00162
; LINE_WIDTH: 0.50145
G1 X127.663 Y128.626 E.00651
; LINE_WIDTH: 0.460725
G1 X127.601 Y128.463 E.00593
; LINE_WIDTH: 0.419999
G1 X127.43 Y128.189 E.00993
G1 X127.5 Y127.939 E.00799
G1 X127.713 Y127.492 E.01521
G1 X128.003 Y127.144 E.01393
G1 X128.367 Y126.871 E.01397
G1 X128.787 Y126.688 E.01406
G1 X129.235 Y126.609 E.014
G1 X129.69 Y126.635 E.014
G1 X130.137 Y126.771 E.01434
G1 X130.508 Y126.988 E.0132
G1 X130.867 Y127.329 E.01522
G1 X131.116 Y127.724 E.01434
G1 X131.209 Y127.978 E.00833
G1 X131.31 Y128.475 E.01559
G2 X131.492 Y133.388 I128.042 J-2.284 E.15108
G2 X131.672 Y134.53 I9.528 J-.918 E.03555
G2 X132.16 Y135.774 I6.891 J-1.982 E.04111
G1 X132.17 Y135.965 E.00588
G1 X132.061 Y136.13 E.00608
G1 X131.867 Y136.169 E.00609
G1 X131.644 Y136.089 E.00727
G1 X131.294 Y135.728 E.01544
G1 X131.012 Y135.297 E.01582
G1 X130.754 Y134.711 E.01968
G1 X130.514 Y133.729 E.03107
G1 X130.493 Y133.72 E.00068
G1 X130.445 Y133.699 E.00161
G1 X130.311 Y133.639 E.00452
G1 X130.448 Y133.508 E.0058
G1 X130.472 Y133.485 E.00102
G1 X130.508 Y133.375 E.00356
G3 X130.452 Y131.818 I27.164 J-1.755 E.04787
G1 X130.408 Y131.713 E.00352
G1 X130.361 Y131.687 E.00164
G1 X130.229 Y131.612 E.00466
G1 X130.378 Y131.494 E.00585
G1 X130.406 Y131.471 E.0011
G1 X130.447 Y131.361 E.00363
G1 X130.443 Y130.518 E.02588
G1 X130.317 Y129.634 E.02744
G1 X130.301 Y129.626 E.00057
G1 X130.251 Y129.602 E.00169
G1 X130.093 Y129.526 E.00538
G2 X130.238 Y129.414 I-.092 J-.27 E.00572
G1 X130.282 Y129.361 E.00212
G1 X130.306 Y129.332 E.00116
G1 X130.224 Y128.918 E.01297
G1 X129.994 Y128.599 E.01208
G1 X129.686 Y128.415 E.01103
G1 X129.27 Y128.354 E.0129
G1 X128.892 Y128.467 E.01214
G1 X128.716 Y128.607 E.0069
; LINE_WIDTH: 0.466195
G1 X128.623 Y128.71 E.00478
; LINE_WIDTH: 0.51239
G1 X128.547 Y128.795 E.00438
G1 X128.531 Y128.813 E.00092
; LINE_WIDTH: 0.558585
G1 X128.49 Y128.858 E.00257
G1 X128.438 Y128.915 E.00326
; LINE_WIDTH: 0.60478
G1 X128.437 Y128.916 E.00002
G2 X128.317 Y129.122 I.142 J.221 E.01136
; LINE_WIDTH: 0.600279
G1 X128.336 Y129.284 E.00739
; LINE_WIDTH: 0.565554
G1 X128.348 Y129.386 E.00437
M204 S6000
; WIPE_START
G1 F6888.186
G1 X128.387 Y129.508 E-.04864
G1 X128.419 Y129.57 E-.02661
G1 X128.449 Y129.63 E-.02576
G1 X128.45 Y129.632 E-.00085
G1 X128.465 Y129.64 E-.00624
G1 X128.51 Y129.661 E-.019
G1 X128.665 Y129.736 E-.06527
G1 X128.525 Y129.856 E-.06997
G1 X128.491 Y129.898 E-.02058
G1 X128.463 Y129.933 E-.01703
G1 X128.508 Y130.485 E-.21057
G1 X128.403 Y130.549 E-.04678
G1 X128.219 Y130.847 E-.13275
G1 X128.205 Y131.03 E-.06993
; WIPE_END
G1 E-.04 F1800
;===================== date: 20240606 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z10.38 I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z10.38
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z10.38 F4000
            G39.3 S1
            G0 Z10.38 F4000
            G392 S0
          
        M623
    
    M623
M623


G1 Z10.78 F42000
G1 X128.217 Y129.65
G1 Z9.98
G1 E.8 F1800
M204 S2000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1589
G1 X127.786 Y130.08 E.01869
M204 S6000
G1 X128.269 Y129.865 F42000
; FEATURE: Gap infill
; LINE_WIDTH: 0.171045
G1 F1589
G1 X127.996 Y130.538 E.00759
G1 X128.162 Y129.567 F42000
; LINE_WIDTH: 0.102246
G1 F1589
G2 X128.073 Y129.473 I-.209 J.109 E.00063
; LINE_WIDTH: 0.136191
G1 X128.067 Y129.471 E.00005
; LINE_WIDTH: 0.155994
G1 X128.047 Y129.465 E.0002
; LINE_WIDTH: 0.187926
G1 X128.026 Y129.46 E.00025
; LINE_WIDTH: 0.236708
G1 X127.999 Y129.455 E.00044
G2 X127.59 Y129.893 I3.281 J3.475 E.00947
; WIPE_START
G1 F15000
G1 X127.999 Y129.455 E-.72649
G1 X128.026 Y129.46 E-.03351
; WIPE_END
G1 E-.04 F1800
G1 X131.408 Y135.524 Z10.38 F42000
G1 Z9.98
G1 E.8 F1800
M204 S2000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1589
G1 X131.695 Y135.237 E.01249
G1 X131.559 Y134.84
G1 X131.196 Y135.202 E.01577
G1 X131.023 Y134.842
G1 X131.442 Y134.424 E.01818
G1 X131.358 Y133.974
G1 X130.894 Y134.438 E.02014
G1 X130.79 Y134.009
G1 X131.295 Y133.504 E.02195
G1 X131.255 Y133.01
G1 X130.672 Y133.593 E.02534
G1 X130.703 Y133.029
G1 X131.228 Y132.505 E.0228
G1 X131.211 Y131.988
G1 X130.685 Y132.514 E.02287
G1 X130.666 Y132
G1 X131.195 Y131.471 E.02298
G1 X131.179 Y130.954
G1 X130.614 Y131.518 E.02453
G1 X130.651 Y130.948
G1 X131.163 Y130.436 E.02224
G1 X131.147 Y129.919
G1 X130.64 Y130.426 E.02202
G1 X130.587 Y129.946
G1 X131.131 Y129.402 E.02364
G1 X131.115 Y128.884
G1 X130.486 Y129.514 E.02736
G1 X130.46 Y129.006
G1 X131.091 Y128.375 E.02743
G1 X130.985 Y127.948
G1 X130.29 Y128.643 E.0302
G1 X130.033 Y128.367
G1 X130.805 Y127.595 E.03354
G1 X130.561 Y127.306
G1 X129.673 Y128.194 E.03859
G1 X129.176 Y128.157
G1 X130.26 Y127.073 E.04711
G1 X129.895 Y126.905
G1 X128.004 Y128.795 E.08217
G1 X127.818 Y128.449
G1 X129.45 Y126.817 E.07091
G1 X128.846 Y126.888
G1 X127.685 Y128.049 E.05046
M204 S6000
; WIPE_START
G1 F9547.055
G1 X128.846 Y126.888 E-.62397
G1 X129.201 Y126.846 E-.13603
; WIPE_END
G1 E-.04 F1800
G1 X131.279 Y133.896 Z10.38 F42000
G1 Z9.98
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0986589
G1 F1589
G1 X131.334 Y133.731 E.00079
; WIPE_START
G1 F15000
G1 X131.279 Y133.896 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.64 Y131.759 Z10.38 F42000
G1 Z9.98
G1 E.8 F1800
; LINE_WIDTH: 0.143172
G1 F1589
G2 X130.585 Y131.543 I-.142 J-.079 E.00201
; WIPE_START
G1 F15000
G1 X130.663 Y131.651 E-.41648
G1 X130.64 Y131.759 E-.34352
; WIPE_END
G1 E-.04 F1800
G1 X130.978 Y127.917 Z10.38 F42000
G1 Z9.98
G1 E.8 F1800
; LINE_WIDTH: 0.10472
G1 F1589
G2 X130.883 Y127.784 I-.611 J.336 E.00083
; WIPE_START
G1 F15000
G1 X130.978 Y127.917 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.292 Y135.061 Z10.38 F42000
G1 X127.098 Y138.234 Z10.38
G1 Z9.98
G1 E.8 F1800
M204 S2000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1589
G1 X128.738 Y136.594 E.07125
G1 X128.819 Y135.98
G1 X128.182 Y136.617 E.02767
M204 S6000
; WIPE_START
G1 F9547.055
G1 X128.819 Y135.98 E-.34223
G1 X128.738 Y136.594 E-.2354
G1 X128.399 Y136.933 E-.18237
; WIPE_END
G1 E-.04 F1800
G1 X127.163 Y137.636 Z10.38 F42000
G1 Z9.98
G1 E.8 F1800
M204 S2000
G1 F1589
G1 X126.473 Y138.326 E.03001
G1 X125.987 Y138.279
G1 X126.475 Y137.791 E.02122
G1 X125.993 Y137.739
G1 X125.578 Y138.154 E.01805
G1 X125.222 Y137.977
G1 X125.598 Y137.601 E.01636
G1 X125.258 Y137.408
G1 X124.908 Y137.758 E.01518
G1 X124.643 Y137.49
G1 X124.992 Y137.141 E.01518
G1 X124.77 Y136.829
G1 X124.425 Y137.174 E.01501
G1 X124.249 Y136.817
G1 X124.602 Y136.464 E.01535
G1 X124.419 Y136.114
G1 X124.127 Y136.405 E.01267
M204 S6000
; WIPE_START
G1 F9547.055
G1 X124.419 Y136.114 E-.1567
G1 X124.602 Y136.464 E-.15009
G1 X124.249 Y136.817 E-.18979
G1 X124.425 Y137.174 E-.15139
G1 X124.634 Y136.966 E-.11204
; WIPE_END
G1 E-.04 F1800
G1 X128.248 Y136.682 Z10.38 F42000
G1 Z9.98
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.195339
G1 F1589
G1 X128.151 Y136.816 E.00206
; LINE_WIDTH: 0.161407
G1 X128.002 Y136.994 E.00224
; LINE_WIDTH: 0.119625
G3 X127.847 Y137.178 I-1.398 J-1.019 E.0015
; LINE_WIDTH: 0.114354
G1 X127.628 Y137.377 E.00172
; LINE_WIDTH: 0.15141
G3 X127.236 Y137.709 I-2.404 J-2.438 E.00454
; WIPE_START
G1 F15000
G1 X127.628 Y137.377 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.542 Y137.084 Z10.38 F42000
G1 Z9.98
G1 E.8 F1800
; LINE_WIDTH: 0.103174
G1 F1589
G1 X128.479 Y137.173 E.00053
; LINE_WIDTH: 0.135345
G1 X128.314 Y137.362 E.00189
; LINE_WIDTH: 0.168275
G3 X127.783 Y137.89 I-2.727 J-2.21 E.00767
; LINE_WIDTH: 0.133271
G1 X127.691 Y137.959 E.00085
; LINE_WIDTH: 0.103203
G1 X127.598 Y138.028 E.00056
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F15000
G1 X127.691 Y137.959 E-.76
; WIPE_END
G1 E-.04 F1800
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; filament end gcode 
M106 P3 S0
;===== date: 20231229 =====================
G392 S0 ;turn off nozzle clog detect

M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z10.48 F900 ; lower z a little
G1 X0 Y128 F18000 ; move to safe pos
G1 X-13.0 F3000 ; move to safe pos

M1002 judge_flag timelapse_record_flag
M622 J1
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M991 S0 P-1 ;end timelapse at safe pos
M623


M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

;G1 X27 F15000 ; wipe

; pull back filament to AMS
M620 S255
G1 X267 F15000
T255
G1 X-28.5 F18000
G1 X-48.2 F3000
G1 X-28.5 F18000
G1 X-48.2 F3000
M621 S255

M104 S0 ; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    G1 Z109.98 F600
    G1 Z107.98

M400 P100
M17 R ; restore z current

G90
G1 X-48 Y180 F3600

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A0 B20 L100 C37 D20 M40 E42 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C46 D10 M80 E46 F10 N80
M1006 A44 B20 L100 C39 D20 M60 E48 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N80
M1006 A44 B20 L100 C49 D20 M80 E41 F20 N80
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N80
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W
;=====printer finish  sound=========

;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M400
M18 X Y Z

M73 P100 R0
; EXECUTABLE_BLOCK_END

