extends MeshInstance3D

@export var speed: float

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta):
	rotation.y -= speed * delta
