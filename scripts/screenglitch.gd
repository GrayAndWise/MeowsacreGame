extends AnimatedSprite2D

@onready var audio = $AudioStreamPlayer2D

func _ready() -> void:
	audio.play()
	connect("animation_changed", onAnimationChanged)

func onAnimationChanged() -> void:
	audio.play()
