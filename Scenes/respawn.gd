extends ColorRect
var player
var touchingUI : bool = false
var radius = 20

func _ready() -> void:
	size.x = radius*2 * Global.HEIGHT/450
	size.y = radius*2 * Global.HEIGHT/450
	color = Global.color4
	material.set_shader_parameter('color',color)
	player = get_parent().get_parent().find_child("Player")

func _input(event: InputEvent) -> void:
	if (event is InputEventScreenTouch
		and event.is_pressed()):
			var distance = event.position.distance_to(position)
			print(distance)
			if distance < size.x:
				touchingUI = true
				player.respawn()
	if (event is InputEventScreenTouch
		and event.is_released()):
				touchingUI = false

func isTouchingUI():
	return touchingUI
