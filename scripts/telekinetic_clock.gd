extends CharacterBody2D

@onready var teleController = $TelekineticController
@onready var shortHand: Sprite2D = $"../ShortHand"
@onready var rayCast: RayCast2D = $"../ShortHand/RayCast2D"
@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

var audio = preload("uid://j7ki4qxe2g8t")

const SPEED = 1.5
const shortRatio = 0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleController.addControl("Right Arrow", "Rotate clockwise")
	teleController.addControl("Left Arrow", "Rotate counter-clockwise")
	audioPlayer.stream = audio

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_axis("TelekineticLeft", "TelekineticRight")
	if direction == 0: 
		audioPlayer.stop()
		return
	if teleController.is_selected:
		rotate(direction * delta * SPEED)
		shortHand.rotate(direction * delta * SPEED * shortRatio)
		if not audioPlayer.playing:
			audioPlayer.play()
	if rayCast.is_colliding():
		var teleControllerHit: TelekineticController = TelekineticSelector.getTelekineticNodeFromBody(rayCast.get_collider())
		if teleControllerHit:
			teleControllerHit.set_enabled(true)
			
	
			
	
