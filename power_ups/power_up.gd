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

var target_position: Vector2
var t: float = 0.0

class _PowerUp:
	var function: Callable
	var texture: Texture
	
	func _init(_function: Callable, _texture: Texture):
		function = _function
		texture = _texture

var power_up: _PowerUp

var power_ups = [
	_PowerUp.new(nuke_effect, NukeViewport.get_texture()), 
	_PowerUp.new(infinite_charge_effect, InfiniteChargeViewport.get_texture()),
	_PowerUp.new(shield_effect, ShieldViewport.get_texture())
]

func _ready():
	timer.wait_time = timeout
	timer.connect("timeout", queue_free)
	timer.start()
	power_up = power_ups[randi() % power_ups.size()]
	mesh.texture = power_up.texture
	mesh.rotation_degrees = randi_range(0, 360)

func _physics_process(delta):
	t += delta * speed
	position = position.lerp(target_position, t)

func on_hit():
	$Explode.emitting = true
	%PickUpSound.play()
	power_up.function.call()
	area.monitoring = false
	set_physics_process(false)
	mesh.hide()

func nuke_effect() -> void:
	add_child(explosion.instantiate())
	PowerUps.nuke.emit()

func infinite_charge_effect() -> void:
	PowerUps.infinite_charge.emit(1000)

func shield_effect() -> void:
	if not PowerUps.shield_active:
		PowerUps.activate_shield.emit()
