extends CharacterBody2D
class_name TelekineticCloud

@onready var sprite: Sprite2D = $Sprite2D
@onready var teleController: TelekineticController = $TelekineticController
@onready var collisionShape = $CollisionShape2D
@onready var floorArea: Area2D = $FloorArea
@onready var despawnTimer: Timer = $DespawnTimer
@onready var respawnTimer: Timer = $RespawnTimer

var playerStandingOn: bool = false

var maxSpeed = 75
const FRICTION = 13
const AIR_FRICTION = 2

var INERTIA = 25.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleController.addControl("Left Arrow", "Move tile left")
	teleController.addControl("Right Arrow", "Move tile right")
	teleController.addControl("Down Arrow", "Move tile down")
	teleController.addControl("Up Arrow", "Move tile up")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if teleController.is_selected and not playerStandingOn:
		# calculate direction to go
		var x = Input.get_axis("TelekineticLeft", "TelekineticRight")
		var y = Input.get_axis("TelekineticUp", "TelekineticDown")
		var dir: Vector2 = Vector2(x, y)
		velocity = dir * maxSpeed
	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
			velocity.y = move_toward(velocity.y, 0, AIR_FRICTION)
		elif is_on_floor() or velocity.is_zero_approx():
			velocity.x = move_toward(velocity.x, 0, FRICTION)
	move_and_slide()


func _on_telekinetic_controller_on_set_enabled(is_enabled: bool) -> void:
	if is_enabled:
		sprite.modulate = Color("ff97f7")
	else:
		sprite.modulate = Color("ff97f796")
		
func _on_floor_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerStandingOn = true
		despawnTimer.start()
		

func _on_floor_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerStandingOn = false

func despawn():
	sprite.visible = false
	collisionShape.disabled = true
	respawnTimer.start()
	
func respawn():
	sprite.visible = true
	collisionShape.disabled = false
	
