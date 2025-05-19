extends Node2D

var HEIGHT
var WIDTH
var GRAVITY

func _ready() -> void:
	WIDTH = get_viewport_rect().size.x
	HEIGHT = get_viewport_rect().size.y
	GRAVITY = 1500 * HEIGHT/450

func pointInPolygon(point: Vector2, polygon: PackedVector2Array):
	var _intersections = 0
	var num_vertices = polygon.size()
	
	for i in range(num_vertices):
		var j = (i + 1) % num_vertices 
		var v1 = polygon[i]
		var v2 = polygon[j]

		if (v1.y > point.y) != (v2.y > point.y):
			var x_intersect = v1.x + (point.y - v1.y) * (v2.x - v1.x) / (v2.y - v1.y)
			if point.x < x_intersect:
				_intersections += 1

func circleInPolygon(pos: Vector2, radius: float, polygon: PackedVector2Array) -> bool:
	for i in range(polygon.size()):
		var a = polygon[i]
		var b = polygon[(i + 1) % polygon.size()]
		if pos.distance_to(Geometry2D.get_closest_point_to_segment(pos, a, b)) < radius:
			return true
	return false
