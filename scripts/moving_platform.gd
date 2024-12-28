extends Node2D

@onready var animBody = $AnimatableBody2D
@export var offset = Vector2(0, -200)
@export var duration = 5.0
@export var pauseTime = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func tween():
	var tween: Tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(animBody, "position", offset, duration / 2)
	tween.tween_property(animBody, "position", offset, pauseTime)
	tween.tween_property(animBody, "position", Vector2.ZERO, duration / 2)
	tween.tween_property(animBody, "position", Vector2.ZERO, pauseTime)
	
