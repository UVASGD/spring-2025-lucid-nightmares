extends Node2D

@export var enableShortHand: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enableShortHand:
		$ShortHand.visible = true
		$ShortHand/RayCast2D.enabled = true
