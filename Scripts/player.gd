@tool
extends Node2D
class_name Player

@onready var colorRect = $ColorRect
@onready var hook : Hook = get_parent().find_child('Hook')
@export var radius: float = 36
@export var color: Color = Color()

enum PlayerState {
	FLOATING,
	FALLING,
	SWINGING
}
var playerState = PlayerState.FLOATING
var counter = 0

var acc = Vector2(0,0)
var vel = Vector2(0,0)
var angAcc
var angVel
var prevPosition = Vector2(0,0)

var boostIn = 1
var boostOut = 1.2
var lastDelta

func _ready() -> void:
	colorRect.size = Vector2(radius, radius)
	colorRect.position = Vector2(-radius/2,-radius/2)
	colorRect.material.set_shader_parameter('color',color)

func _process(delta):
	if not Engine.is_editor_hint():

		if(playerState == PlayerState.FLOATING):
			position.y = sin(counter*7) * 10

		elif(playerState == PlayerState.FALLING):
			acc.y = Global.GRAVITY
			vel += acc * delta
			prevPosition = position
			position += vel * delta

			if(hook.hookState == Hook.HookState.HOOKED):
				playerState = PlayerState.SWINGING
				var prevAngle = -(prevPosition.angle_to_point(position) - PI/2)
				angVel = (vel.length() * sin(prevAngle - hook.angle) / hook.length) * boostIn
				vel = Vector2.ZERO

		elif(playerState == PlayerState.SWINGING):
			if(hook.hookState == Hook.HookState.HOOKED):
				angAcc = -Global.GRAVITY * sin(hook.angle) / hook.length
				angVel += angAcc * delta
				hook.angle += angVel * delta
				prevPosition = position
				position.x = hook.length * sin(hook.angle) + hook.position.x
				position.y = hook.length * cos(hook.angle) + hook.position.y
			else:
				playerState = PlayerState.FALLING
		counter += delta;
		lastDelta = delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('shootRight') or event.is_action_pressed('shootLeft'):
		if(playerState == PlayerState.FLOATING):
			playerState = PlayerState.FALLING
			
	elif event.is_action_released('shootRight') or event.is_action_released('shootLeft'):
		if playerState == PlayerState.SWINGING:
			playerState = PlayerState.FALLING
			var direction =  position - prevPosition 
			vel = (direction/lastDelta) * boostOut
	elif event.is_action_pressed("ui_select"):
		respawn()
		
func respawn():
	position.y = 0
	vel = Vector2.ZERO
	playerState = PlayerState.FLOATING
