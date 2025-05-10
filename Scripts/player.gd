extends Sprite2D

enum PlayerState {
	FLOATING,
	FALLING,
	SWINGING
}
var playerState = PlayerState.FLOATING
var counter = 0

var acc = Vector2(0,0)
var vel = Vector2(0,0)

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		acc.x = -1000 
	elif Input.is_action_pressed("ui_right"):
		acc.x = 1000
	else: acc = Vector2(0,0)
	if(playerState == PlayerState.FLOATING):
		vel += acc * delta
		position.x += vel.x * delta
		position.y = sin(counter*7) * 10

	counter += delta;
