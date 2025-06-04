class_name EnemyShield extends MeshInstance2D

const INITIAL_OPACITY: float = -0.14
const FADE_OUT_OPACITY: float = -1

signal shield_down

func _ready() -> void:
	self.material.set_shader_parameter("Opaticy", INITIAL_OPACITY)

func _on_shield_area_entered(area: Area2D) -> void:
	if area is ShipArea:
		destroy()

func destroy() -> void:
	var tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/Opaticy", FADE_OUT_OPACITY, 0.3)
	%ShieldArea.set_deferred("monitoring", false)
	%ExplosionSound.play()
	%ExplodeParticles.emitting = true

func _on_explode_particles_finished() -> void:
	shield_down.emit()
	queue_free()
