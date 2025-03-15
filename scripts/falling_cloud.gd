extends AnimatableBody2D

var playerStandingOn = false
@export var fallPerSecond = 4
@export var returnPerSecond = 4
var originalY = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	originalY = position.y


func _physics_process(delta: float) -> void:
	if playerStandingOn:
		position.y += fallPerSecond * delta
	else:
		position.y = max(position.y - (returnPerSecond * delta), originalY)
	

func _on_floor_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerStandingOn = true

func _on_floor_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerStandingOn = false
