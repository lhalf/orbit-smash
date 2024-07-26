extends Label

func _process(_delta) -> void:
	text = str(get_parent().time_left)
	position = get_parent().get_parent().global_position
