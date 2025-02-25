extends RigidBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawnController: RespawnController = $RespawnController
var doRespawn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var list: Array = sprite.sprite_frames.get_animation_names()
	sprite.animation = list.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_respawn():
	doRespawn = true
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if doRespawn:
		print("tried to respawn")
		state.transform.origin = respawnController.respawnPoint
		state.angular_velocity = 0
		state.linear_velocity = Vector2.ZERO
		# reset rotation - do this soon
		doRespawn = false
