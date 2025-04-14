extends Area2D
class_name Checkpoint

@export var phase: int = 0
var activated = false
@onready var sprite = $AnimatedSprite2D
@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var level: Level = Level.getLevelObject(get_tree())
var audio = load("res://assets/checkpoint/checkpoint.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.animation = "inactive"
	audioPlayer.stream = audio
	if level:
		level.registerCheckpoint(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if activated: return
	if body is Player:
		if body.checkpoint_phase <= phase:
			PlayerGlobalVars.respawnPoint = global_position
			body.checkpoint_phase = phase
			setActivated(true)
			

func setActivated(boo: bool):
	activated = boo
	if boo: 
		sprite.play("active")
		audioPlayer.play()
	else: sprite.animation = 'inactive'
