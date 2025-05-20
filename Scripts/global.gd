extends Node2D

var HEIGHT
var WIDTH
var GRAVITY

func _ready() -> void:
	WIDTH = get_viewport_rect().size.x
	HEIGHT = get_viewport_rect().size.y
	GRAVITY = 1500 * HEIGHT/450



func circleInPolygon(pos: Vector2, radius: float, polygon: PackedVector2Array) -> Vector2:
	for i in range(polygon.size()):
		var a = polygon[i]
		var b = polygon[(i + 1) % polygon.size()]
		var closestPoint = Geometry2D.get_closest_point_to_segment(pos, a, b)
		if pos.distance_to(closestPoint) < radius:
			var dir = (b - a).normalized()
			var normal = Vector2(-dir.y, dir.x)
			return normal
	return Vector2.ZERO

func reflectVelocity(velocity: Vector2, normal: Vector2) -> Vector2:
	return velocity - 2 * velocity.dot(normal) * normal
