extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$background/TextureRect.visible = true
	await get_tree().create_timer(10).timeout
	get_tree().change_scene_to_file("res://title.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
