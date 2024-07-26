class_name Meteor extends Node2D

@export_category("Movement")
@export var speed: float = 0.0005

@export_category("Object")
@export var area: MeteorArea
@export var mesh: MeshInstance2D
@export var mesh_3d: Node3D

@export_category("Animations")
@export var explosion: CPUParticles2D
@export var score_animation: AnimationPlayer
@export var explode_sound: AudioStreamPlayer

@export_category("Score")
@export var score: Score

signal exploded

var target_position: Vector2
var t: float = 0.0

func _ready():
	explosion.connect("finished", queue_free)

func _physics_process(delta):
	t += delta * speed
	position = position.lerp(target_position, t)

func explode(with_score: int):
	score.pop_up(with_score)
	area.monitoring = false
	set_physics_process(false)
	mesh.hide()
	explosion.emitting = true
	explode_sound.play()
