extends Camera2D

func _ready() -> void:
	process_priority = -1 #if not, the terrain viewport camera delay
	limit_bottom = Global.HEIGHT/2
	limit_top = -Global.HEIGHT/2
