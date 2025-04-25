extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var teleController: TelekineticController = $TelekineticController

var maxSpeed = 75
const FRICTION = 13
const AIR_FRICTION = 2

var INERTIA = 25.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleController.addControl("Arrow Keys", "Move block around")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if teleController.is_selected:
		# calculate direction to go
		var x = Input.get_axis("TelekineticLeft", "TelekineticRight")
		var y = Input.get_axis("TelekineticUp", "TelekineticDown")
		var dir: Vector2 = Vector2(x, y)
		velocity = dir * maxSpeed
	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
			velocity.y = move_toward(velocity.y, 0, AIR_FRICTION)
		elif is_on_floor() or velocity.is_zero_approx():
			velocity.x = move_toward(velocity.x, 0, FRICTION)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			var body: RigidBody2D = collision.get_collider()
			body.apply_central_impulse(-collision.get_normal() * INERTIA)


func _on_telekinetic_controller_on_set_enabled(is_enabled: bool) -> void:
	if is_enabled:
		sprite.modulate = Color("b5ffffc8")
	else:
		sprite.modulate = Color("ffffff")
