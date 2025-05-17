class_name ScoreLabel extends Label

func _ready() -> void:
	Scores.update_text.connect(update)
	text = Scores.current_text

func update(new_text: String) -> void:
	text = new_text
	%UIAnimations.play("score_pop")
