@tool
extends Node2D
class_name Player

@onready var colorRect = $ColorRect
@onready var hook : Hook = get_parent().find_child('Hook')
@export var color: Color = Color()
var radius
var respawn_btn

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
var damping = .9

var boostIn = 1
var boostOut = 1.2
var lastDelta

var roof
var soil

func _ready() -> void:
	radius = Global.HEIGHT/18
	colorRect.size = Vector2(radius*2, radius*2)
	colorRect.position = Vector2(-radius,-radius)
	color = Global.color3
	colorRect.material.set_shader_parameter('color',color)
	roof = get_parent().find_child('Terrain').roof
	soil = get_parent().find_child('Terrain').soil
	respawn_btn = get_parent().find_child("CanvasLayer").find_child("Respawn Button")

func _process(delta):
	if not Engine.is_editor_hint():

		if(playerState == PlayerState.FLOATING):
			position.y = sin(counter*7) * 10

		elif(playerState == PlayerState.FALLING):

			if(hook.hookState == Hook.HookState.HOOKED):
				vel += acc * delta
				prevPosition = position
				position += vel * delta
				hook.angle = -(position.angle_to_point(hook.position) + PI/2)
				hook.length = hook.position.distance_to(position)
				playerState = PlayerState.SWINGING
				var prevAngle = -(prevPosition.angle_to_point(position) - PI/2)
				angVel = (vel.length() * sin(prevAngle - hook.angle) / hook.length) * boostIn
				vel = Vector2.ZERO

			else:
				var collisionData = getCollisionData([soil.polygon, roof.polygon])

				if collisionData.isColliding:
					position += collisionData.normal * (radius - collisionData.distance)
					vel = vel.bounce(collisionData.normal) * damping

				vel += acc * delta
				prevPosition = position
				position += vel * delta

		elif(playerState == PlayerState.SWINGING):
			
			if(hook.hookState == Hook.HookState.HOOKED):
				if getCollisionData([roof.polygon, soil.polygon]).isColliding:
					#position = prevPosition
					angVel *= -1 #TODO not very well made
				else:
					angAcc = -Global.GRAVITY * sin(hook.angle) / hook.length
					angVel += angAcc * delta
				hook.angle += angVel * delta
				prevPosition = position
				position.x = hook.length * sin(hook.angle) + hook.position.x
				position.y = hook.length * cos(hook.angle) + hook.position.y

			else:
				playerState = PlayerState.FALLING
				acc.y = Global.GRAVITY
		counter += delta;
		lastDelta = delta

func _input(event: InputEvent) -> void:
	if not respawn_btn.isTouchingUI():
		if (
			event.is_action_pressed('shootRight')
			or event.is_action_pressed('shootLeft')
			or event is InputEventScreenTouch
			and event.is_pressed()):
			if(playerState == PlayerState.FLOATING):
				playerState = PlayerState.FALLING
				acc.y = Global.GRAVITY

		elif (
			event.is_action_released('shootRight')
			or event.is_action_released('shootLeft')
			or event is InputEventScreenTouch
			and event.is_released()):
			if playerState == PlayerState.SWINGING:
				playerState = PlayerState.FALLING
				acc.y = Global.GRAVITY
				var direction =  position - prevPosition
				vel = (direction/lastDelta) * boostOut

		elif event.is_action_pressed("ui_select"):
			respawn()

func respawn():
	position.y = 0
	vel = Vector2.ZERO
	playerState = PlayerState.FLOATING

func getCollisionData(polygons) ->Dictionary:
	for polygon in polygons:
		for i in range(polygon.size()):
			var a = polygon[i]
			var b = polygon[(i + 1) % polygon.size()]
			var closestPoint = Geometry2D.get_closest_point_to_segment(position, a, b)
			var distance = position.distance_to(closestPoint)
			if distance < radius:
				var dir = (b - a).normalized()
				var normal = Vector2(-dir.y, dir.x)
				if (position - closestPoint).dot(normal) < 0:
					normal = -normal
				return {"isColliding": true, "normal": normal, "direction": dir, "distance": distance}
	return {"isColliding": false, "normal":Vector2.ZERO, "direction": Vector2.ZERO}
