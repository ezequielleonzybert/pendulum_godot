extends Node2D

@onready var roof := $"Roof"
@onready var soil := $"Soil"
@onready var player = $"../Player"

var noise := FastNoiseLite.new()
var prevSegmentsCount = 0
var resolution = 200
var amplitude = 1.7
var noiseScale = 1
var height
var width
var segmentWidth
var roofPoints = PackedVector2Array()
var soilPoints = PackedVector2Array()

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.002
	noise.seed = randi()
	width = Global.WIDTH * 2
	height = Global.HEIGHT/8 * amplitude
	segmentWidth = width / float(resolution)

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
		var y = (Global.HEIGHT/2 - noise.get_noise_1d(x*noiseScale*0.35) * height*0.35 - height*0.35)
		soilPoints.append(Vector2(x,y))

	soil.polygon = soilPoints

func _process(_delta):

	var newSegmentsCount: int = floor(player.position.x / segmentWidth)

	while(newSegmentsCount > prevSegmentsCount):
		var x = width/2 + segmentWidth * newSegmentsCount
		var y = (-Global.HEIGHT/2 + noise.get_noise_1d(x*noiseScale) * height + height)
		roofPoints[0].x += segmentWidth
		roofPoints[1].x += segmentWidth
		roofPoints.append(Vector2(x,y))
		roofPoints.remove_at(2)
		y = (Global.HEIGHT/2 - noise.get_noise_1d(x*noiseScale*.35) * height*.35 - height*.35)
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
		y = (Global.HEIGHT/2 - noise.get_noise_1d(x*noiseScale*.35) * height*.35 - height*.35)
		soilPoints[0].x -= segmentWidth
		soilPoints[1].x -= segmentWidth
		soilPoints.insert(2,Vector2(x,y))
		soilPoints.remove_at(soilPoints.size()-1)
		prevSegmentsCount -= 1

	roof.polygon = roofPoints
	soil.polygon = soilPoints
