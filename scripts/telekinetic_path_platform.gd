extends TelekineticObject

@onready var animBody = $AnimatableBody2D
@onready var marker = $AnimatableBody2D/Marker

# to set up:
# instantiate this scene
# define a Curve2D in the inspector of the scene node
@onready var pathFollow: PathFollow2D = $PathFollow2D
@export var speed = 100
@export var loop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathFollow.loop = loop
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_selected:
		var direction = Input.get_axis("TelekineticLeft", "TelekineticRight")
		pathFollow.progress += speed * delta * direction

func set_selected(boo: bool):
	is_selected = boo
	if boo:
		marker.visible = true
	else:
		marker.visible = false
