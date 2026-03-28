extends Node

enum Room { CAM1, CAM2, OFFICE_DOOR }
var currentRoom : Room = Room.CAM1
var aiLevel : int = 20
var pathIndex : int = 0
var path = [Room.CAM1, Room.CAM2, Room.OFFICE_DOOR]

var roomFrames = {
	Room.CAM1: [0, 1, 2],
	Room.CAM2: [3, 4],
	Room.OFFICE_DOOR: [5]
}

func tryMove() -> void:
	if randi() % 20 < aiLevel:
		pathIndex = min(pathIndex + 1, path.size() - 1)
		currentRoom = path[pathIndex]
		var frames = roomFrames[currentRoom]
		$".".frame = frames[randi() % frames.size()]
		if currentRoom == Room.OFFICE_DOOR:
			checkJumpscare()
			
			
func _ready() -> void:
	$georgeTimer.timeout.connect(tryMove)
	$georgeTimer.start()

func checkJumpscare() -> void:
	pass # check if door is closed, if not, jumpscare
	
	
func updateVisibility(currentCam: int) -> void:
	if currentRoom == Room.CAM1 and currentCam == 1:
		$".".visible = true
	elif currentRoom == Room.CAM2 and currentCam == 2:
		$".".visible = true
	else:
		$".".visible = false
