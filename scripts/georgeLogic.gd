extends Node

@onready var label =  $"../CanvasLayer/Label" # Label is the parent
var doorOpen = false
enum Room { CAM1, CAM2, OFFICE_DOOR }
var currentRoom : Room = Room.CAM2
var aiLevel : int = 12
var pathIndex : int = 0
var path = [1, 2, 3, 4, 5, 6]
var lightOn = false
@onready var lightSprite = $doorAppear


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
		pathIndex = pathIndex + 1
		if pathIndex >=path.size():
			pathIndex = path.size() - 1
		$".".frame = path[pathIndex]
		if $".".frame in [1, 2, 3]:
			currentRoom = Room.CAM2
		elif $".".frame in [4, 5]:
			currentRoom = Room.CAM1
		elif $".".frame == 6:
			currentRoom = Room.OFFICE_DOOR
		if label.cameras_open:
			$"../camera/AnimatedSprite2D".play()
			$"../camera/AudioStreamPlayer2D".play()
		print("Kačiukas pajudėjo į priekį! Kambarys:", currentRoom, " Kadras:",
		 $".".frame)
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
	
	$"../lightButton".gui_input.connect(_on_light_button_input)
	lightSprite.visible = false
	
	

var jumpscaring: bool = false

func _on_light_button_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Tikras paspaudimas!")
			toggleLight()
	

func checkJumpscare() -> void:
	if jumpscaring:
		return
	
	await get_tree().create_timer(randf_range(0.7, 1.5)).timeout
	
	if doorOpen:
		print("Užblokuota! Durys uždarytos. Kačiukas bėga atgal į pradžią.")
		var startFrames = [1, 2, 3]
		var randomFrame = startFrames[randi() % startFrames.size()]
		pathIndex = randomFrame - 1
		currentRoom = Room.CAM2
		
		if lightOn:
			$".".frame = 0
			lightSprite.frame = 1
		else:
			$".".frame = randomFrame
			updateVisibility(get_node("../camera").currentCam)
		return
		
		
	await get_tree().create_timer(randf_range(0.7, 1.5)).timeout
	if doorOpen:
		print("Spėjai uždaryti! Kačiukas bėga atgal.")
		var startFrames = [1, 2, 3]
		var randomFrame = startFrames[randi() % startFrames.size()]
		pathIndex = randomFrame - 1
		currentRoom = Room.CAM2
		updateVisibility(get_node("../camera").currentCam)
		
		if lightOn:
			$".".frame = 0
			lightSprite.frame = 1
		else:
			$".".frame = randomFrame
			updateVisibility(get_node("../camera").currentCam)
		return
	
	jumpscaring = true
	get_tree().paused = true
	get_node("../CanvasLayer/Label").force_close_cameras()
	$".".visible = true
	$".".frame = 0
	$jumpscare.visible = true
	$jumpscare.play()
	
	await get_tree().create_timer(2).timeout
	$jumpscaresound.play()
	
	await get_tree().create_timer(4).timeout
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://gameOver_screen.tscn")
	
func updateVisibility(currentCam: int) -> void:
	if lightOn:
		return
	if jumpscaring:
		$".".visible = true
		return
	if label == null or !label.cameras_open:
		$".".visible = false
		return
	if currentRoom == Room.CAM1 and currentCam == 1:
		$".".visible = true 
	elif currentRoom == Room.CAM2 and currentCam == 0:
		$".".visible = true
	else:
		$".".visible = false
		
func toggleLight() -> void:
	lightOn = !lightOn
	
	if lightOn:
		$".".visible = true
		lightSprite.visible = true
		
		if currentRoom == Room.OFFICE_DOOR:
			lightSprite.frame = 0
			$".".frame = path[pathIndex]
		else:
			lightSprite.frame = 1 # Rodo šviesą be akių
			$".".frame = 0
	else:
		lightSprite.visible = false
		$".".frame = path[pathIndex]
		updateVisibility(get_node("../camera").currentCam)
	
func force_toggle_door() -> void:
	if doorOpen:
		$"../door".play_backwards()
		$"../doorButton".texture.current_frame = 0
		$"../doorButton".mouse_filter = Control.MOUSE_FILTER_IGNORE
		doorOpen = false

func win() -> void:
	get_tree().change_scene_to_file("res://win.tscn")
