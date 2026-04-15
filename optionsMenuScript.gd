extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".gui_input.connect(_gui_input)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("gui_click"):
		get_tree().paused = false
		var scene : PackedScene = load("res://settings.tscn")
		get_tree().change_scene_to_packed(scene)
