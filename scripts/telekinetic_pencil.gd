extends CharacterBody2D

@onready var teleController = $TelekineticController
@onready var shortHand: Sprite2D = $"../ShortHand"

const SPEED = 1.5
const shortRatio = 0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleController.addControl("Right Arrow", "Rotate clockwise")
	teleController.addControl("Left Arrow", "Rotate counter-clockwise")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if teleController.is_selected:
		var direction = Input.get_axis("TelekineticLeft", "TelekineticRight")
		rotate(direction * delta * SPEED)
		shortHand.rotate(direction * delta * SPEED * shortRatio)
