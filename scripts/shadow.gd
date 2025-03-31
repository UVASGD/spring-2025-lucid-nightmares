extends Polygon2D

enum Direction {UP, DOWN, LEFT, RIGHT}

@export var lightDirection: Direction = Direction.DOWN
var lightVector: Vector2 = Vector2.ZERO
@export_category("Define static points")
## Predefine the points that won't be moving - provide the index of the point on the polygon (e.g. 0 for the 1st point on the polygon)
@export var staticPoint1: int = -1
## Predefine the points that won't be moving - provide the index of the point on the polygon (e.g. 0 for the 1st point on the polygon)
@export var staticPoint2: int = -1
@export var debug: bool = false
# array of polygon indices
var staticPoints: Array[int] = []
var nonStaticPoints: Array[int] = []
var shadowWidth: int = 0

const shadowThickness = 4
const MAX_SPEED = 40.0

@onready var moveShadow = $MovableShadow
@onready var sprite = $MovableShadow/Sprite2D
@onready var collisionShape = $MovableShadow/CollisionShape2D
@onready var teleController: TelekineticController = $MovableShadow/TelekineticController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match lightDirection:
		Direction.UP: lightVector = Vector2(0, -1)
		Direction.DOWN: lightVector = Vector2(0, 1)
		Direction.LEFT: lightVector = Vector2(-1, 0)
		Direction.RIGHT: lightVector = Vector2(1, 0)
	
	# Determine which points are static
	if staticPoint1 == -1 or staticPoint2 == -1:
		pass
		return
	else:
		staticPoints.append(staticPoint1)
		staticPoints.append(staticPoint2)
	for i in range(4):
		if i not in staticPoints:
			nonStaticPoints.append(i)
	
	# Move the body
	# midpoint of the two non-static points
	var movePoint1: Vector2 = polygon[nonStaticPoints[0]]
	var movePoint2: Vector2 = polygon[nonStaticPoints[1]]
	moveShadow.position = Vector2((movePoint1.x + movePoint2.x) / 2, (movePoint1.y + movePoint2.y) / 2)
	
	# Transform the collision shape using some *magic*
	var diff: Vector2 = movePoint1 - movePoint2
	var size = diff * Vector2(lightVector.y, lightVector.x)
	size = Vector2(abs(size.x), abs(size.y))
	if size.x == 0:
		size.x = shadowThickness
		shadowWidth = size.y
	else:
		size.y = shadowThickness
		shadowWidth = size.x
	collisionShape.shape.size = size
	
	# Transform the sprite as well
	sprite.region_rect.size = size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if teleController.is_selected:
		var direction = Input.get_axis("TelekineticLeft", "TelekineticRight")
		var right: Vector2 = lightVector.rotated(-PI/2)
		moveShadow.velocity = right * direction * MAX_SPEED
	else:
		moveShadow.velocity = Vector2.ZERO
	moveShadow.move_and_slide()
	
	# Update the polygon
	var widthVector = Vector2(abs(lightVector.y), abs(lightVector.x)) * (shadowWidth / 2)

	var movePoint1 = moveShadow.position + widthVector
	var movePoint2 = moveShadow.position - widthVector
	
	var j = 0
	if debug:
		print("start")
	for i in range(4):
		if i not in staticPoints:
			if j == 0: 
				polygon[i] = movePoint1
				j += 1
			elif j == 1:
				polygon[i] = movePoint2
				break
		if debug:
			print(str(polygon[i]))
	
