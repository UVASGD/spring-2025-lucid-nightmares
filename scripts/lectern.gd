extends AnimatedSprite2D

@onready var area: Area2D = $Area2D
@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
var activated: bool = false

var pagesSound = load("uid://nb450gw2y5a3")
var disconnectSound = load("uid://bikgu6hamdbln")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerGlobalVars.interactLectern:
		play("lectern")
	else:
		play("lecternwithbook")
	activated = PlayerGlobalVars.interactLectern
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not activated and Input.is_action_just_pressed("PlayerJump"):
		var bodies = area.get_overlapping_bodies()
		for body in bodies:
			if body is Player:
				activate()

func activate():
	audioPlayer.stop()
	audioPlayer.stream = pagesSound
	audioPlayer.play()
	await get_tree().create_timer(1).timeout
	audioPlayer.stop()
	audioPlayer.stream = disconnectSound
	audioPlayer.play()
	var camera = get_viewport().get_camera_2d()
	if camera is CustomCamera:
		camera.shake()
	play("lectern")
	var level: Level
	level = Level.getLevelObject(get_tree())
	level.setAllowTelekinesis(true)
	PlayerGlobalVars.interactLectern = true
	activated = true
