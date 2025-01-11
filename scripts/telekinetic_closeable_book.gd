extends Node2D

@onready var animBody = $AnimatableBody2D
@onready var teleController: TelekineticController = $AnimatableBody2D/TelekineticController
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var spriteLeft: Sprite2D = $AnimatableBody2D/Sprite2D
@onready var spriteRight: Sprite2D = $StaticBody2D/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleController.addControl("Right Arrow", "Close book")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if teleController.is_selected and Input.is_action_just_pressed("TelekineticRight"):
		animPlayer.play("fling")
		

func _on_telekinetic_controller_on_set_enabled(is_enabled: bool) -> void:
	if is_enabled:
		spriteLeft.modulate = TelekineticController.spriteModulationColor
		spriteRight.modulate = TelekineticController.spriteModulationColor
	else:
		spriteLeft.modulate = Color("ffffff")
		spriteRight.modulate = Color("ffffff")
