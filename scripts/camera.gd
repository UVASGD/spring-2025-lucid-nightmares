extends Camera2D
class_name CustomCamera

@onready var collision_shape: CollisionShape2D = $TelekineticArea/CollisionShape2D
var overrideZoom: Vector2 = Vector2(0.85, 0.85)
var overridePosition: Vector2 = Vector2.ZERO
var doOverride: bool = false
var lerpDelta = 2
var default_zoom: Vector2 = Vector2(0.85, 0.85)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_zoom = zoom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if doOverride:
		zoom = lerp(zoom, overrideZoom, lerpDelta * delta)
		position = lerp(position, overridePosition, lerpDelta * delta)
	updateCollisionBox()

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
	
