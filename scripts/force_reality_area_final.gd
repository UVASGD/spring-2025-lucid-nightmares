extends ForceRealityArea

var death_ceiling = preload("res://scenes/death_ceiling.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var ceiling: DeathCeiling = death_ceiling.instantiate()
		ceiling.global_position = global_position + Vector2(0, -170)
		ceiling.player = body
		Level.getLevelObject(get_tree()).add_child(ceiling)
