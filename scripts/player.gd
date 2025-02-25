extends CharacterBody2D
class_name Player

const floor_area_name = "StandingArea"

const MAX_SPEED = 75.0
const GROUND_FRICTION = MAX_SPEED * 0.3
const AIR_FRICTION = MAX_SPEED * 0.05
const AIR_CHANGE_SPEED = 3.0
const JUMP_VELOCITY = -100.0
const JUMP_LEEWAY_TIME = 0.1

@export var camera: CustomCamera = null
@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D
var canJump: bool = true #for coyote time and adds delay to jump
var jumpLeewayTimer: float = 0.0
var jumpCounter: int = 0
var respawnPosition: Vector2 = Vector2.ZERO
var checkpoint_phase: int = -1

func _ready() -> void:
	if camera != null:
		camera.player = self
		if not camera.disableTracking:
			camera.position = position
	respawnPosition = global_position

func _physics_process(delta: float) -> void:
	
	# sets canJump, which determines if the player can jump, ignoring if they are on a platform.
	# cooldown for jump, and holding down the key looks to weird otherwise
	# and not being able to hold down the key feels strange
	if is_on_floor() and not canJump:
		jumpCounter = 0
		canJump = true

	if not is_on_floor():
		if canJump:
			#velocity.y = 0 #prevents platform launches
			# count down remaining "coyote time"
			jumpLeewayTimer -= delta
			if jumpLeewayTimer <= 0.0 : 
				canJump = false
				jumpLeewayTimer = JUMP_LEEWAY_TIME
		# Add the gravity.
		velocity += get_gravity() * delta
			
	if jumpCounter < 2 and 	!Input.is_action_pressed("PlayerJump"):
		canJump = true
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("PlayerLeft", "PlayerRight")
	if direction:
		if canJump:
			velocity.x = direction * MAX_SPEED
		elif abs(velocity.x) < MAX_SPEED or sign(velocity.x) != sign(direction):
				velocity.x +=  direction * AIR_CHANGE_SPEED
	else:
		if canJump:
			velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)	
	
	# handle jump
	if canJump and Input.is_action_pressed("PlayerJump"):
		# jumps, even if slightly off platform
		if velocity.y > JUMP_VELOCITY:
			velocity.y = JUMP_VELOCITY
			jumpCounter += 1
			canJump = false
	
	move_and_slide()
	
	if direction:
		animSprite.play("walk")
		if direction < 0:
			animSprite.flip_h = true
		else:
			animSprite.flip_h = false
	else:
		animSprite.play("idle")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ResetToCheckpoint"):
		respawn()

# This is currently connected to the standing area node and should be connected to another Area2D in the future
func _on_enter_camera_override_area(area: Area2D) -> void:
	if area is not CameraOverrideArea: return
	var cameraArea: CameraOverrideArea = area
	camera.cameraOverride(cameraArea.getZoom(), cameraArea.getCenter())
	
# Does not account for the player being inside multiple override areas
func _on_exit_camera_override_area(area: Area2D) -> void:
	if area is not CameraOverrideArea: return
	camera.resetOverride()

func _on_damage(amount: int):
	if amount > 0:
		respawn()

func respawn():
	global_position = respawnPosition
	velocity = Vector2.ZERO
