extends AnimatedSprite2D

@onready var label = $"../CanvasLayer/Label" # Kamerų valdymo mazgas

# Sukuriame kambarius tiksliai pagal tavo naują struktūrą
enum Room { CAM2, CAM4, CAM5, HIDDEN }
var currentRoom : Room = Room.CAM2

var aiLevel : int = 10
var pathIndex : int = 0

# Kelias per kadrus: 0, 1, 2, 3 ir nematomas 6
var path = [0, 1, 2, 3, 6]

func _ready() -> void:
	$sirenTimer.timeout.connect(tryMove)
	$sirenTimer.start()
	$".".frame = 0
	currentRoom = Room.CAM2
	updateVisibility(get_node("../camera").currentCam)

func tryMove() -> void:
	if randi() % 20 < aiLevel:
		pathIndex = pathIndex + 1
		if pathIndex >= path.size():
			# Pasiekus galą (kadrą 6), atsitiktinai bėga į pradžią: kadrą 0 arba 1
			var startFrames = [0, 1]
			pathIndex = startFrames[randi() % startFrames.size()]
			
		$".".frame = path[pathIndex]
		
		# --- Kambarių nustatymas pagal tavo nurodytus kadrus ---
		if $".".frame == 0:
			currentRoom = Room.CAM2
		elif $".".frame == 1:
			currentRoom = Room.CAM4
		elif $".".frame == 2:
			currentRoom = Room.CAM4
		elif $".".frame == 3:
			currentRoom = Room.CAM5
		elif $".".frame == 6:
			currentRoom = Room.HIDDEN
			
		if label.cameras_open:
			$"../camera/AnimatedSprite2D".play()
			$"../camera/AudioStreamPlayer2D".play()
			
		print("Sirena katytė pajudėjo į priekį! Kambarys:", currentRoom, " Kadras:", $".".frame)
		
		# Atnaujinam matomumą ekrane
		updateVisibility(get_node("../camera").currentCam)

func updateVisibility(currentCam: int) -> void:
	if label == null or !label.cameras_open:
		$".".visible = false
		return
		
	# Jei ji yra nematomoje būsenoje (kadras 6), išvis jos nerodom
	if currentRoom == Room.HIDDEN:
		$".".visible = false
		return
		
	# Tikrinam pagal tavo nurodytus kamerų indeksus (0, 1, 2):
	if currentRoom == Room.CAM2 and currentCam == 0:
		$".".visible = true 
	elif currentRoom == Room.CAM4 and currentCam == 1:
		$".".visible = true
	elif currentRoom == Room.CAM5 and currentCam == 2:
		$".".visible = true
	else:
		$".".visible = false
