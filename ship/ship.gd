extends Node2D

@export_category("Model")
@export var mesh: MeshInstance2D

@export_category("Movement")
@export var planet: Node2D
@export var gravity: float
@export var gravity_increase: float
@export var velocity: Vector2

@export_category("Charge")
@export var charge_sound: AudioStreamPlayer2D
@export var charge_timer: Timer
@export var charge_timeout: int = 3

@export_category("Animations")
@export var trail_particles: CPUParticles2D
@export var charge_particles: CPUParticles2D
@export var explode_particles: CPUParticles2D

@export_category("Scoring")
@export var score_distance_divider: int = 75

@export_category("Power ups")
# one timer so each time we get power up it resets
@export var power_up_timer: Timer

@onready var game_over_scene = preload("res://menus/game_over.tscn")

var initial_gravity: float

func _ready():
	PowerUps.infinite_charge.connect(update_charge_timeout)
	PowerUps.infinite_charge.connect(start_power_up_reset_timer)
	# move this somewhere else / think of better way of managing power up timeouts
	power_up_timer.connect("timeout", update_charge_timeout.bind(3))
	initial_gravity = gravity
	explode_particles.connect("finished", _on_explode_finished)

func _physics_process(delta):
	if Input.is_action_pressed("touch"):
		_on_charge()
	elif gravity < initial_gravity:
		_off_charge()
	_movement(delta)

func _on_charge():
	if !charge_sound.playing:
		charge_sound.play()
	if charge_timer.is_stopped():
		charge_timer.start(charge_timeout)
	gravity += gravity_increase 
	charge_particles.emitting = true

func _off_charge():
	if charge_sound.playing:
		charge_sound.stop()
	if !charge_timer.is_stopped():
		charge_timer.stop()
	gravity = initial_gravity
	charge_particles.emitting = false

func _movement(delta: float):
	position += velocity*delta
	var distance = position.length()
	velocity += (gravity * (position-planet.position) / distance) / distance*distance
	rotation = (position - planet.position).angle() + 178

func _on_area_entered(area):
	if not area.monitoring:
		return
	if area is MeteorArea:
		_handle_meteor_impact(area.owner)
	if area is PowerUpArea:
		_handle_power_up_impact(area.owner)

func _handle_meteor_impact(meteor: Meteor):
	var score = int(position.length()/score_distance_divider)
	score = 1 if score == 0 else score
	meteor.explode(score)

func _handle_power_up_impact(power_up: PowerUp):
	power_up.on_hit()

func update_charge_timeout(timeout: int) -> void:
	charge_timeout = timeout
	# force new charge timeout on timer
	if !charge_timer.is_stopped():
		charge_timer.stop()

func start_power_up_reset_timer(_ignore) -> void:
	# reset power up timeout if a new one starts
	if !power_up_timer.is_stopped():
		power_up_timer.stop()
	power_up_timer.start()

func _on_charge_timer_timeout():
	explode_particles.emitting = true
	trail_particles.hide()
	mesh.hide()

func _on_explode_finished():
	get_tree().call_deferred("change_scene_to_packed", game_over_scene)
