extends AnimatableBody2D

var playerStandingOn = false
@export var fallPerSecond = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if playerStandingOn:
		position.y += fallPerSecond * delta
	

func _on_floor_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerStandingOn = true

func _on_floor_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerStandingOn = false
