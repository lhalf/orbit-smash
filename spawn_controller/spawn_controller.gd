class_name SpawnController extends Node2D

@export var meteor_spawn_areas: Array[SpawnArea]
@export var power_spawn_areas: Array[SpawnArea]
@export var target: Node2D

@onready var meteor = preload("res://enemies/meteor.tscn")
@onready var power_up = preload("res://power_ups/power_up.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	Messenger.meteor_exploded.connect(new_spawns)
	PowerUps.nuke.connect(explode_all_meteors)
	Messenger.debug_spawn_meteor.connect(spawn_new)
	Messenger.debug_spawn_power_up.connect(spawn_power_up)
	spawn_new()

func new_spawns() -> void:
	if meteor_count() < 10:
		spawn_new()
	if Scores.current % 3 == 0:
		spawn_new()
	if Scores.current % 5 == 0:
		spawn_power_up()

func spawn_new() -> void:
	var meteor_object = meteor.instantiate()
	meteor_object.position = meteor_spawn_areas.pick_random().get_random_point()
	meteor_object.target_position = target.global_position
	call_deferred("add_child", meteor_object)

func spawn_power_up() -> void:
	var power_up_object = power_up.instantiate()
	power_spawn_areas.shuffle()
	power_up_object.position = power_spawn_areas[0].get_random_point()
	power_up_object.target_position = power_spawn_areas[1].global_position
	call_deferred("add_child", power_up_object)

func explode_all_meteors() -> void:
	for node in get_children():
		if node is Meteor:
			node.explode(1)

func meteor_count() -> int:
	return get_children().filter(func(node): return node is Meteor).size()
