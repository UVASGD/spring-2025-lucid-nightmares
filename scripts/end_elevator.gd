extends Node2D
class_name EndElevator

var player: Player

@onready var area: Area2D = $Area2D
@onready var remoteTransform: RemoteTransform2D = $RemoteTransform2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var nextLevel: PackedScene = null
@export var showTip: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("PlayerJump") and player:
		remoteTransform.remote_path = player.get_path()
		player.overridePhysics = true
		player.velocity = Vector2.ZERO
		animPlayer.play("end")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		if showTip:
			$Label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		$Label.visible = false
		
func fadePlayer():
	if player != null:
		player.fadeOut()
		
func fadeCamera():
	if player != null:
		player.camera.fadeToBlack()
		
func fadeMusic():
	Level.getLevelObject(get_tree()).fadeMusic(1.0)
		
func loadNextLevel():
	if nextLevel:
		PlayerGlobalVars.respawnPoint = Vector2.ZERO
		PlayerGlobalVars.firstLoad = true
		PlayerGlobalVars.musicProgress = 0
		get_tree().change_scene_to_packed(nextLevel)
	
