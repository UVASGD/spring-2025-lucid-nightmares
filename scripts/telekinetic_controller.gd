extends Node
class_name TelekineticController

var is_selected: bool = false
@export var is_enabled: bool = true
@export var marker: Control = null

func set_enabled(boo: bool):
	is_enabled = boo
	# todo - fire signals that parent nodes can connect to here
	
func set_selected(boo: bool):
	is_selected = boo
	if marker != null:
		if boo:
			marker.visible = true
		else:
			marker.visible = false
	# todo - fire signals that parent nodes can connect to here
