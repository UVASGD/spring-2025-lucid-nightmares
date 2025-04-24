extends CharacterBody2D

@export var isEnabled: bool = true
@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var teleController: TelekineticController = $TelekineticController

var maxSpeed = 75
const FRICTION = 13
const AIR_FRICTION = 2

var framesStoodOn = 0
var playerStandingOn = false
var burnedOut = false
var INERTIA = 25.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleController.addControl("Arrow Keys", "Move block around")
	teleController.set_enabled(isEnabled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if teleController.is_selected and not burnedOut:
		incrementBurnout()
		# calculate direction to go
		var x = Input.get_axis("TelekineticLeft", "TelekineticRight")
		var y = Input.get_axis("TelekineticUp", "TelekineticDown")
		var dir: Vector2 = Vector2(x, y)
		velocity = dir * maxSpeed
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
		elif is_on_floor() or velocity.is_zero_approx():
			velocity.x = move_toward(velocity.x, 0, FRICTION)
			if burnedOut:
				recover()
			else:
				animationPlayer.stop()
	move_and_slide()
	for c in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(c)
		if collision.get_collider() is RigidBody2D:
			var body: RigidBody2D = collision.get_collider()
			body.apply_central_impulse(-collision.get_normal() * INERTIA)

var i = 0

func incrementBurnout():
	if burnedOut: return
	if playerStandingOn and not is_on_floor():
		framesStoodOn += 1
		if framesStoodOn >= 60:
			animationPlayer.play("shake")
		if framesStoodOn >= 120:
			triggerBurnout()
	elif is_on_floor():
		framesStoodOn = 0
		animationPlayer.stop()

func triggerBurnout():
	framesStoodOn = 0
	burnedOut = true
	teleController.set_selected(false)
	teleController.set_enabled(false)
	sprite.modulate = Color("ffffff")
	
func recover():
	teleController.set_enabled(true)
	burnedOut = false
	velocity = Vector2.ZERO
	sprite.modulate = TelekineticController.spriteModulationColor
	animationPlayer.stop()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == Player.floor_area_name:
		playerStandingOn = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == Player.floor_area_name:
		playerStandingOn = false


func _on_telekinetic_controller_on_set_enabled(is_enabled: bool) -> void:
	if is_enabled:
		sprite.modulate = TelekineticController.spriteModulationColor
	else:
		sprite.modulate = Color("ffffff")
