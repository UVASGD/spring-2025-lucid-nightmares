extends Node2D
class_name Level

enum RealityMode {COLD, NORMAL, HOT}

@export var allowTelekinesis: bool = true
@export var reality: RealityMode = RealityMode.NORMAL

var camera: CustomCamera = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setAllowTelekinesis(allowTelekinesis)
	# Locate camera node and make sure it is in front
	for node in get_children():
		if node is CustomCamera:
			move_child(node, get_child_count())
			camera = node
			break

# A really scuffed way of properly initializing tilemap objects
var delayedCall = false
func _process(delta: float) -> void:
	if not delayedCall:
		setAllowTelekinesis(allowTelekinesis)
		delayedCall = true

func setAllowTelekinesis(allow: bool):
	allowTelekinesis = allow
	get_tree().call_group("TelekineticControllers", "set_enabled", allowTelekinesis)
	
func cycleRealityForward():
	reality += 1
	if reality > RealityMode.size() - 1: reality = 0
	updateCameraOverlay()

func cycleRealityBackward():
	reality -= 1
	if reality < 0: reality = RealityMode.size() - 1
	updateCameraOverlay()
	
func updateCameraOverlay():
	if not camera: return
	if reality == RealityMode.COLD:
		camera.coldOverlay()
	elif reality == RealityMode.NORMAL:
		camera.resetOverlay()
	else:
		camera.hotOverlay()
	

static func getLevelObject(sceneTree: SceneTree) -> Level:
	var level: Level
	for child in sceneTree.root.get_children():
		if child is Level: return child
	return null
