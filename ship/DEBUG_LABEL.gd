extends Label

func _process(_delta) -> void:
	text = str(get_parent().time_left).substr(0,3)
	position = get_parent().get_parent().global_position + Vector2(0,-50)
