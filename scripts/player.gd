extends CharacterBody2D
class_name Player

const floor_area_name = "StandingArea"

const MAX_SPEED = 300.0
const GROUND_FRICTION = MAX_SPEED * 0.3
const AIR_FRICTION = MAX_SPEED * 0.05
const AIR_CHANGE_SPEED = 10.0
const JUMP_VELOCITY = -400.0

@export var camera: CustomCamera = null
@onready var remoteTransform: RemoteTransform2D = $RemoteTransform2D

func _ready() -> void:
	if camera != null:
		remoteTransform.remote_path = camera.get_path()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("PlayerJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("PlayerLeft", "PlayerRight")
	if direction:
		if is_on_floor():
			velocity.x = direction * MAX_SPEED
		else:
			velocity.x += direction * AIR_CHANGE_SPEED
			velocity.x = capSpeed(velocity.x, MAX_SPEED)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
	move_and_slide()


func capSpeed(speed: float, maximum: float) -> float:
	if abs(speed) < abs(maximum):
		return speed
	else:
		if speed < 0:
			return -maximum
		return maximum
		
# This is currently connected to the standing area node and should be connected to another Area2D in the future
func _on_enter_camera_override_area(area: Area2D) -> void:
	if area is not CameraOverrideArea: return
	var cameraArea: CameraOverrideArea = area
	remoteTransform.remote_path = ""
	camera.cameraOverride(cameraArea.getZoom(), cameraArea.getCenter())
	
# Does not account for the player being inside multiple override areas
func _on_exit_camera_override_area(area: Area2D) -> void:
	if area is not CameraOverrideArea: return
	var cameraArea: CameraOverrideArea = area
	remoteTransform.remote_path = camera.get_path()
	camera.resetOverride()
