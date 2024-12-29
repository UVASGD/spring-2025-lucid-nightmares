extends TelekineticObject

@onready var charBody = $CharacterBody2D
@onready var marker = $CharacterBody2D/Marker

var maxSpeed = 300
var friction = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	marker.visible = true
	is_selected = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_selected:
		# calculate direction to go
		var x = Input.get_axis("TelekineticLeft", "TelekineticRight")
		var y = Input.get_axis("TelekineticUp", "TelekineticDown")
		var dir: Vector2 = Vector2(x, y)
		charBody.velocity = dir * maxSpeed
	charBody.move_and_slide()

func set_selected(boo: bool):
	is_selected = boo
	if boo:
		marker.visible = true
