extends Path2D

@onready var animBody = $AnimatableBody2D

# to set up:
# instantiate this scene
# define a Curve2D in the inspector of the scene node
@onready var pathFollow: PathFollow2D = $PathFollow2D
@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pathFollow.progress += speed * delta
