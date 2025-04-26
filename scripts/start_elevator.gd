extends Node2D
class_name StartElevator

var player: Player = null

@onready var remoteTransform: RemoteTransform2D = $RemoteTransform2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@export var floorNumber: int = 1

const l1 = preload("uid://hcmoha8s6ufe")
const l2 = preload("uid://2g0q4nkcbbjx")
const l3 = preload("uid://ndw0v6n3v0wc")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if floorNumber == 1:
		$Sprite2D.texture = l1
	elif floorNumber == 2:
		$Sprite2D.texture = l2
	else:
		$Sprite2D.texture = l3
	
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
	
