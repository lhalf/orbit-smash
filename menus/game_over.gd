class_name GameOver extends Node2D

@onready var game_scene = load("res://game.tscn")
@export var hiscore_label: Label

func _ready() -> void:
	if Scores.current > Scores.load_highscore():
		Scores.save_highscore()
	hiscore_label.text = Scores.initial_hiscore_text + str(Scores.load_highscore())

func set_hiscore() -> void:
	pass

func _on_restart_pressed():
	Scores.reset()
	get_tree().call_deferred("change_scene_to_packed", game_scene)
