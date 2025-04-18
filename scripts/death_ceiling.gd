extends CharacterBody2D
class_name DeathCeiling

var stopMotion = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.y = Player.TERMINAL_DOWNWARD_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if stopMotion: return
	velocity += get_gravity() * delta
	if velocity.y > Player.TERMINAL_DOWNWARD_SPEED + 2:
		velocity.y = Player.TERMINAL_DOWNWARD_SPEED + 2
	move_and_slide()
	
func stop():
	if stopMotion: return
	velocity = Vector2.ZERO
	stopMotion = true
	Level.getLevelObject(get_tree()).camera.shake()
