class_name Pulse extends Node2D

const FINAL_SCALE := Vector2(5,5)

var time := 1

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", FINAL_SCALE, time)
	tween.finished.connect(queue_free)
