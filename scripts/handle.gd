extends Node2D

@onready var remoteTransform: RemoteTransform2D = $Area2D/RemoteTransform2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
var inUse = false
var player: Player = null

## Seconds until the handle can actually fling the player
const windupSeconds: float = 0.5
## Interrupt as soon as the animation has been playing for x seconds
const iasaSeconds: float = 2.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not inUse or player == null: return
	if Input.is_action_just_pressed("ResetToCheckpoint"):
		releasePlayer(false, Vector2.ZERO)
	if Input.is_action_just_pressed("PlayerDown") and inUse:
		releasePlayer(true, Vector2(0, player.JUMP_VELOCITY * 0.3))
	elif Input.is_action_just_pressed("PlayerJump") and inUse:
		var xVelo = 0
		if windupSeconds < animationPlayer.current_animation_position:
			xVelo = -rotation * 250
		releasePlayer(true, Vector2(xVelo, player.JUMP_VELOCITY * 0.3))
	elif inUse and (not animationPlayer.is_playing() or animationPlayer.current_animation_position > iasaSeconds):
		if Input.is_action_just_pressed("PlayerLeft"):
			animationPlayer.play("left_to_right")
		elif Input.is_action_just_pressed("PlayerRight"):
			animationPlayer.play("right_to_left")
			
func releasePlayer(setVelo: bool, velo: Vector2):
	remoteTransform.remote_path = ""
	inUse = false
	if player != null:
		player.overridePhysics = false
		if setVelo: player.velocity = velo
		player.global_rotation = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		remoteTransform.remote_path = player.get_path()
		player.overridePhysics = true
		player.velocity = Vector2.ZERO
		inUse = true
