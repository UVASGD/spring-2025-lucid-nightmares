extends Node
class_name TelekineticObject

var is_selected: bool = false
@export var is_enabled: bool = true
@export var marker: Control = null

func set_enabled(boo: bool):
	is_enabled = boo
	
func set_selected(boo: bool):
	is_selected = boo
	if marker != null:
		if boo:
			marker.visible = true
		else:
			marker.visible = false
