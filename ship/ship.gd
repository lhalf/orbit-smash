extends Node2D

@export_category("Model")
@export var mesh: MeshInstance2D

@export_category("Movement")
@export var planet: Node2D
@export var gravity: float = -5.5
const DEFAULT_GRAVITY_INCREASE = -0.5
@export var gravity_increase: float = DEFAULT_GRAVITY_INCREASE
@export var velocity: Vector2

@export_category("Charge")
@export var charge_sound: AudioStreamPlayer2D
@export var charge_timer: Timer
const DEFAULT_CHARGE_TIMEOUT: int = 3
@export var charge_timeout: int = DEFAULT_CHARGE_TIMEOUT

@export_category("Animations")
@export var trail_particles: CPUParticles2D
@export var charge_particles: CPUParticles2D
@export var explode_particles: CPUParticles2D

@export_category("Scoring")
@export var score_distance_divider: int = 75

@export_category("Power ups")
# one timer so each time we get power up it resets
@export var power_up_timer: Timer

var initial_gravity: float

func _ready():
	PowerUps.infinite_charge.connect(update_charge_parameters)
	PowerUps.infinite_charge.connect(start_power_up_reset_timer)
	PowerUps.spike_ball.connect(explode)
	PowerUps.activate_laser.connect(
		func(): 
			%Laser.monitoring = true
			%LaserTimer.start()
			%LaserReadyParticles.show()
	)
	
	# move this somewhere else / think of better way of managing power up timeouts
	power_up_timer.connect("timeout", update_charge_parameters.bind(DEFAULT_CHARGE_TIMEOUT, DEFAULT_GRAVITY_INCREASE))
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
	if !charge_particles.emitting:
		charge_particles.emitting = true
	if charge_timeout == DEFAULT_CHARGE_TIMEOUT:
		charge_particles.color = charge_particles.color.darkened(0.01)
	if charge_timer.time_left < 1 and !%Warning.visible:
		%WarningSound.play()
		%Warning.show()
	if %Laser.monitoring and %LaserReadyParticles.visible:
		%LaserReadyParticles.hide()
	gravity += gravity_increase 
	%ShipMesh.set_physics_process(true)

func _off_charge():
	if charge_sound.playing:
		charge_sound.stop()
	if !charge_timer.is_stopped():
		charge_timer.stop()
	if charge_particles.emitting:
		charge_particles.emitting = false
		charge_particles.color = Color.WHITE
	if %Warning.visible:
		%Warning.hide()
	if %Laser.monitoring and !%LaserReadyParticles.visible:
		%LaserReadyParticles.show()
	gravity = initial_gravity
	%ShipMesh.set_physics_process(false)

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

func update_charge_parameters(timeout: int, charge_speed: float) -> void:
	charge_timeout = timeout
	gravity_increase = charge_speed
	# force new charge timeout on timer
	if !charge_timer.is_stopped():
		charge_timer.stop()

func start_power_up_reset_timer(_timeout, _speed) -> void:
	# reset power up timeout if a new one starts
	if !power_up_timer.is_stopped():
		power_up_timer.stop()
	power_up_timer.start()

func _on_charge_timer_timeout():
	explode()

func explode() -> void:
	explode_particles.emitting = true
	trail_particles.hide()
	charge_particles.hide()
	mesh.hide()
	%ChargeSound.stop()
	%ExplodeSound.play()
	%Indicator.hide()
	%Warning.hide()
	%ShipArea.set_deferred("monitoring", false)
	set_physics_process(false)

func _on_explode_finished():
	Messenger.game_over.emit()

func _on_laser_area_entered(area: Area2D) -> void:
	if area is MeteorArea and charge_timer.is_stopped():
		%LaserSound.play()
		%LaserParticles.emitting = true
		$Laser/LaserAnimations.play("fire")
		_handle_meteor_impact(area.owner)

func _on_laser_timer_timeout() -> void:
	%Laser.monitoring = false
	%LaserReadyParticles.hide()
