extends Label

var camerasOpen : bool = false

func _ready() -> void:
	mouse_entered.connect(mouseEntered)
	mouse_exited.connect(mouseExited)
	$"../../camera/roomSelect".visible=false


func mouseEntered() -> void:
	pass
	# show some hover state, cursor change etc

func mouseExited() -> void:
	pass
	# revert hover state

func _gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("gui_click"):
		camerasOpen = !camerasOpen
		if camerasOpen:
			openCameras()
		else:
			closeCameras()

func openCameras() -> void:
	$"../../camera".play()
	await $"../../camera".animation_finished
	$"../../camera/Static".visible = true
	$"../../camera/Static".play()
	$"../../camera/AnimatedSprite2D".play()
	$"../../camera/AudioStreamPlayer2D".play()
	$"../../camera/roomSelect".visible = true
	$"../../camera/ColorRect".visible = true
	$"../../camera/camMap".visible = true
	$"../../camera/cam1btn".visible = true
	$"../../camera/cam2btn".visible = true

func closeCameras() -> void:
	$"../../camera/AnimatedSprite2D".play()
	$"../../camera/Static".visible = false
	$"../../camera/Static".stop()
	$"../../camera/ColorRect".visible = false
	$"../../camera/camMap".visible = false
	$"../../camera/cam1btn".visible = false
	$"../../camera/cam2btn".visible = false
	$"../../camera/roomSelect".visible = false
	$"../../camera".play_backwards()
	
