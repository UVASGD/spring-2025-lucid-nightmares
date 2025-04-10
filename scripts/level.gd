extends Node2D
class_name Level

enum RealityMode {NORMAL, HOT, COLD}

@export var allowTelekinesis: bool = true
@export var reality: RealityMode = RealityMode.NORMAL
@export var disableDoubleJump = false
@export var startingElevator: StartElevator = null

## Forces the player to choose hot or cold - cannot use neutral
var forceReality = false

var camera: CustomCamera = null
var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setAllowTelekinesis(allowTelekinesis)
	# Locate camera node and make sure it is in front
	for node in get_children():
		if node is CustomCamera:
			move_child(node, get_child_count())
			camera = node
		elif node is Player:
			player = node
		if player and camera:
			break
	
	if disableDoubleJump:
		player.AIR_JUMPS = 0
		
	if startingElevator and PlayerGlobalVars.firstLoad:
		startingElevator.player = player
		startingElevator.playAnimation()
		PlayerGlobalVars.firstLoad = false

# A really scuffed way of properly initializing tilemap objects
var delayedCall = false
func _process(delta: float) -> void:
	if not delayedCall:
		setAllowTelekinesis(allowTelekinesis)
		delayedCall = true

func setAllowTelekinesis(allow: bool):
	allowTelekinesis = allow
	if not allow:
		get_tree().call_group("TelekineticControllers", "set_enabled", allowTelekinesis)
	
func cycleRealityForward():
	reality += 1
	if reality > RealityMode.size() - 1: reality = 0
	if reality == 0 and forceReality: reality = 1
	callRealityChange()

func cycleRealityBackward():
	reality -= 1
	if reality < 0: reality = RealityMode.size() - 1
	if reality == 0 and forceReality: reality = 2
	callRealityChange()
	
# Considering moving to using a signal bus instead of groups. There's no way to enforce that this method exists
func callRealityChange():
	get_tree().call_group("RealityObject", "on_reality_change", reality)
	

static func getLevelObject(sceneTree: SceneTree) -> Level:
	var level: Level
	for child in sceneTree.root.get_children():
		if child is Level: return child
	return null
