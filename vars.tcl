# de1 internal state live variables
package provide de1_vars 1.0

#############################
# raw data from the DE1

proc timer {} {
	if {$::android == 1} {
		return [expr {round($::de1(timer) / 100.0)}]
	}
	global start_volume
	return [expr {[clock seconds] - $start_volume}]
}

proc waterflow {} {
	if {$::android == 1} {
		return $::de1(flow)
	}
	return [expr {rand() * 15}]
}

set start_volume [clock seconds]
proc watervolume {} {
	if {$::android == 1} {
		return $::de1(volume)
	}
	global start_volume
	return [expr {[clock seconds] - $start_volume}]
}

proc steamtemp {} {
	if {$::android == 1} {
		return $::de1(steam_temperature)
	}
	return [expr {int(140+(rand() * 20))}]
}

proc watertemp {} {
	if {$::android == 1} {
		return $::de1(temperature)
	}
	return [expr {50+(rand() * 50)}]
}

proc pressure {} {
	if {$::android == 1} {
		return $::de1(pressure)
	}
	return [expr {(rand() * 3.5)}]
}

proc accelerometer_angle {} {
	return $::settings(accelerometer_angle)
}



proc group_head_heater_temperature {} {
	if {$::android == 1} {
		return $::de1(group_temperature)
	}

	global fake_group_temperature
	if {[info exists fake_group_temperature] != 1} {
		set fake_group_temperature 20
	}

	set fake_group_temperature [expr {int($fake_group_temperature + (rand() * 5))}]
	if {$fake_group_temperature > $::settings(espresso_temperature)} {
		set fake_group_temperature $::settings(espresso_temperature)
	}
	return $fake_group_temperature
}

proc steam_heater_temperature {} {
	if {$::android == 1} {
		return $::de1(steam_heater_temperature)
	}

	global fake_steam_temperature
	if {[info exists fake_steam_temperature] != 1} {
		set fake_steam_temperature 20
	}

	set fake_steam_temperature [expr {int($fake_steam_temperature + (rand() * 10))}]
	if {$fake_steam_temperature > $::settings(steam_temperature)} {
		set fake_steam_temperature $::settings(steam_temperature)
	}


	return $fake_steam_temperature
}





#################
# formatting DE1 numbers into pretty text

proc steam_heater_action_text {} {
	set delta [expr {int([steam_heater_temperature] - [setting_steam_temperature])}]
	if {$delta < -2} {
		return [translate "Heating:"]
	} elseif {$delta > 2} {
		return [translate "Cooling:"]
	} else {
		return [translate "Ready:"]
	}
}

proc group_head_heater_action_text {} {
	set delta [expr {int([group_head_heater_temperature] - [setting_espresso_temperature])}]
	if {$delta < -2} {
		return [translate "Heating:"]
	} elseif {$delta > 2} {
		return [translate "Cooling:"]
	} else {
		return [translate "Ready:"]
	}
}

proc timer_text {} {
	return [subst {[timer] [translate "seconds"]}]
}

proc waterflow_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_two_digits [waterflow]] [translate "ml/s"]}]
	} else {
		return [subst {[round_to_two_digits [ml_to_oz [waterflow]]] "oz/s"}]
	}
}

proc watervolume_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_one_digits [watervolume]] [translate "ml"]}]
	} else {
		return [subst {[round_to_one_digits [ml_to_oz [watervolume]]] oz}]
	}
}

proc watertemp_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_one_digits [watertemp]]ºC}]
	} else {
		return [subst {[round_to_one_digits [celsius_to_fahrenheit [watertemp]]]ºF]}]
	}
}

proc steamtemp_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_integer [steamtemp]]ºC}]
	} else {
		return [subst {[round_to_integer [celsius_to_fahrenheit [steamtemp]]]ºF]}]
	}
}

proc pressure_text {} {
	return [subst {[round_to_two_digits [pressure]] [translate "bars"]}]
}


#######################
# settings
proc setting_steam_max_time {} {
	return $::settings(steam_max_time)
}
proc setting_water_max_time {} {
	return $::settings(water_max_time)
}
proc setting_espresso_max_time {} {
	return $::settings(espresso_max_time)
}
proc setting_steam_max_time_text {} {
	return [subst {[setting_steam_max_time] [translate "seconds"]}]
}
proc setting_water_max_time_text {} {
	return [subst {[setting_water_max_time] [translate "seconds"]}]
}
proc setting_espresso_max_time_text {} {
	return [subst {[setting_espresso_max_time] [translate "seconds"]}]
}


proc setting_steam_temperature {} {
	return $::settings(steam_temperature)
}
proc setting_espresso_temperature {} {
	return $::settings(espresso_temperature)
}
proc setting_water_temperature {} {
	return $::settings(water_temperature)
}

proc setting_steam_temperature_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_integer [setting_steam_temperature]]ºC}]
	} else {
		return [subst {[round_to_integer [celsius_to_fahrenheit [setting_steam_temperature]]]ºF]}]
	}
}
proc setting_water_temperature_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_integer [setting_water_temperature]]ºC}]
	} else {
		return [subst {[round_to_integer [celsius_to_fahrenheit [setting_water_temperature]]]ºF]}]
	}
}



proc steam_heater_temperature_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_integer [steam_heater_temperature]]ºC}]
	} else {
		return [subst {[round_to_integer [celsius_to_fahrenheit [steam_heater_temperature]]]ºF]}]
	}
}

proc group_head_heater_temperature_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_integer [group_head_heater_temperature]]ºC}]
	} else {
		return [subst {[round_to_integer [celsius_to_fahrenheit [group_head_heater_temperature]]]ºF]}]
	}
}

proc setting_espresso_temperature_text {} {
	if {$::settings(measurements) == "metric"} {
		return [subst {[round_to_integer [setting_espresso_temperature]]ºC}]
	} else {
		return [subst {[round_to_integer [celsius_to_fahrenheit [setting_espresso_temperature]]]ºF]}]
	}
}

proc setting_espresso_pressure {} {
	return $::settings(espresso_pressure)
}
proc setting_espresso_pressure_text {} {
		return [subst {[round_to_one_digits [setting_espresso_pressure]] [translate "bar"]}]
}






#######################
# conversion functions

proc round_to_two_digits {in} {
    set x [expr {round($in * 100.0)/100.0}]
}

proc round_to_one_digits {in} {
    set x [expr {round($in * 10.0)/10.0}]
}

proc round_to_integer {in} {
    set x [expr {round($in)}]
}

proc celsius_to_fahrenheit {in} {
	return [expr {32 + ($in * 1.8)}]
}

proc ml_to_oz {in} {
	return [expr {$in * 0.033814}]
}
