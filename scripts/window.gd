extends StaticBody2D
class_name TelekineticWindow

@onready var teleController: TelekineticController = $TelekineticController
@onready var level: Level = Level.getLevelObject(get_tree())

# window_planets.tscn
@onready var windowPlanets: Node2D = load("res://scenes/window_planets.tscn").instantiate()
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if teleController.is_selected and level:
		if Input.is_action_just_pressed("TelekineticLeft"):
			level.cycleRealityBackward()
		elif Input.is_action_just_pressed("TelekineticRight"):
			level.cycleRealityForward()
		
	elif not level:
		print("Level not found")
