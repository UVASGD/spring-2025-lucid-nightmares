extends Node2D
class_name StartElevator

var player: Player = null

@onready var remoteTransform: RemoteTransform2D = $RemoteTransform2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerGlobalVars.respawnPoint = global_position
	
func playAnimation():
	if player != null:
		player.overridePhysics = true
		player.visible = false
		remoteTransform.remote_path = player.get_path()
		animPlayer.play("open")
	
		
func fadePlayer():
	if player != null:
		player.visible = true
		player.fadeIn()
		
func releasePlayer():
	remoteTransform.remote_path = ""
	player.overridePhysics = false
	
