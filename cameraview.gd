extends AnimatedSprite2D

var targetFrame: int = 0
var currentFrame: int = 0  # Tracks which camera is active

func _ready() -> void:
	$cam1btn.mouse_entered.connect(func(): switchRoom(1))
	$cam2btn.mouse_entered.connect(func(): switchRoom(0))
	$AnimatedSprite2D.animation_finished.connect(func(): $roomSelect.frame = targetFrame)

func switchRoom(roomFrame: int) -> void:
	targetFrame = roomFrame
	$"../George".updateVisibility(roomFrame)
	
	# Step 1: Update camera frame immediately
	targetFrame = roomFrame
	currentFrame = roomFrame
	$roomSelect.frame = targetFrame  # instantly switch the visible camera

	# Step 2: Play glitch animation & sound
	$AnimatedSprite2D.play()
	$AudioStreamPlayer2D.play()
