extends Label

var cameras_open: bool = false

@onready var camera = $"../../camera"
@onready var static_sprite = camera.get_node("Static")
@onready var anim_sprite = camera.get_node("AnimatedSprite2D")
@onready var audio_player = camera.get_node("AudioStreamPlayer2D")
@onready var Office = $"../.."
@onready var george = Office.get_node("George")
@onready var ui_nodes = [
	camera.get_node("roomSelect"),
	camera.get_node("ColorRect"),
	camera.get_node("camMap"),
	camera.get_node("cam1btn"),
	camera.get_node("cam2btn"),
]

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	set_camera_ui_visible(false)
	george.visible = false

func _on_mouse_entered() -> void:
	pass

func _on_mouse_exited() -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("gui_click"):
		toggle_cameras()

func toggle_cameras() -> void:
	cameras_open = !cameras_open
	if cameras_open:
		open_cameras()
	else:
		close_cameras()

func set_camera_ui_visible(state: bool) -> void:
	for node in ui_nodes:
		node.visible = state

func open_cameras() -> void:
	camera.play()
	await camera.animation_finished
	static_sprite.visible = true
	static_sprite.play()
	anim_sprite.play()
	audio_player.play()
	set_camera_ui_visible(true)
	george.updateVisibility(camera.currentCam)

func close_cameras() -> void:
	anim_sprite.play()
	static_sprite.visible = false
	static_sprite.stop()
	set_camera_ui_visible(false)
	george.visible = false
	camera.play_backwards()
