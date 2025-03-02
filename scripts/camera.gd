extends Camera2D
class_name CustomCamera

@onready var collision_shape: CollisionShape2D = $TelekineticArea/CollisionShape2D
@onready var textureRect: TextureRect = $Background/BackgroundTexture
var player: Player = null
var overrideZoom: Vector2 = Vector2(0.85, 0.85)
var overridePosition: Vector2 = Vector2.ZERO
var doOverride: bool = false
var lerpDelta = 2
var returnLerpDelta = 4
var default_zoom: Vector2 = Vector2(0.85, 0.85)

@export var shakeDecay = 0.8
@export var max_offset = Vector2(100, 75)
@export var max_roll = 0.1
@export var background_texture: Texture2D = null
@export var background_scale: Vector2 = Vector2(1, 1) 
@export_group("Debug")
@export var disableTracking: bool = false
var shakeStrength = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_zoom = zoom
	setBackground(background_texture, background_scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null: return
	if doOverride and not disableTracking:
		zoom = lerp(zoom, overrideZoom, lerpDelta * delta)
		position = lerp(position, overridePosition, lerpDelta * delta)
	elif not disableTracking:
		zoom = lerp(zoom, default_zoom, returnLerpDelta * delta)
		position = lerp(position, player.position, returnLerpDelta * delta)
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
