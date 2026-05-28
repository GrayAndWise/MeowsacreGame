extends AnimatedSprite2D

@onready var label = $"../CanvasLayer/Label" # Kamerų valdymo mazgas

enum Room { CAM2, CAM4, CAM5 }
var currentRoom : Room = Room.CAM2

var aiLevel : int = 10
var pathIndex : int = 0

# Tikrieji kadrai, kuriuos naudoja Sirena
var path = [0, 1, 2, 3]
var walkingForward : bool = true # Kontroliuoja, ar ji eina pirmyn, ar grįžta atgal

var roomFrames = {
	Room.CAM2: [0],
	Room.CAM4: [1, 2],
	Room.CAM5: [3]
}

func _ready() -> void:
	$sirenTimer.timeout.connect(tryMove)
	$sirenTimer.start()
	$".".frame = 0
	currentRoom = Room.CAM2
	updateVisibility(get_node("../camera").currentCam)

func tryMove() -> void:
	if randi() % 20 < aiLevel:
		
		# --- Judėjimo logika pirmyn / atgal ---
		if walkingForward:
			pathIndex += 1
			# Jei pasiekė galą (kadras 3, indeksas 3), kitą kartą ji eis atgal
			if pathIndex >= path.size():
				pathIndex = path.size() - 2 # Nukreipiam į kadrą 2
				walkingForward = false
		else:
			pathIndex -= 1
			# Jei grįžo į pradžią (kadras 0, indeksas 0), vėl eis pirmyn
			if pathIndex < 0:
				pathIndex = 1 # Nukreipiam į kadrą 1
				walkingForward = true
		
		# Nustatom kadrą iš masyvo
		$".".frame = path[pathIndex]
		
		# --- Kambarių nustatymas pagal kadrus ---
		if $".".frame in [0]:
			currentRoom = Room.CAM2
		elif $".".frame in [1, 2]:
			currentRoom = Room.CAM4
		elif $".".frame == 3:
			currentRoom = Room.CAM5
			
		if label.cameras_open:
			$"../camera/AnimatedSprite2D".play()
			$"../camera/AudioStreamPlayer2D".play()
			
		print("Sirena katytė pajudėjo! Kambarys: ", Room.keys()[currentRoom], " Kadras: ", $".".frame)
		
		# Atnaujinam matomumą ekrane
		updateVisibility(get_node("../camera").currentCam)

func updateVisibility(currentCam: int) -> void:
	if label == null or !label.cameras_open:
		$".".visible = false
		return
		
	# Tikrinam pagal tavo nurodytus kamerų indeksus (CAM2 = 0, CAM4 = 1, CAM5 = 2)
	if currentRoom == Room.CAM2 and currentCam == 0:
		$".".visible = true 
	elif currentRoom == Room.CAM4 and currentCam == 2:
		$".".visible = true
	elif currentRoom == Room.CAM5 and currentCam == 3:
		$".".visible = true
	else:
		$".".visible = false
