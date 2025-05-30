extends Area2D

func fire() -> void:
	%LaserSound.play()
	%Animations.play("fire_laser")
