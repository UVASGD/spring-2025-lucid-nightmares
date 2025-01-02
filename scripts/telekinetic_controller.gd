extends Node
class_name TelekineticController

var is_selected: bool = false
@export var is_enabled: bool = true
@export var marker: Control = null
var controlMap: Dictionary = {}

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
	
func addControl(key: String, action: String):
	controlMap[key] = action
	
func parseControlMap() -> String:
	var str = ""
	for key in controlMap:
		str += key + ": " + controlMap[key] + "\n"
	return str
