extends Node2D

@onready var animBody = $AnimatableBody2D
@export var offset = Vector2(0, -200)
@export var duration = 5.0
@export var pauseTime = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_children().size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
