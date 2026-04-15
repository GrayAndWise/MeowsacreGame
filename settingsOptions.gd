extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 1. Get the actual volume from the AudioServer (Bus 0 is "Master")
	var current_db = AudioServer.get_bus_volume_db(0)
	
	# 2. Convert that back to a 0-1 value so the slider can understand it
	# This ensures the slider "stays" where you last left it
	$MarginContainer/VBoxContainer/HSlider.value = db_to_linear(current_db)
	
	# 3. Do the same for the Mute checkbox
	$MarginContainer/VBoxContainer/CheckBox.button_pressed = AudioServer.is_bus_mute(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)


func _on_resolution_options_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://title.tscn")
