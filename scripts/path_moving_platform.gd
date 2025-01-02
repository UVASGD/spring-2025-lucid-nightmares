extends Path2D

@onready var animBody = $AnimatableBody2D
@onready var line: Line2D = $Line2D

# to set up:
# instantiate this scene
# define a Curve2D in the inspector of the scene node
@onready var pathFollow: PathFollow2D = $PathFollow2D
@export var speed = 100
@export var loop = false

var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathFollow.loop = loop
	if curve:
		var points = curve.get_baked_points()
		line.points = points
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pathFollow.progress += speed * delta * direction
	if not loop:
		if pathFollow.progress_ratio >= 1:
			direction = -1
		elif pathFollow.progress_ratio <= 0:
			direction = 1
		
