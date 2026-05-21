extends Node2D

@export var speed: float = 500.0
@export var edge_margin: float = 50.0 

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var window_width = get_viewport_rect().size.x
	
	var direction: float = 0.0
	
	# Mouse at Left Edge -> Shift entire world RIGHT
	if mouse_pos.x < edge_margin and position.x>330:
		direction = -1.0
		
	# Mouse at Right Edge -> Shift entire world LEFT
	elif mouse_pos.x > (window_width - edge_margin) and position.x < 630:
		direction = 1.0

	# Moving the single parent container moves all child sprites simultaneously!
	position.x += direction * speed * delta
