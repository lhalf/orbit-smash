class_name PowerUp extends Node2D

# should this base class own all animations / types?
@onready var explosion = preload("res://power_ups/nuke/explosion.tscn")

@export_category("Movement")
@export var speed: float = 0.0005

@export_category("Object")
@export var area: PowerUpArea
@export var mesh: MeshInstance2D

@export_category("Lifetime")
@export var timer: Timer
@export var timeout: int = 10

var effect_function: Callable

var target_position: Vector2
var t: float = 0.0

func _ready():
	timer.wait_time = timeout
	timer.connect("timeout", queue_free)
	timer.start()
	effect_function = pick_random_effect()
	mesh.texture = NukeViewport.get_texture()

func pick_random_effect() -> Callable:
	var effects = [nuke_effect, infinite_charge_effect]
	return effects[randi() % effects.size()]

func _physics_process(delta):
	t += delta * speed
	position = position.lerp(target_position, t)

func on_hit():
	effect_function.call()
	area.monitoring = false
	set_physics_process(false)
	mesh.hide()

func nuke_effect() -> void:
	print("nuke effect")
	add_child(explosion.instantiate())
	PowerUps.nuke.emit()

func infinite_charge_effect() -> void:
	print("infinite charge effect")
	PowerUps.infinite_charge.emit(1000)
