extends Node2D
class_name Hook

@onready var colorRect = $ColorRect
@export var radius: float = 12
@export var color: Color = Color()
var player : Player
var roof

enum HookState{
	IDLE,
	SHOOTING,
	HOOKED
}

var hookState = HookState.IDLE
var speed = 700
var vel = Vector2(0,0)
var angle
var length

func _ready() -> void:
	player = get_parent().find_child('Player')
	roof = get_parent().find_child('Terrain').roof
	colorRect.size = Vector2(radius, radius)
	colorRect.position = Vector2(-radius/2,-radius/2)
	colorRect.material.set_shader_parameter("color",color);

func _process(delta: float) -> void:
	
	if(hookState == HookState.IDLE):
		position = player.position
		
	elif(hookState == HookState.SHOOTING):
		position += vel * delta
		checkCollision()
		
	elif(hookState == HookState.HOOKED):
		pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shootRight"):
		if(hookState == HookState.HOOKED):
			hookState = HookState.IDLE
		else:
			hookState = HookState.SHOOTING
			vel.x = speed
			vel.y = -speed
			
	elif event.is_action_pressed(("shootLeft")):
		if(hookState == HookState.HOOKED):
			hookState = HookState.IDLE
		else:
			hookState = HookState.SHOOTING
			vel.x = -speed
			vel.y = -speed
			
	elif event.is_action_released("shootRight"):
		hookState = HookState.IDLE
	elif event.is_action_released("shootLeft"):
		hookState = HookState.IDLE

func checkCollision():
	if(Global.pointInPolygon(position, roof.polygon)):
			hookState = HookState.HOOKED
			angle = -(player.position.angle_to_point(position) + PI/2)
			length = position.distance_to(player.position)
			vel = Vector2.ZERO
