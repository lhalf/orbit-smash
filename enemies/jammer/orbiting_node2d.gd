class_name OrbitingNode2D extends Node2D

@export var orbit_target: Node2D
@export var orbit_speed: float = 0.5

var angle := 0.0
var orbit_radius := 0.0

func _ready() -> void:
	var offset = position - orbit_target.position
	orbit_radius = offset.length()
	angle = offset.angle()

func _physics_process(delta: float) -> void:
	angle += orbit_speed * delta

	position = orbit_target.position + Vector2(
		cos(angle) * orbit_radius,
		sin(angle) * orbit_radius
	)

	rotation = (orbit_target.position - position).angle() + (90 * PI/180)
