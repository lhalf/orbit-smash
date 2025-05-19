extends Control

@export var text: String = "ORBIT SMASH            "
@export var radius: float = 150.0
@export var angular_speed: float = 1.0

@export var font: Font
@export var font_size: int = 24

var angle_offsets = []
var labels = []

func _ready():
	var angle_step = TAU / text.length()
	for i in text.length():
		var char_label = Label.new()
		char_label.text = text[i]

		if font:
			var custom_theme = Theme.new()
			custom_theme.set_font("font", "Label", font)
			custom_theme.set_font_size("font_size", "Label", font_size)
			char_label.theme = custom_theme

		add_child(char_label)
		labels.append(char_label)
		angle_offsets.append(i * angle_step)

func _process(_delta):
	var time = Time.get_ticks_msec() / 1000.0

	for i in labels.size():
		var angle = angle_offsets[i] + time * angular_speed
		var pos = Vector2.ZERO + Vector2(cos(angle), sin(angle)) * radius
		labels[i].position = pos
		labels[i].rotation = angle + PI / 2
