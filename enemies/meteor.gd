class_name Meteor extends Node2D

@export_category("Movement")
@export var speed: float = 0.0005

@export_category("Object")
@export var area: MeteorArea
@export var mesh: MeshInstance2D
@export var mesh_3d: Node3D

@export_category("Animations")
@export var explosion: CPUParticles2D
@export var explode_sound: AudioStreamPlayer2D

@export_category("Score")
@export var score: Score

var target_position: Vector2
var t: float = 0.0

func _ready():
	# so there is only one viewport, we load from a global one
	mesh.texture = MeteorViewport.get_texture()
	mesh.rotation_degrees = randi_range(0, 360)
	var scale_value = randf_range(1, 1.5)
	scale = Vector2(scale_value, scale_value)
	explode_sound.pitch_scale = explode_sound.pitch_scale - (scale_value / 8)
	explosion.connect("finished", queue_free)

func _physics_process(delta):
	t += delta * speed
	position = position.lerp(target_position, t)

func explode(with_score: int):
	score.pop_up_score(with_score)
	area.monitoring = false
	# prevents shield from picking up area of meteors
	area.set_deferred("monitorable", false)
	set_physics_process(false)
	mesh.hide()
	explosion.emitting = true
	explode_sound.play()
	Messenger.meteor_exploded.emit()
