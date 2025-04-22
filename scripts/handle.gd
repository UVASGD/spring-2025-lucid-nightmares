extends Node2D

@onready var remoteTransform: RemoteTransform2D = $Area2D/RemoteTransform2D
@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
var audio = preload("uid://dkgw1xxbtmmo1") #wind woosh
var inUse = false
var player: Player = null
var angularVelo = 0 # radians per second
const manualConstantAngularVelo = deg_to_rad(60)
const manualMultiplierAngularVelo = 5.0/3.0
const yFlingMultiplier = 0.15
const xFlingMultiplier = 25

## Seconds until the handle can actually fling the player
const windupSeconds: float = 0.5
## Interrupt as soon as the animation has been playing for x seconds
const iasaSeconds: float = 2.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audioPlayer.stream = audio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not inUse or player == null: 
		rotation = move_toward(rotation, 0, manualConstantAngularVelo * delta)
		angularVelo = 0
	if Input.is_action_just_pressed("ResetToCheckpoint"):
		releasePlayer(false, Vector2.ZERO)
	if Input.is_action_just_pressed("PlayerDown") and inUse:
		releasePlayer(true, Vector2(0, player.JUMP_VELOCITY * 0.3))
	elif Input.is_action_just_pressed("PlayerJump") and inUse:
		releasePlayer(true, Vector2(-angularVelo * xFlingMultiplier, 
		player.JUMP_VELOCITY * (1 + abs(sin(rotation) * angularVelo) * yFlingMultiplier) ))
	elif inUse:
		var direction = Input.get_axis("PlayerLeft", "PlayerRight")
		var accel = -sin(rotation) * 0.25
		# if direction is 0, obey physics
		# if direction is not 0 and angularVelo opposes direction and abs(angularvelo) is less than a certain amount,
		# stop angularVelo and move constant in that direction
		# if direction is not 0 otherwise, obey physics but have input contribute to velocity increase/decrease
		if not direction:
			angularVelo += accel
			# damping
			angularVelo *= 0.99 # per frame
			if abs(angularVelo) < 0.01: angularVelo = 0
			rotate(angularVelo * delta)
		else:
			audioPlayer.play()
			if sign(angularVelo) != sign(direction) and abs(angularVelo) < deg_to_rad(120):
				angularVelo = deg_to_rad(120) * -direction
				rotate(angularVelo * delta)
			else:
				angularVelo += accel * manualMultiplierAngularVelo
				rotate(angularVelo * delta)
		if rotation < deg_to_rad(-60): 
			rotation = deg_to_rad(-60)
			angularVelo = 0
		elif rotation > deg_to_rad(60): 
			rotation = deg_to_rad(60)
			angularVelo = 0
			
			
func releasePlayer(setVelo: bool, velo: Vector2):
	remoteTransform.remote_path = ""
	inUse = false
	if player != null:
		player.replenishDoubleJump()
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
