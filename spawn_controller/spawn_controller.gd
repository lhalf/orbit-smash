class_name SpawnController extends Node2D

@export var meteor_spawn_areas: Array[SpawnArea]
@export var power_spawn_areas: Array[SpawnArea]
@export var orbit_spawn_point: Marker2D
@export var planet: Node2D

@onready var meteor = preload("res://enemies/meteor/meteor.tscn")
@onready var power_up = preload("res://power_ups/power_up.tscn")
@onready var jammer = preload("res://enemies/jammer/jammer.tscn")

var rng = RandomNumberGenerator.new()

var last_jammer_at_score: int = 0

func _ready():
	Messenger.meteor_exploded.connect(new_spawns)
	PowerUps.nuke.connect(explode_all_meteors)
	spawn_meteor()
	
	# DEBUG
	Messenger.debug_spawn_meteor.connect(spawn_meteor)
	Messenger.debug_spawn_power_up.connect(spawn_power_up)
	Messenger.debug_spawn_jammer.connect(spawn_jammer)

func new_spawns() -> void:
	if meteor_count() < 10:
		spawn_meteor()
	if Scores.current % 3 == 0:
		spawn_meteor()
	if Scores.current % 5 == 0:
		spawn_power_up()
	if abs(Scores.current - last_jammer_at_score) > 50:
		if Scores.current % 15 == 0:
			last_jammer_at_score = Scores.current
			spawn_jammer()

func spawn_meteor() -> void:
	var meteor_object = meteor.instantiate()
	meteor_object.position = meteor_spawn_areas.pick_random().get_random_point()
	meteor_object.target_position = planet.global_position
	call_deferred("add_child", meteor_object)

func spawn_power_up() -> void:
	var power_up_object = power_up.instantiate()
	power_spawn_areas.shuffle()
	power_up_object.position = power_spawn_areas[0].get_random_point()
	power_up_object.target_position = power_spawn_areas[1].global_position
	call_deferred("add_child", power_up_object)

func spawn_jammer() -> void:
	# only can be one active jammer
	if is_jammer_active():
		return
	var jammer_object = jammer.instantiate()
	jammer_object.global_position = orbit_spawn_point.position
	jammer_object.orbit_target = planet
	call_deferred("add_child", jammer_object)

func explode_all_meteors() -> void:
	for node in get_children():
		if node is Meteor:
			node.explode(1)

func meteor_count() -> int:
	return get_children().filter(func(node): return node is Meteor).size()

func is_jammer_active() -> bool:
	return get_children().any(func(node): return node is Jammer)
