extends Node

signal nuke
signal infinite_charge(charge_timeout: int, charge_speed: float)
signal spike_ball
signal activate_shield
signal activate_laser
signal activate_mirror
signal activate_jammer

var shield_active = false
