extends CharacterBody2D
class_name DeathCeiling


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.y = Player.TERMINAL_DOWNWARD_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity += get_gravity() * delta
	if velocity.y > Player.TERMINAL_DOWNWARD_SPEED:
		velocity.y = Player.TERMINAL_DOWNWARD_SPEED
	move_and_slide()
