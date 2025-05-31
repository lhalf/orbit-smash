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

var initial_gravity: float

func _ready():
	PowerUps.infinite_charge.connect(activate_infinite_charge)
	PowerUps.activate_laser.connect(activate_laser)
	PowerUps.activate_mirror.connect(activate_mirror)
	PowerUps.spike_ball.connect(explode)
	
	# when explode is over
	explode_particles.connect("finished", _on_explode_finished)
	
	initial_gravity = gravity

func _physics_process(delta):
	if Input.is_action_pressed("touch"):
		_on_charge()
	elif gravity < initial_gravity:
		_off_charge()
	# we always do this regardless of it's visible so it appears in the correct location
	%Mirror.update(position, rotation_degrees, planet.position)
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
		trail_particles.color = trail_particles.color.darkened(0.01)
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
	if charge_timeout == DEFAULT_CHARGE_TIMEOUT:
		update_particle_color(Color.WHITE)
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
	rotation_degrees = rad_to_deg((position - planet.position).angle()) + 120

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

func _on_charge_timer_timeout():
	explode()

func explode() -> void:
	set_physics_process(false)
	explode_particles.emitting = true
	%SmokeParticles.emitting = true
	charge_timer.stop()
	trail_particles.hide()
	charge_particles.hide()
	mesh.hide()
	%ChargeSound.stop()
	%ExplodeSound.play()
	%Indicator.hide()
	%Warning.hide()
	%Laser.hide()
	%Laser.monitoring = false
	%Mirror.disable()
	%ShipArea.set_deferred("monitoring", false)
	%ShipArea.set_deferred("monitorable", false)

func _on_explode_finished():
	Messenger.game_over.emit()

# infinite charge

func activate_infinite_charge(timeout: int, charge_speed: float) -> void:
	update_particle_color(Color.PALE_GOLDENROD)
	charge_timeout = timeout
	gravity_increase = charge_speed
	%InfiniteChargeTimer.start()

func update_particle_color(color: Color) -> void:
	trail_particles.color = color
	charge_particles.color = color

func _on_infinite_charge_timer_timeout() -> void:
	update_particle_color(Color.WHITE)
	charge_timeout = DEFAULT_CHARGE_TIMEOUT
	gravity_increase = DEFAULT_GRAVITY_INCREASE

# laser

func activate_laser() -> void:
	%Laser.monitoring = true
	%LaserTimer.start()
	%LaserReadyParticles.show()
	if %Mirror.visible:
		%Mirror.set_laser_active(true)

func _on_laser_area_entered(area: Area2D) -> void:
	if area is MeteorArea and charge_timer.is_stopped():
		%Laser.fire()
		_handle_meteor_impact(area.owner)

func _on_laser_timer_timeout() -> void:
	%Laser.monitoring = false
	%LaserReadyParticles.hide()
	if %Mirror.visible:
		%Mirror.set_laser_active(false)

# mirror

func activate_mirror() -> void:
	%Mirror.enable()
	# if lasers already active, activate mirror laser
	if %Laser.monitoring:
		%Mirror.set_laser_active(true)

func _on_mirror_area_entered(area: Area2D) -> void:
	if not area.monitoring:
		return
	if area is MeteorArea:
		_handle_meteor_impact(area.owner)

func _on_mirror_laser_area_entered(area: Area2D) -> void:
	if area is MeteorArea and charge_timer.is_stopped():
		%MirrorLaser.fire()
		_handle_meteor_impact(area.owner)
