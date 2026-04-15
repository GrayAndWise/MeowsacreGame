extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", mouseEntered)
	connect("mouse_exited",mouseExited)
	$"../text/animation".animation_finished.connect(TextDone)
	
func mouseEntered() -> void:
	add_theme_color_override("font_color", Color.RED)
	$"../AudioStreamPlayer2D".play()
	
func mouseExited() -> void:
	add_theme_color_override("font_color", Color.WHITE)

func _gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("gui_click"):
		if name == "newgame":
			get_tree().paused = true
			$"../text".visible = true
			$"../text/animation".play("show_text")
		elif name == "options":
			# We skip the animation and just go!
			get_tree().change_scene_to_file("res://settings.tscn")

func TextDone(animName : StringName) -> void:
	if name == "newgame":
		get_tree().paused = false
		var scene : PackedScene = load("res://night.tscn")
		get_tree().change_scene_to_packed(scene)
	elif name == "options":
		get_tree().paused = false
		var scene : PackedScene = load("res://settings.tscn")
		get_tree().change_scene_to_packed(scene)
