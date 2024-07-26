extends Node

@export var initial_text: String = "Score: "
var current: int = 0
var current_text: String

@export var initial_hiscore_text: String = "Hiscore: "

signal added(amount)
signal update_text(new_text)

func _ready():
	if not highscore_exists():
		save_highscore()
	current_text = initial_text + str(current)
	added.connect(_on_score_added)

func _on_score_added(amount):
	current += amount
	current_text = initial_text + str(current)
	update_text.emit(current_text)

func reset() -> void:
	current = 0
	current_text = initial_text + str(current)

func highscore_exists() -> bool:
	return FileAccess.file_exists("user://highscore.save")

func save_highscore() -> void:
	FileAccess.open("user://highscore.save", FileAccess.WRITE).store_16(current)

func load_highscore() -> int:
	return FileAccess.open("user://highscore.save", FileAccess.READ_WRITE).get_16()
