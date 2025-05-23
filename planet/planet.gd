class_name Planet extends Node2D

@export var planet_area: PlanetArea
@export var mesh: MeshInstance2D
@export var explode: CPUParticles2D
@onready var shield: ColorRect = %Shield
@onready var shield_area: Area2D = %ShieldArea
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	PowerUps.activate_shield.connect(put_up_shield)

func _on_planet_area_entered(area):
	if area is MeteorArea and mesh.visible:
		area.owner.call_deferred("queue_free")
		mesh.hide()
		explode.emitting = true

func _on_explode_finished():
	Messenger.game_over.emit()

func put_up_shield() -> void:
	if PowerUps.shield_active:
		return
	
	PowerUps.shield_active = true
	shield_area.set_deferred("monitoring", true)
	animation_player.play("spawn_shield")

func _on_shield_area_entered(area: Area2D) -> void:
	if area is MeteorArea:
		area.owner.call_deferred("explode", 0)
		shield_area.set_deferred("monitoring", false)
		shield.hide()
		PowerUps.shield_active = false
