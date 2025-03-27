extends Camera2D
class_name CustomCamera

@onready var collision_shape: CollisionShape2D = $TelekineticArea/CollisionShape2D
@onready var textureRect: TextureRect = $Background/Parallax2D/BackgroundTexture
@onready var textureRect2: TextureRect = $Background/Parallax2D2/BackgroundTexture2
@onready var colorOverlay: ColorRect = $CanvasLayer/ColorOverlay
var player: Player = null
var overrideZoom: Vector2 = Vector2(0.85, 0.85)
var overridePosition: Vector2 = Vector2.ZERO
var doOverride: bool = false
var lerpDelta = 2
var returnLerpDelta = 4
var default_zoom: Vector2 = Vector2(0.85, 0.85)

const hotColor: Color = Color("9f443496")
const coldColor: Color = Color("535ca896")

enum RealityMode {NORMAL, HOT, COLD}

@export var background_texture: Texture2D = null
@export var background_texture_2: Texture2D = null
@export var background_scale: Vector2 = Vector2(1, 1)
@export var trackingOffset: Vector2 = Vector2.ZERO 
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
	setBackground(background_texture, background_scale)
	setBackground2(background_texture_2, background_scale)
	colorOverlay.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null: return
	if doOverride and not disableTracking:
		zoom = lerp(zoom, overrideZoom, lerpDelta * delta)
		position = lerp(position, overridePosition, lerpDelta * delta)
	elif not disableTracking:
		zoom = lerp(zoom, default_zoom, returnLerpDelta * delta)
		position = lerp(position, player.position + trackingOffset, returnLerpDelta * delta)
	updateCollisionBox()
	if shakeStrength:
		shakeStrength = max(shakeStrength - shakeDecay * delta, 0)
		var amount = pow(shakeStrength, 2)
		rotation = max_roll * amount * randf_range(-1, 1)
		offset.x = max_offset.x * amount * randf_range(-1, 1)
		offset.y = max_offset.y * amount * randf_range(-1, 1)

func updateCollisionBox():
	var viewport_size = get_viewport().get_visible_rect().size
	var shape: RectangleShape2D = collision_shape.shape
	var newSize = viewport_size * 1/zoom
	shape.size = newSize

func cameraOverride(newZoom: Vector2, newPosition: Vector2):
	doOverride = true
	overridePosition = newPosition
	overrideZoom = newZoom

func resetOverride():
	doOverride = false
	
func shake():
	shakeStrength += 0.3
	
func setBackground(texture: Texture2D, textureScale: Vector2):
	if texture == null: return
	textureRect.texture = texture
	textureRect.scale = textureScale
	
func setBackground2(texture: Texture2D, textureScale: Vector2):
	if texture == null: return
	textureRect2.texture = texture
	textureRect2.scale = textureScale
	
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
