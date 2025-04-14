extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Is called by the level object when telekinesis is enabled, 
## because this is marked as a TelekineticController when it's really not lol	
func set_enabled(boo):
	visible = boo
