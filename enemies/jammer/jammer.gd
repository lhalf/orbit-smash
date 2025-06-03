class_name Jammer extends OrbitingNode2D

const FADE_IN_TIME: int = 3

func _enter_tree() -> void:
	scale = Vector2(0,0)

func _ready() -> void:
	super._ready()
	orbit_speed = 0.0
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "scale", Vector2(1,1), FADE_IN_TIME)
	var speed_tween = create_tween()
	speed_tween.tween_property(self, "orbit_speed", 0.4, FADE_IN_TIME)
