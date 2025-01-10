extends Node2D
class_name Level


@export var allowTelekinesis: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setAllowTelekinesis(allowTelekinesis)

# A really scuffed way of properly initializing tilemap objects
var delayedCall = false
func _process(delta: float) -> void:
	if not delayedCall:
		setAllowTelekinesis(allowTelekinesis)
		delayedCall = true

func setAllowTelekinesis(allow: bool):
	allowTelekinesis = allow
	get_tree().call_group("TelekineticControllers", "set_enabled", allowTelekinesis)
