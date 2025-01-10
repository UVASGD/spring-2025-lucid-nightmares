extends Camera2D
class_name CustomCamera

@onready var collision_shape: CollisionShape2D = $TelekineticArea/CollisionShape2D
var overrideZoom: Vector2 = Vector2(0.85, 0.85)
var overridePosition: Vector2 = Vector2.ZERO
var doOverride: bool = false
var lerpDelta = 2
var default_zoom: Vector2 = Vector2(0.85, 0.85)

@export var shakeDecay = 0.8
@export var max_offset = Vector2(100, 75)
@export var max_roll = 0.1
var shakeStrength = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_zoom = zoom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if doOverride:
		zoom = lerp(zoom, overrideZoom, lerpDelta * delta)
		position = lerp(position, overridePosition, lerpDelta * delta)
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
	zoom = default_zoom
	
func shake():
	shakeStrength += 0.5
