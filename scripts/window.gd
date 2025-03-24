extends StaticBody2D

@onready var teleController: TelekineticController = $TelekineticController
@onready var level: Level = Level.getLevelObject(get_tree())

enum RealityMode {NORMAL, HOT, COLD}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
