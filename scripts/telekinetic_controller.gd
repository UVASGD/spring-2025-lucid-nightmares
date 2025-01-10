extends Node
class_name TelekineticController

signal on_set_enabled(is_enabled: bool)

var is_selected: bool = false
@export var is_enabled: bool = true
@export var marker: Control = null
var controlMap: Dictionary = {}
# Vector2 is a primitive type. If you don't want the parent body to respawn, set this to Vector2.ZERO
var respawnLocation = Vector2.ZERO

static var spriteModulationColor = Color("ff97f7")

func _ready() -> void:
	add_to_group("TelekineticControllers")
	

func set_enabled(boo: bool):
	is_enabled = boo
	on_set_enabled.emit(boo)
	
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
	var string = ""
	for key in controlMap:
		string += key + ": " + controlMap[key] + "\n"
	return string
