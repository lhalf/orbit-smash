extends Node2D

@onready var game_over_scene = preload("res://menus/game_over.tscn")

func _ready() -> void:
	Messenger.game_over.connect(game_over)
	if Messenger.playing:
		start()
	else:
		get_tree().paused = true

func start() -> void:
	Messenger.playing = true
	get_tree().paused = false
	%Score.show()
	%Ship.show()
	%Title.hide()
	%PlayButtonContainer.hide()
	%Animations.play("zoom_out")
	PowerUps.shield_active = false
	%Planet.put_up_shield()

func game_over() -> void:
	%Animations.animation_finished.connect(func(_animation): get_tree().call_deferred("change_scene_to_packed", game_over_scene))
	%Animations.play_backwards("zoom_out")
