extends AnimatedSprite2D

var targetFrame : int = 0

func _ready() -> void:
	$cam1btn.mouse_entered.connect(func(): switchRoom(1))
	$cam2btn.mouse_entered.connect(func(): switchRoom(0))
	$AnimatedSprite2D.animation_finished.connect(func(): $roomSelect.frame = targetFrame)

func switchRoom(roomFrame: int) -> void:
	targetFrame = roomFrame
	$AnimatedSprite2D.play()
	$AudioStreamPlayer2D.play()
