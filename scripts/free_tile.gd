extends TelekineticObject

@onready var animBody = $AnimatableBody2D
@onready var marker = $Marker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	marker.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_selected(boo: bool):
	is_selected = boo
	if boo:
		marker.visible = true
