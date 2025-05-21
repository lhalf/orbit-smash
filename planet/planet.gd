class_name Planet extends Node2D

@export var planet_area: PlanetArea
@export var mesh: MeshInstance2D
@export var explode: CPUParticles2D

@onready var game_over_scene = preload("res://menus/game_over.tscn")

var has_shield: bool = false

func _on_planet_area_entered(area):
	if area is MeteorArea and mesh.visible:
		area.owner.call_deferred("queue_free")
		mesh.hide()
		explode.emitting = true

func _on_explode_finished():
	get_tree().call_deferred("change_scene_to_packed", game_over_scene)

func put_up_shield() -> void:
	if has_shield:
		return
