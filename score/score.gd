class_name Score extends Node2D

@export var label: Label
@export var animation: AnimationPlayer

func pop_up(score: int):
	Scores.added.emit(score)
	label.text = "+" + str(score)
	animation.play("pop_up")
