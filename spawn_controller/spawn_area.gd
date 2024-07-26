class_name SpawnArea extends Area2D

var rng = RandomNumberGenerator.new()

func get_random_point() -> Vector2:
	var width = $CollisionShape2D.shape.size.x
	var x = rng.randi_range(-width/2, width)
	var height = $CollisionShape2D.shape.size.y
	var y = rng.randi_range(-height/2, height)
	return position + Vector2(x,y)
