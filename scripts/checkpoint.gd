extends Area2D

@export var phase: int = 0
var activated = false
@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.animation = "inactive"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if activated: return
	if body is Player:
		if body.checkpoint_phase <= phase:
			body.respawnNode = self
			body.checkpoint_phase = phase
			setActivated(true)
			

func setActivated(boo: bool):
	activated = boo
	if boo: sprite.animation = 'active'
	else: sprite.animation = 'inactive'
