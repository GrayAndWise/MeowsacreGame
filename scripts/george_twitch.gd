extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$rest.connect("timeout",restTImeout)
	$twitch.connect("timeout",twitchTimeout)
	$fade.connect("timeout",fadeTimeout)
	restStart()

func restTImeout() -> void:
	frame= randi_range(1,6)
	twitchStart()
func twitchTimeout() -> void:
	frame=0
	restStart()

func restStart() -> void:
	$rest.wait_time = randf_range(0.3,4.0)	
	$rest.start()
	
func twitchStart() -> void:
	$twitch.wait_time= randf_range(0.02, 0.07)
	$twitch.start()

func fadeTimeout() -> void:
	modulate.a = randf_range(0.3,1.0)
	$"../Static".material.set_shader_parameter("alpha",randf_range(0.4,0.6))
