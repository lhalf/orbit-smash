extends Node2D

@export var mesh: MeshInstance2D
@export var rotate_point: Node2D
@export var target: MeshInstance2D
@export var animation: AnimationPlayer

var off_screen: bool = true

func _process(_delta):
	if off_screen:
		if !mesh.visible:
			animation.play("grow")
			mesh.show()
		var clamp_position = global_position
		var camera_rect = get_viewport_rect()
		clamp_position.x = clamp(clamp_position.x, -camera_rect.size.x/2, camera_rect.size.x/2)
		clamp_position.y = clamp(clamp_position.y, -camera_rect.size.y/2, camera_rect.size.y/2)
		rotate_point.look_at(target.position)
		rotate_point.set_global_position(clamp_position)
	else:
		if mesh.visible:
			animation.play("RESET")
		mesh.hide()

func _when_off_screen():
	off_screen = true

func _when_on_screen():
	off_screen = false
