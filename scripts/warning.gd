extends Label

const menu : PackedScene = preload("res://title.tscn")
var canSkip : bool = false

func _ready() -> void:
	$timer.connect("timeout", timerTimeout)
	$animation.connect("animation_finished", animDone)
	$animation.play("fade_in")

func timerTimeout() -> void:
	$animation.play("fade_out")

func animDone(animName : StringName) -> void:
	if animName == "fade_in":
		canSkip = true
		$timer.start()
	if animName == "fade_out":
		get_tree().change_scene_to_packed(menu)

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("skip warning") and canSkip == true:
		$animation.play("fade_out")
