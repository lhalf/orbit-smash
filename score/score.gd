class_name Score extends Node2D

@export var label: Label
@export var animation: AnimationPlayer

func pop_up_score(score: int):
	%ScoreArea.monitoring = true
	%ScoreArea.set_deferred("monitorable", true)
	Scores.added.emit(score)
	label.text = "+" + str(score)
	animation.play("pop_up")

#func _on_score_area_entered(area: Area2D) -> void:
	#if area is ScoreArea:
		#%MultiScoreSound.play()
		#hide()
		#var tween = create_tween()
		#tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)
