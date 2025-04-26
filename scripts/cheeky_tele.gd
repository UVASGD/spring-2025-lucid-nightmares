extends Area2D

@onready var level: Level = Level.getLevelObject(get_tree())

func _on_body_entered(body):
	
	if body is Player:
		var character: Player = body
		var offset = level.camera.global_position - character.global_position
		level.camera.position_smoothing_enabled = false
		character.global_position = character.global_position - Vector2(330.0, 1361.0)
		level.camera.global_position = character.global_position + offset
		call_deferred("restoreCam")

func restoreCam() :
	level.camera.position_smoothing_enabled = true
