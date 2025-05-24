extends Node2D

@onready var game_over_scene = preload("res://menus/game_over.tscn")

func _ready() -> void:
	Messenger.game_over.connect(game_over)
	if Messenger.playing:
		start()
	else:
		Music.process_mode = Node.PROCESS_MODE_ALWAYS
		%Menu.show()
		get_tree().paused = true
		fade_out(%Menu)

# this is called even after game over
func start() -> void:
	get_tree().paused = false
	%PlayButton.disabled = true
	Messenger.playing = true
	%Ship.show()
	fade_in(%Score)
	%Animations.play("zoom_out")
	PowerUps.shield_active = false
	%Planet.put_up_shield()

func game_over() -> void:
	%Animations.animation_finished.connect(func(_animation): get_tree().call_deferred("change_scene_to_packed", game_over_scene))
	fade_out(%Score)
	%Animations.play_backwards("zoom_out")

func fade_out(item: Control) -> void:
	var tween = create_tween()
	tween.tween_property(item, "modulate", Color(1,1,1,0), 0.5)
	tween.connect("finished", item.hide)

func fade_in(item: Control) -> void:
	item.modulate = Color(1,1,1,0)
	item.show()
	var tween = create_tween()
	tween.tween_property(item, "modulate", Color(1,1,1,1), 0.5)
