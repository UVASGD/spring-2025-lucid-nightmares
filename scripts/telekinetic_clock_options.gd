extends Node2D

@export var disableShortHand: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if disableShortHand:
		$ShortHand.visible = false
		$ShortHand/RayCast2D.enabled = false
