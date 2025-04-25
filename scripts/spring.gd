extends Area2D

@export var VELOCITY = 200
@export var DIRECTION = Vector2(0, -1)
@export var IMPULSE: Vector2 = Vector2(0, -500.0)

@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var springSound: AudioStream = preload("uid://ci22wxtdhabv3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	VELOCITY = abs(VELOCITY)
	if springSound:
		audioPlayer.stream = springSound

func _on_body_entered(body: Node2D) -> void:
	var bounced = false
	if body is CharacterBody2D:
		sprite.play("spring")
		var character: CharacterBody2D = body
		var vector = DIRECTION.normalized() * VELOCITY
		character.velocity.y = vector.y
		character.velocity.x += vector.x
		bounced = true
		if character is Player:
			character.airborne(2)
			character.replenishDoubleJump()
	elif body is RigidBody2D:
		bounced = true
		sprite.play("spring")
		var rigid: RigidBody2D = body
		rigid.apply_impulse(IMPULSE)
		
	if bounced:
		audioPlayer.play()
