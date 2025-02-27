extends Node2D

@onready var remoteTransform: RemoteTransform2D = $Area2D/RemoteTransform2D
var inUse = false
var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PlayerDown") and inUse:
		remoteTransform.remote_path = ""
		inUse = false
		if player != null:
			player.overridePhysics = false
		print("down")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		remoteTransform.remote_path = player.get_path()
		player.overridePhysics = true
		inUse = true
