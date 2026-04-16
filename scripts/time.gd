extends Node

var time_seconds: int = 0
var power: float = 100.0

@onready var label =  $"../CanvasLayer/Label" # Label is the parent
@onready var george = $"../George"  # up to Office, then George
@onready var time_label = $TimeLabel  # adjust path
@onready var power_label = $PowerLabel  # adjust path


func _ready() -> void:
	$GameTimer.wait_time = 1.0
	$GameTimer.timeout.connect(_on_tick)
	$GameTimer.start()

func _on_tick() -> void:
	time_seconds += 1
	
	var drain = 0.05
	if label.cameras_open: drain += 0.5
	if george.doorOpen: drain += 0.5
	power = max(power - drain, 0.0)
	
	time_label.text = get_time_string()
	power_label.text = "Power: " + str(snappedf(power, 0.1)) + "%"
	
	if power<=0:
		george.force_toggle_door()


func get_time_string() -> String:
	var hour = 12 + (time_seconds / 60)
	if hour > 12: hour -= 12
	return str(hour) + " AM"
