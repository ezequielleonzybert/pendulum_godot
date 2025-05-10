extends Node2D

var HEIGHT
var WIDTH

func _ready() -> void:
	WIDTH = get_viewport_rect().size.x
	HEIGHT = get_viewport_rect().size.y
