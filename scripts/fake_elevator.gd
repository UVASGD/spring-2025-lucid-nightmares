extends Node2D
class_name FakeElevator

@onready var floorMap: TileMapLayer = $Floor
@onready var elevator: Sprite2D = $Elevator
@onready var area: Area2D = $Elevator/Area2D
@onready var remoteTransform: RemoteTransform2D = $Elevator/RemoteTransform2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerGlobalVars.fakeElevatorTriggered:
		disappear()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PlayerJump") and player:
		remoteTransform.remote_path = player.get_path()
		player.overridePhysics = true
		player.velocity = Vector2.ZERO
		animPlayer.play("end")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		
func disappear():
	if player:
		player.overridePhysics = false
	remoteTransform.remote_path = ""
	
	floorMap.collision_enabled = false
	floorMap.visible = false
	elevator.visible = false
	area.monitoring = false
	PlayerGlobalVars.fakeElevatorTriggered = true
	
func shakeCamera():
	if player != null:
		player.camera.shake()
