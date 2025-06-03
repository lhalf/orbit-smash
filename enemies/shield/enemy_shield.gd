class_name EnemyShield extends MeshInstance2D

func _on_shield_area_entered(area: Area2D) -> void:
	if area is ShipArea:
		destroy()

func destroy() -> void:
	var tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/Opaticy", -1, 0.3)
	%ShieldArea.set_deferred("monitoring", false)
	%ExplosionSound.play()
	%ExplodeParticles.emitting = true

func _on_explode_particles_finished() -> void:
	queue_free()
