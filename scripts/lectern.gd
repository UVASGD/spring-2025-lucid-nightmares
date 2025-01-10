extends AnimatedSprite2D

@onready var area: Area2D = $Area2D
var activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("lecternwithbook")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not activated and Input.is_action_just_pressed("PlayerJump"):
		var bodies = area.get_overlapping_bodies()
		for body in bodies:
			if body is Player:
				activate()

func activate():
	var camera = get_viewport().get_camera_2d()
	if camera is CustomCamera:
		camera.shake()
	play("lectern")
	var level: Level = get_tree().root.get_child(0)
	level.setAllowTelekinesis(true)
	activated = true
