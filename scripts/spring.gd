extends Area2D

@export var VELOCITY = 200
@export var DIRECTION = Vector2(0, -1)
@export var IMPULSE: Vector2 = Vector2(0, -500.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	VELOCITY = abs(VELOCITY)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var char: CharacterBody2D = body
		char.velocity = DIRECTION.normalized() * VELOCITY
		if char is Player:
			char.airborne(2)
	elif body is RigidBody2D:
		var rigid: RigidBody2D = body
		rigid.apply_impulse(IMPULSE)
