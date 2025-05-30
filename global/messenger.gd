extends Node

var playing = false

signal game_over
signal meteor_exploded

signal debug_spawn_meteor
signal debug_spawn_power_up

#DEBUG
func _input(_event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if Input.is_key_pressed(KEY_O):
		print("DEBUG: spawning meteor")
		debug_spawn_meteor.emit()
	
	if Input.is_key_pressed(KEY_P):
		print("DEBUG: spawning power up")
		debug_spawn_power_up.emit()

	if Input.is_key_pressed(KEY_S):
		print("DEBUG: spawning shield")
		PowerUps.activate_shield.emit()
	
	if Input.is_key_pressed(KEY_L):
		print("DEBUG: activate lasers")
		PowerUps.activate_laser.emit()
	
	if Input.is_key_pressed(KEY_M):
		print("DEBUG: activate mirror")
		PowerUps.activate_mirror.emit()
