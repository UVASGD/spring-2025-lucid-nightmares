extends Camera2D
class_name CustomCamera

@onready var collision_shape: CollisionShape2D = $TelekineticArea/CollisionShape2D
@onready var textureRects: Array[TextureRect] = \
	[$Background/Parallax2D/BackgroundTexture,  $Background/Parallax2D2/BackgroundTexture2]
@onready var fadeOverlay: ColorRect = $CanvasLayer/FadeOverlay
@onready var colorOverlay: ColorRect = $CanvasLayer/ColorOverlay
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var spaceContainer: Node2D = $Background/PlanetContainer
@onready var quitLabel: Label = $CanvasLayer/QuitLabel
var player: Player = null
var overrideZoom: Vector2 = Vector2(0.85, 0.85)
var overridePosition: Vector2 = Vector2.ZERO
var doOverrideZoom: bool = false
var doOverridePosition: bool = false
var lerpDelta = 2
var returnLerpDelta = 10
var default_zoom: Vector2 = Vector2(0.85, 0.85)

const hotColor: Color = Color("9f443444")
const coldColor: Color = Color("535ca844")

enum RealityMode {NORMAL, HOT, COLD}

@export_group("Background")
@export var background_texture: Texture2D = null
@export var background_texture_2: Texture2D = null
@export var background_scale: Vector2 = Vector2(1, 1)
@export var background_offset: Array[Vector2] = [Vector2(-200, 0), Vector2(-200, 0)]
@export var spaceMode: bool = false
@export_group("Tracking")
@export var trackingOffset: Vector2 = Vector2.ZERO 
@export var trackingLimits: Array[Vector2] = [Vector2(-1, -1), Vector2(-1, -1)]
@export_group("Shake")
@export var shakeDecay = 0.8
@export var max_offset = Vector2(100, 75)
@export var max_roll = 0.1
@export_group("Debug")
@export var disableTracking: bool = false
var shakeStrength = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_zoom = zoom
	setBackground(0)
	setBackground(1)
	fadeInFromBlack()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null: return
	
	var newPosition = Vector2(0, 0)
	if doOverridePosition and not disableTracking:
		newPosition = lerp(position, overridePosition, lerpDelta * delta)
	else:
		newPosition = lerp(position, player.position + trackingOffset, returnLerpDelta * delta)
	position = applyLimits(newPosition - position)
	if doOverrideZoom:
		zoom = lerp(zoom, overrideZoom, lerpDelta * delta)
	else:
		zoom = lerp(zoom, default_zoom, returnLerpDelta * delta)
	updateCollisionBox()
	if shakeStrength:
		shakeStrength = max(shakeStrength - shakeDecay * delta, 0)
		var amount = pow(shakeStrength, 2)
		rotation = max_roll * amount * randf_range(-1, 1)
		offset.x = max_offset.x * amount * randf_range(-1, 1)
		offset.y = max_offset.y * amount * randf_range(-1, 1)

func applyLimits(delta: Vector2) -> Vector2:
	var newPosition = position + delta
	if trackingLimits[0].x != -1 and newPosition.x < trackingLimits[0].x:
		newPosition.x = trackingLimits[0].x
	elif trackingLimits[1].x != -1 and newPosition.x > trackingLimits[1].x:
		newPosition.x = trackingLimits[1].x
	if (trackingLimits[0].y != -1 and newPosition.y > trackingLimits[0].y):
		newPosition.y = trackingLimits[0].y
	elif (trackingLimits[1].y != -1 and newPosition.y < trackingLimits[1].y):
		newPosition.y = trackingLimits[1].y
	return newPosition
	
func updateCollisionBox():
	var viewport_size = get_viewport().get_visible_rect().size
	var shape: RectangleShape2D = collision_shape.shape
	var newSize = viewport_size * 1/zoom
	shape.size = newSize

func cameraOverride(doZoom: bool, doPosition: bool, newZoom: Vector2, newPosition: Vector2):
	if doPosition: doOverridePosition = true
	if doZoom: doOverrideZoom = true
	overridePosition = newPosition
	overrideZoom = newZoom

func resetOverride():
	doOverridePosition = false
	doOverrideZoom = false
	
func shake():
	shakeStrength += 0.3
	
func setBackground(index: int):
	if index == 0:
		if background_texture == null: return
		textureRects[index].texture = background_texture
	else:
		if background_texture_2 == null: return
		textureRects[index].texture = background_texture_2
	textureRects[index].scale =	 background_scale
	var parallaxParent: Parallax2D = textureRects[index].get_parent()
	if parallaxParent:
		parallaxParent.scroll_offset = background_offset[index]
	else:
		print("Warning: background has no parallax parent object")
		
	# space mode custom configuration
		
	if spaceMode and parallaxParent:
		parallaxParent.scroll_scale = Vector2(0, 0)
		parallaxParent.follow_viewport = false
		if index == 1:
			textureRects[1].position = Vector2(-10, -2)

func on_reality_change(reality: int):
	if reality == RealityMode.COLD:
		coldOverlay()
	elif reality == RealityMode.NORMAL:
		resetOverlay()
	else:
		hotOverlay()
	
func hotOverlay():
	colorOverlay.color = hotColor
	colorOverlay.visible = true
	
func coldOverlay():
	colorOverlay.color = coldColor
	colorOverlay.visible = true
	
func resetOverlay():
	colorOverlay.visible = false
	
func fadeToBlack():
	fadeOverlay.color = Color("00000000")
	fadeOverlay.visible = true
	animPlayer.play("fadeToBlack")
	
func fadeInFromBlack():
	fadeOverlay.color = Color("000000")
	fadeOverlay.visible = true
	animPlayer.play("fadeInFromBlack")
