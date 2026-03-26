extends Control


func _ready() -> void:
	$CanvasLayer/ColorRect/Label/AnimationPlayer.animation_finished.connect(fadeDone)
	$CanvasLayer/ColorRect/Label/AnimationPlayer.play("fade_out")
	$CanvasLayer/ColorRect/AnimatedSprite2D.play()
	$CanvasLayer/ColorRect/AnimatedSprite2D.visible = true
	$CanvasLayer/ColorRect/AnimatedSprite2D.play("default")

func fadeDone(animName : StringName) -> void:
	var scene : PackedScene = load("res://office.tscn") 
	get_tree().change_scene_to_packed(scene)
