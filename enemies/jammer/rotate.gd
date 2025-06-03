extends Node3D

func _physics_process(delta):
	rotation.z -= 0.8 * delta
