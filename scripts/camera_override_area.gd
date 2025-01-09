extends Area2D
class_name CameraOverrideArea

@export var zoom: Vector2 = Vector2(0.85, 0.85)
@export var useCollisionShapeCenter: bool = true
@export var center_position: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func getCenter() -> Vector2:
	if useCollisionShapeCenter:
		var pos = Vector2.ZERO
		for node in get_children():
			if node is CollisionShape2D:
				pos = node.global_position
				break 
		return pos
	else:
		return center_position
	
func getZoom() -> Vector2:
	return zoom
