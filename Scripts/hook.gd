extends Node2D
class_name Hook

@onready var colorRect = $ColorRect
@export var color: Color = Color()
var player : Player
var roof
var radius
var respawn_btn

enum HookState{
	IDLE,
	SHOOTING,
	HOOKED
}

var hookState = HookState.IDLE
var speed
var vel = Vector2(0,0)
var angle
var length

func _ready() -> void:
	radius = Global.HEIGHT/42
	speed = 700 * Global.HEIGHT/450
	player = get_parent().find_child('Player')
	roof = get_parent().find_child('Terrain').roof
	colorRect.size = Vector2(radius*2, radius*2)
	colorRect.position = Vector2(-radius,-radius)
	color = Global.color3
	colorRect.material.set_shader_parameter("color",color);
	respawn_btn = get_parent().find_child("CanvasLayer").find_child("Respawn Button")

func _process(delta: float) -> void:

	if(hookState == HookState.IDLE):
		position = player.position

	elif(hookState == HookState.SHOOTING):
		position += vel * delta
		checkCollision()

	elif(hookState == HookState.HOOKED):
		pass

func _input(event: InputEvent) -> void:
	if not respawn_btn.isTouchingUI():
		if(
			event.is_action_pressed("shootRight")
			or event is InputEventScreenTouch
			and event.is_pressed()
			and event.position.x > Global.WIDTH/2):
			if(hookState == HookState.HOOKED):
				hookState = HookState.IDLE
			else:
				hookState = HookState.SHOOTING
				vel.x = speed
				vel.y = -speed

		elif (
			event.is_action_pressed("shootLeft")
			or event is InputEventScreenTouch
			and event.is_pressed()
			and event.position.x < Global.WIDTH/2):
			if(hookState == HookState.HOOKED):
				hookState = HookState.IDLE
			else:
				hookState = HookState.SHOOTING
				vel.x = -speed
				vel.y = -speed

		elif (
			event.is_action_released("shootRight")
			or event is InputEventScreenTouch
			and event.is_released()):
			hookState = HookState.IDLE
		elif (
			event.is_action_released("shootLeft")
			or event is InputEventScreenTouch
			and event.is_released()):
			hookState = HookState.IDLE

func checkCollision():
	if(Global.circleInPolygon(position, radius, roof.polygon)):
			hookState = HookState.HOOKED
			#angle = -(player.position.angle_to_point(position) + PI/2)
			#length = position.distance_to(player.position)
			vel = Vector2.ZERO
