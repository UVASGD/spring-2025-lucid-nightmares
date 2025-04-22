extends Area2D

@export var VELOCITY = 200
@export var DIRECTION = Vector2(0, -1)
@export var IMPULSE: Vector2 = Vector2(0, -500.0)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	VELOCITY = abs(VELOCITY)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		sprite.play("spring")
		var character: CharacterBody2D = body
		var vector = DIRECTION.normalized() * VELOCITY
		character.velocity.y = vector.y
		character.velocity.x += vector.x
		if character is Player:
			character.airborne(2)
			character.replenishDoubleJump()
	elif body is RigidBody2D:
		sprite.play("spring")
		var rigid: RigidBody2D = body
		rigid.apply_impulse(IMPULSE)
