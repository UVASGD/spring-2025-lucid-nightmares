extends CharacterBody2D
class_name Player

const floor_area_name = "StandingArea"

const MAX_SPEED = 75.0
const GROUND_FRICTION = MAX_SPEED * 0.3
const AIR_FRICTION = MAX_SPEED * 0.05
const AIR_CHANGE_SPEED = 3.0
const JUMP_VELOCITY = -100.0
const JUMP_LEEWAY_TIME = 0.1
const AIR_JUMPS = 1

@export var camera: CustomCamera = null
@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawnController: RespawnController = $RespawnController
@onready var floorRayCast: RayCast2D = $FloorRayCast2D
@onready var footstepPlayer: AudioStreamPlayer2D = $FootstepPlayer

var wood_walk = preload("res://assets/Sounds/player/wood_walk.mp3")
var carpet_walk = preload("res://assets/Sounds/player/carpet_walk.mp3")

var walkSfxResetCooldown = 10
var walkSfxResetCooldownMax = 10

var onGround: bool = true #for coyote time
var canJump: bool = true # adds delay to jump
var jumpLeewayTimer: float = 0.0
var jumpCounter: int = 0
var overridePhysics: bool = false
var airborneTimer: int = 0
var checkpoint_phase: int = -1

func _ready() -> void:
	if (PlayerGlobalVars.respawnPoint != Vector2.ZERO):
		global_position = PlayerGlobalVars.respawnPoint
	PlayerGlobalVars.respawnPoint = global_position
	
	if camera != null:
		camera.player = self
		if not camera.disableTracking:
			camera.position = position
	

func _physics_process(delta: float) -> void:
	if not overridePhysics:	physics(delta)
	animation()
		
func physics(delta: float):
	# sets canJump, which determines if the player can jump, ignoring if they are on a platform.
	# cooldown for jump, and holding down the key looks to weird otherwise
	# and not being able to hold down the key feels strange
	if is_on_floor() and not onGround:
		jumpCounter = 0
		onGround = true
		
	if airborneTimer > 0:
		airborneTimer -= 1

	if not is_on_floor():
		if onGround:
			#velocity.y = 0 #prevents platform launches
			# count down remaining "coyote time"
			jumpLeewayTimer -= delta
			if jumpLeewayTimer <= 0.0 : 
				onGround = false
				jumpLeewayTimer = JUMP_LEEWAY_TIME
		# Add the gravity.
		velocity += get_gravity() * delta
	if jumpCounter < AIR_JUMPS and !Input.is_action_pressed("PlayerJump"):
		canJump = true
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("PlayerLeft", "PlayerRight")
	if direction and not airborneTimer:
		if onGround:
			velocity.x = direction * MAX_SPEED
		elif abs(velocity.x) < MAX_SPEED or sign(velocity.x) != sign(direction):
				velocity.x +=  direction * AIR_CHANGE_SPEED
	elif not airborneTimer:
		if onGround:
			velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)	
	
	# handle jump
	if canJump and Input.is_action_pressed("PlayerJump"):
		# jumps, even if slightly off platform
		if velocity.y > JUMP_VELOCITY:
			velocity.y = JUMP_VELOCITY
			if not onGround:
				jumpCounter += 1
			canJump = false
			# consider the player mid-air when the player has jumped
			onGround = false
	move_and_slide()

func animation():
	var direction := Input.get_axis("PlayerLeft", "PlayerRight")
	if direction:
		animSprite.play("walk")
		if direction < 0:
			animSprite.flip_h = true
		else:
			animSprite.flip_h = false
	else:
		animSprite.play("idle")
		
	# sfx
	walkSfx(direction)

func walkSfx(direction: float):
	var audio
	if direction and floorRayCast.is_colliding():
		if floorRayCast.get_collider() is TileMapLayer:
			var tileMap: TileMapLayer = floorRayCast.get_collider()
			var tileData: TileData = tileMap.get_cell_tile_data( 
			tileMap.local_to_map(floorRayCast.get_collision_point()))
			if not tileData: return
			var surface = tileData.get_custom_data("surface")
			
			match surface:
				"wood": audio = wood_walk
				"carpet": audio = carpet_walk
		elif floorRayCast.get_collider() is PhysicsBody2D:
			var surfaceMaterial = SurfaceMaterial.getSurfaceMaterialNode(floorRayCast.get_collider())
			if surfaceMaterial:
				match surfaceMaterial.surface:
					SurfaceMaterial.Surfaces.WOOD: audio = wood_walk
					SurfaceMaterial.Surfaces.CARPET: audio = carpet_walk
					
	if audio:
		walkSfxResetCooldown = walkSfxResetCooldownMax
		if audio != footstepPlayer.stream or not footstepPlayer.playing:
			footstepPlayer.stream = audio
			footstepPlayer.play()
	else:
		if walkSfxResetCooldown: walkSfxResetCooldown -= 1
		else: footstepPlayer.stop()

func _process(_delta: float) -> void:
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
	respawnController.respawn()

## Considers the player airborne with no jump-leeway frames and disables input for x frames.
func airborne(x: int):
	onGround = false
	jumpLeewayTimer = 0
	airborneTimer = x

## Replenishes double jump at the END of this frame.
func replenishDoubleJump():
	if not is_on_floor():
		jumpCounter = 0
		# Prevent physics process from counting current frame as a jump (in the case of handles)
		canJump = false
		#set_deferred("jumpCounter", 0)
		#set_deferred("canJump", false)
