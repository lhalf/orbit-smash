class_name Planet extends Node2D

@export var planet_area: PlanetArea
@export var mesh: MeshInstance2D
@export var explode: CPUParticles2D

@onready var game_over_scene = preload("res://menus/game_over.tscn")

func _on_planet_area_entered(area):
	if area is MeteorArea:
		area.owner.call_deferred("queue_free")
		mesh.hide()
		explode.emitting = true

func _on_explode_finished():
	get_tree().call_deferred("change_scene_to_packed", game_over_scene)
