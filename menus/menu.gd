class_name Menu extends Node2D

@onready var game_scene = load("res://game.tscn")

func _on_start_pressed():
	get_tree().call_deferred("change_scene_to_packed", game_scene)
