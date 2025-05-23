extends Label

func _process(_delta) -> void:
	position = get_parent().get_parent().global_position + Vector2(0,-50)
