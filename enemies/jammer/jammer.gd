class_name Jammer extends OrbitingNode2D

const FADE_IN_TIME: int = 3

@onready var pulse = preload("res://global/pulse.tscn")

func _enter_tree() -> void:
	scale = Vector2(0,0)

func _ready() -> void:
	super._ready()
	orbit_speed = 0.0
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "scale", Vector2(1,1), FADE_IN_TIME)
	var speed_tween = create_tween()
	speed_tween.tween_property(self, "orbit_speed", 0.4, FADE_IN_TIME)
	speed_tween.finished.connect(_on_pulse_timer_timeout)
	speed_tween.finished.connect(%PulseTimer.start)

func _on_shield_down() -> void:
	%JammerArea.set_deferred("monitoring", true)

func _on_jammer_area_entered(area: Area2D) -> void:
	if area is ShipArea:
		%PulseTimer.stop()
		%JammerArea.set_deferred("monitoring", false)
		%ExplosionSound.play()
		%JammerMesh.hide()
		%ExplodeParticles.emitting = true
		%SmokeParticles.emitting = true
		if %JamSound.playing:
			%JamSound.finished.connect(queue_free)
		else:
			%SmokeParticles.finished.connect(queue_free)

func _on_pulse_timer_timeout() -> void:
	%JamSound.play()
	PowerUps.activate_jammer.emit()
	var pulse_object = pulse.instantiate()
	add_child(pulse_object)
