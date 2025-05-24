extends Label

func _ready() -> void:
	%HiScore.text = Scores.initial_hiscore_text + str(Scores.load_highscore())
	
