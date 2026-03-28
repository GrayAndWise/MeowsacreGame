extends Label

var cameras_open: bool = false

# --- Cache all relevant nodes ---
@onready var camera = $"../../camera"
@onready var static_sprite = camera.get_node("Static")
@onready var anim_sprite = camera.get_node("AnimatedSprite2D")
@onready var audio_player = camera.get_node("AudioStreamPlayer2D")
@onready var Office = $"../.."
@onready var ui_nodes = [
	camera.get_node("roomSelect"),
	camera.get_node("ColorRect"),
	camera.get_node("camMap"),
	camera.get_node("cam1btn"),
	camera.get_node("cam2btn"),
	Office.get_node("George")
	
]


func _ready() -> void:
	# connect signals properly
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	set_camera_ui_visible(false)

# --- Hover callbacks ---
func _on_mouse_entered() -> void:
	# optional: cursor change, highlight, etc
	pass

func _on_mouse_exited() -> void:
	# optional: revert hover effect
	pass

# --- Input handler ---
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("gui_click"):
		toggle_cameras()

# --- Toggle cameras ---
func toggle_cameras() -> void:
	cameras_open = !cameras_open
	if cameras_open:
		open_cameras()
	else:
		close_cameras()

# --- Unified UI toggle ---
func set_camera_ui_visible(state: bool) -> void:
	for node in ui_nodes:
		node.visible = state

# --- Open cameras with glitch/animation/audio ---
func open_cameras() -> void:
	camera.play()
	await camera.animation_finished  # wait for glitch animation to finish
	static_sprite.visible = true
	static_sprite.play()
	anim_sprite.play()
	audio_player.play()
	set_camera_ui_visible(true)

# --- Close cameras ---
func close_cameras() -> void:
	anim_sprite.play()
	static_sprite.visible = false
	static_sprite.stop()
	set_camera_ui_visible(false)
	camera.play_backwards()
