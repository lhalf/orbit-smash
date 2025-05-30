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

var current_power_up: _PowerUp

class _PowerUp:
	var function: Callable
	var texture: Texture
	var lifetime: int
	
	func _init(_function: Callable, _texture: Texture, _lifetime: int):
		function = _function
		texture = _texture
		lifetime = _lifetime

var available_power_ups = [
	_PowerUp.new(nuke_effect, NukeViewport.get_texture(), 7), 
	_PowerUp.new(infinite_charge_effect, InfiniteChargeViewport.get_texture(), 10),
	_PowerUp.new(shield_effect, ShieldViewport.get_texture(), 8),
	_PowerUp.new(spike_ball_effect, SpikeBallViewport.get_texture(), 7),
	_PowerUp.new(laser_effect, LaserViewport.get_texture(), 10),
	_PowerUp.new(mirror_effect, MirrorViewport.get_texture(), 10)
]

func _ready():
	current_power_up = available_power_ups[randi() % available_power_ups.size()]
	timer.wait_time = current_power_up.lifetime
	timer.connect("timeout", on_timeout)
	timer.start()
	mesh.texture = current_power_up.texture
	mesh.rotation_degrees = randi_range(0, 360)

func _physics_process(delta):
	t += delta * speed
	position = position.lerp(target_position, t)

func on_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), 1.0)
	tween.connect("finished", queue_free)

func on_hit():
	current_power_up.function.call()
	area.monitoring = false

func positive_effects() -> void:
	$Explode.emitting = true
	%PickUpSound.play()
	mesh.hide()
	set_physics_process(false)

func nuke_effect() -> void:
	positive_effects()
	# avoids explosion being scaled down when fading out, bit noddy
	var explosion_scene = explosion.instantiate()
	explosion_scene.global_position = position
	get_parent().add_child(explosion_scene)
	PowerUps.nuke.emit()

func infinite_charge_effect() -> void:
	positive_effects()
	PowerUps.infinite_charge.emit(2000, -1.5)

func shield_effect() -> void:
	positive_effects()
	if not PowerUps.shield_active:
		PowerUps.activate_shield.emit()

func spike_ball_effect() -> void:
	PowerUps.spike_ball.emit()

func laser_effect() -> void:
	positive_effects()
	PowerUps.activate_laser.emit()

func mirror_effect() -> void:
	positive_effects()
	PowerUps.activate_mirror.emit()
