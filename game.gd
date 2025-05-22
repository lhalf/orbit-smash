extends Node2D

func _ready() -> void:
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
	%Planet.put_up_shield()
