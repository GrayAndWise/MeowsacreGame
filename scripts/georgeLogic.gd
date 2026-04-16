extends Node

@onready var label =  $"../CanvasLayer/Label" # Label is the parent
var doorOpen = false
enum Room { CAM1, CAM2, OFFICE_DOOR }
var currentRoom : Room = Room.CAM2
var aiLevel : int = 15
var pathIndex : int = 0
var path = [Room.CAM1, Room.CAM2, Room.OFFICE_DOOR]

var roomFrames = {
	Room.CAM1: [4, 5],
	Room.CAM2: [1, 2, 3],
	Room.OFFICE_DOOR: [6]
}

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("gui_click"):
		toggleDoor()

func toggleDoor() -> void:
	if doorOpen:
		$"../door".play_backwards()
		$"../doorButton".texture.current_frame = 0
		doorOpen = false
	else:
		$"../door".play()
		$"../doorButton".texture.current_frame = 1
		doorOpen = true
	
	
func tryMove() -> void:
	if randi() % 20 < aiLevel:
		var move = randi() % 3 - 1  # -1, 0, or +1
		pathIndex = clamp(pathIndex + move, 0, path.size() - 1)
		currentRoom = path[pathIndex]
		var frames = roomFrames[currentRoom]
		$".".frame = frames[randi() % frames.size()]
		if label.cameras_open: 
			$"../camera/AnimatedSprite2D".play() # glitch
			$"../camera/AudioStreamPlayer2D".play() #glitch sound
		print("Current room:", currentRoom, " Frame:", $".".frame)
		if currentRoom == Room.OFFICE_DOOR:
			checkJumpscare()
		updateVisibility(get_node("../camera").currentCam)
			
			
func _ready() -> void:
	$georgeTimer.timeout.connect(tryMove)
	$georgeTimer.start()
	$jumpscare.visible=false
	$"../doorButton".gui_input.connect(_gui_input)
	$".".frame=1;
	updateVisibility(get_node("../camera").currentCam)

var jumpscaring: bool = false

func checkJumpscare() -> void:
	if $".".frame == 6 and !doorOpen and !jumpscaring:
		jumpscaring = true
		get_node("../CanvasLayer/Label").force_close_cameras()
		$".".visible=true
		$".".frame=0
		$jumpscare.visible = true
		$jumpscare.play()
		await get_tree().create_timer(2).timeout
		$jumpscaresound.play()
		$"../doorButton".mouse_filter = Control.MOUSE_FILTER_IGNORE
		$"../CanvasLayer/Label".visible=false
	
func updateVisibility(currentCam: int) -> void:
	if currentRoom == Room.CAM1 and currentCam == 1:
		$".".visible = true 
	elif currentRoom == Room.CAM2 and currentCam == 0:
		$".".visible = true
	elif currentRoom == Room.OFFICE_DOOR and currentCam == 1:
		$".".visible = true
	else:
		$".".visible = false
		
func force_toggle_door() -> void:
	if doorOpen:
		$"../door".play_backwards()
		$"../doorButton".texture.current_frame = 0
		$"../doorButton".mouse_filter = Control.MOUSE_FILTER_IGNORE
		doorOpen = false
