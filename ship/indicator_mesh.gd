extends MeshInstance3D

func _physics_process(delta):
	rotation.x -= 3 * delta
