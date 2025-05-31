extends Node2D

const FADE_TIME: float = 0.5
const VISIBLE_COLOR: Color = Color(1,0.7,1,0.55)
const FADE_OUT_COLOR: Color = Color(1,0.7,1,0)

func update(ship_position: Vector2, ship_rotation_degrees: int, planet_position: Vector2) -> void:
	global_position = planet_position - ship_position
	global_rotation_degrees = ship_rotation_degrees + 180

func enable() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(%MirrorMesh.material, "shader_parameter/modulate_color", VISIBLE_COLOR, FADE_TIME)
	
	%MirrorArea.set_deferred("monitoring", true)
	%MirrorArea.set_deferred("monitorable", true)
	
	%MirrorTimer.start()

func disable() -> void:
	var tween = create_tween()
	tween.tween_property(%MirrorMesh.material, "shader_parameter/modulate_color", FADE_OUT_COLOR, FADE_TIME)
	tween.connect("finished", hide)
	
	%MirrorArea.set_deferred("monitoring", false)
	%MirrorArea.set_deferred("monitorable", false)
	
	set_laser_active(false)

func set_laser_active(enabled: bool) -> void:
	%MirrorLaser.set_deferred("monitoring", enabled)

func _on_mirror_timer_timeout() -> void:
	disable()
