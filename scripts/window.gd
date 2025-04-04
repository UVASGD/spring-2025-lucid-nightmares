extends StaticBody2D

@onready var teleController: TelekineticController = $TelekineticController
@onready var level: Level = Level.getLevelObject(get_tree())

# window_planets.tscn
@onready var windowPlanets: Node2D = load("uid://brotysyfle1aw").instantiate()


enum RealityMode {NORMAL, HOT, COLD}

var timer: int = 0
const ANIM_CYCLE = 120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if level:
		var container = level.get_node("ParallaxBackground/PlanetContainer")
		if container:
			container.add_child(windowPlanets)
			windowPlanets.set_anchors(self, level, container)
		else:
			print("failed to find container")
			windowPlanets = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if teleController.is_selected and level:
		if Input.is_action_just_pressed("TelekineticLeft"):
			level.cycleRealityBackward()
		elif Input.is_action_just_pressed("TelekineticRight"):
			level.cycleRealityForward()
		
	elif not level:
		print("Level not found")


			
	


func on_reality_change(reality: int):
	pass
