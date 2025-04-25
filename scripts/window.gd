extends StaticBody2D
class_name TelekineticWindow

@onready var teleController: TelekineticController = $TelekineticController
@onready var level: Level = Level.getLevelObject(get_tree())

# window_planets.tscn
var windowPlanets: Node2D = preload("uid://brotysyfle1aw").instantiate()
# this persists on reloads
static var planetsMade = false
const PLANET_SCALE = Vector2(3, 3)
enum RealityMode {NORMAL, HOT, COLD}

var timer: int = 0
const ANIM_CYCLE = 120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if level and not planetsMade:
		planetsMade = true
		if level.camera:
			var camera: CustomCamera = level.camera
			var container = camera.spaceContainer
			if container:
				windowPlanets.scale = PLANET_SCALE
				container.add_child(windowPlanets)
				windowPlanets.set_anchors(self, level, container)
			else:
				print("Window: Failed to find container")
				windowPlanets = null
		else:
			print("Window: Failed to find camera")
	teleController.addControl("Arrow Keys", "Move block around")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if teleController.is_selected and level:
		if Input.is_action_just_pressed("TelekineticLeft"):
			level.cycleRealityBackward()
		elif Input.is_action_just_pressed("TelekineticRight"):
			level.cycleRealityForward()
		
	elif not level:
		print("Level not found")
		
static func customControlMap(tree: SceneTree) -> String:
	var controlMap: Dictionary = {}
	var level = Level.getLevelObject(tree)
	
	if level.forceReality:
		if level.reality == RealityMode.HOT:
			controlMap["Left"] = "[color=AQUA]COLD[/color]"
			controlMap["Right"] = "[color=AQUA]COLD[/color]"
		else:
			controlMap["Left"] = "[color=RED]HOT[/color]"
			controlMap["Right"] = "[color=RED]HOT[/color]"
	else:
		var left = level.reality - 1
		var right = level.reality + 1
		
		if left < 0: left = 2
		if right > 2: right = 0
		
		if left == RealityMode.NORMAL:
			controlMap["Left"] = "NORMAL"
		elif left == RealityMode.HOT:
			controlMap["Left"] = "[color=RED]HOT[/color]"
		else:
			controlMap["Left"] = "[color=AQUA]COLD[/color]"
		
		if right == RealityMode.NORMAL:
			controlMap["Right"] = "NORMAL"
		elif right == RealityMode.HOT:
			controlMap["Right"] = "[color=RED]HOT[/color]"
		else:
			controlMap["Right"] = "[color=AQUA]COLD[/color]"
		
	var string = ""
	for key in controlMap:
		string += "[b]" + key + "[/b]" + ": " + controlMap[key] + " "
	return "[right]" + string + "[/right]"
	
	
