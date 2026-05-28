extends AnimatedSprite2D

@onready var label = $"../CanvasLayer/Label" # Kamerų valdymo mazgas

enum Room { CAM2, CAM4, CAM5 }
var currentRoom : Room = Room.CAM2

var aiLevel : int = 10
var pathIndex : int = 0

# --- Ventiliacijos kintamieji (Nukopijuota nuo George durų) ---
var ventOpen = false

# Tikrieji kadrai, kuriuos naudoja Sirena judėjimui fone
var path = [0, 1, 2, 3]
var walkingForward : bool = true 

func _ready() -> void:
	$sirenTimer.timeout.connect(tryMove)
	$sirenTimer.start()
	$".".frame = 0
	currentRoom = Room.CAM2
	updateVisibility(get_node("../camera").currentCam)
	
	# Žaidimo pradžioje prijungiame Ventiliacijos mygtuką prie šio skripto
	if has_node("../ventButton"):
		$"../ventButton".gui_input.connect(_on_vent_button_input)

func tryMove() -> void:
	if randi() % 20 < aiLevel:
		
		# --- Judėjimo logika pirmyn / atgal ---
		if walkingForward:
			pathIndex += 1
			if pathIndex >= path.size():
				pathIndex = path.size() - 2 
				walkingForward = false
		else:
			pathIndex -= 1
			if pathIndex < 0:
				pathIndex = 1 
				walkingForward = true
		
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
		
		updateVisibility(get_node("../camera").currentCam)

func updateVisibility(currentCam: int) -> void:
	if label == null or !label.cameras_open:
		$".".visible = false
		return
		
	# Tikrinam pagal tavo tikruosius kamerų indeksus (CAM2=0, CAM4=3, CAM5=4)
	if currentRoom == Room.CAM2 and currentCam == 0:
		$".".visible = true 
	elif currentRoom == Room.CAM4 and currentCam == 3:
		$".".visible = true
	elif currentRoom == Room.CAM5 and currentCam == 4:
		$".".visible = true
	else:
		$".".visible = false

# --- Ventiliacijos valdymo funkcijos (Pagal George pavyzdį) ---

func _on_vent_button_input(event: InputEvent) -> void:
	# Tikrinam, ar žaidėjas paspaudė kairįjį pelės mygtuką ant ventButton
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggleVent()

func toggleVent() -> void:
	if ventOpen:
		# Pataisytas kelias pridėjus /office/
		$"../office/ventDoor".play_backwards() # Atidarome/atidengiame ventiliaciją
		if has_node("../office/ventButton") and $"../office/ventButton".texture:
			$"../office/ventButton".texture.current_frame = 0 # Grąžinam paprastą mygtuko kadrą
		ventOpen = false
		print("Ventiliacija atidaryta!")
	else:
		# Pataisytas kelias pridėjus /office/
		$"../office/ventDoor".play() # Uždarome ventiliaciją (pasirodo grotelės/durys)
		if has_node("../office/ventButton") and $"../office/ventButton".texture:
			$"../office/ventButton".texture.current_frame = 1 # Mygtukas pradeda šviesti
		ventOpen = true
		print("Ventiliacija uždaryta!")
