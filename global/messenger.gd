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

	if Input.is_key_pressed(KEY_O):
		print("DEBUG: spawning meteor")
		debug_spawn_meteor.emit()
