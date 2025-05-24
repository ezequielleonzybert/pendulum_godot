extends Node2D

@onready var roof := $"SubViewport/Roof"
@onready var soil := $SubViewport/Soil
@onready var player = $"../Player"
@onready var playerCamera = get_node("/root/Main/Player/Camera2D")
@onready var background = $SubViewport/BackgroundCanvas/Background
@onready var sv = $SubViewport
@onready var svCamera = $SubViewport/Camera2D
@onready var texRec = $TextureRect

var noise := FastNoiseLite.new()
var prevSegmentsCount = 0
var resolution = 200
var amplitude = 1.7
var noiseScale = 10.0
var height
var width
var segmentWidth
var roofPoints = PackedVector2Array()
var soilPoints = PackedVector2Array()
var roofCanvasVertices = []
var factor

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.0001
	noise.seed = randi()
	width = Global.WIDTH * 2
	height = Global.HEIGHT/8 * amplitude
	segmentWidth = width / float(resolution)
	background.size = Vector2(Global.WIDTH, Global.HEIGHT)
	background.color = Global.color1
	roof.color = Global.color2
	soil.color = Global.color2

	roofPoints.append(Vector2(width/2, -Global.HEIGHT/2))
	roofPoints.append(Vector2(-width/2, -Global.HEIGHT/2))
	for i in range(resolution):
		var x = -width/2 + segmentWidth * i
		var y = (-Global.HEIGHT/2 + noise.get_noise_1d(x*noiseScale) * height + height)
		roofPoints.append(Vector2(x,y))

	roof.polygon = roofPoints

	soilPoints.append(Vector2(width/2, Global.HEIGHT/2))
	soilPoints.append(Vector2(-width/2, Global.HEIGHT/2))
	for i in range(resolution):
		var x = -width/2 + segmentWidth * i
		factor = 0.35
		var y = (Global.HEIGHT/2 - noise.get_noise_1d(x*noiseScale*factor+5000) * height*factor - height*factor)
		soilPoints.append(Vector2(x,y))

	soil.polygon = soilPoints
	
	sv.size = Vector2(Global.WIDTH, Global.HEIGHT)
	texRec.position.x = -Global.WIDTH/2
	texRec.position.y = -Global.HEIGHT/2 
	texRec.texture = sv.get_texture()

func _process(_delta):
	
	texRec.position.x = -Global.WIDTH/2 + playerCamera.get_screen_center_position().x
	texRec.position.y = -Global.HEIGHT/2 + playerCamera.get_screen_center_position().y
	svCamera.position = playerCamera.get_screen_center_position()
	texRec.texture = sv.get_texture()

	var newSegmentsCount: int = floor(player.position.x / segmentWidth)

	while(newSegmentsCount > prevSegmentsCount):
		var x = width/2 + segmentWidth * newSegmentsCount
		var y = (-Global.HEIGHT/2 + noise.get_noise_1d(x*noiseScale) * height + height)
		roofPoints[0].x += segmentWidth
		roofPoints[1].x += segmentWidth
		roofPoints.append(Vector2(x,y))
		roofPoints.remove_at(2)
		y = (Global.HEIGHT/2 - noise.get_noise_1d(x*noiseScale*factor+5000) * height*factor - height*factor)
		soilPoints[0].x += segmentWidth
		soilPoints[1].x += segmentWidth
		soilPoints.append(Vector2(x,y))
		soilPoints.remove_at(2)
		prevSegmentsCount += 1

	while(newSegmentsCount < prevSegmentsCount):
		var x = -width/2 + segmentWidth * newSegmentsCount
		var y = (-Global.HEIGHT/2 + noise.get_noise_1d(x*noiseScale) * height + height)
		roofPoints[0].x -= segmentWidth
		roofPoints[1].x -= segmentWidth
		roofPoints.insert(2,Vector2(x,y))
		roofPoints.remove_at(roofPoints.size()-1)
		y = (Global.HEIGHT/2 - noise.get_noise_1d(x*noiseScale*factor+5000) * height*factor - height*factor)
		soilPoints[0].x -= segmentWidth
		soilPoints[1].x -= segmentWidth
		soilPoints.insert(2,Vector2(x,y))
		soilPoints.remove_at(soilPoints.size()-1)
		prevSegmentsCount -= 1

	roof.polygon = roofPoints
	soil.polygon = soilPoints
