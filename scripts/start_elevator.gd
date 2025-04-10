extends Node2D
class_name StartElevator

var player: Player

@onready var remoteTransform: RemoteTransform2D = $RemoteTransform2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var nextLevel: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func playAnimation():
	if player != null:
		player.visible = false
		remoteTransform.remote_path = player.get_path()
		animPlayer.play("open")
	
		
func fadePlayer():
	if player != null:
		player.visible = true
		player.fadeIn()
		
func fadeCamera():
	if player != null:
		player.camera.fadeInFromBlack()
		
func releasePlayer():
	remoteTransform.remote_path = ""
		
func loadNextLevel():
	if nextLevel:
		get_tree().change_scene_to_packed(nextLevel)
		PlayerGlobalVars.respawnPoint = Vector2.ZERO
	
