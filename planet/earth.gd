extends MeshInstance3D

@export var speed: float

func _physics_process(delta):
	rotation.y -= speed * delta
