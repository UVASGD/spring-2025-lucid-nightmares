extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var level = Level.getLevelObject(get_tree())
		if not level: return
		for node in level.get_children():
			if node is DeathCeiling:
				node.stop()
