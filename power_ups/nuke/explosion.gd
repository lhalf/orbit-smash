extends CPUParticles2D

func _ready() -> void:
	restart()

func _on_finished():
	queue_free()
