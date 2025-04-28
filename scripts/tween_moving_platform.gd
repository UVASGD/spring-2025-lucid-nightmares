extends Node2D

@onready var animBody = $AnimatableBody2D
@onready var audioPlayer = $AnimatableBody2D/AudioStreamPlayer2D
@onready var sprite = $AnimatableBody2D/Sprite2D
@export var offset = Vector2(0, -200)
@export var duration = 5.0
@export var pauseTime = 1.0
@export var moveSound: AudioStream
@export var attenuation: float = 5
@export var maxDistance: float = 500
@export var platformTexture: Texture2D = null
var tweenPlatform: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if platformTexture:
		sprite.modulate = Color("ffffff")
		sprite.texture = platformTexture
	if not tweenPlatform:
		tween()
	if moveSound:
		audioPlayer.stream = moveSound
		audioPlayer.attenuation = attenuation
		audioPlayer.max_distance = maxDistance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func tween():
	tweenPlatform = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tweenPlatform.set_loops().set_parallel(false)
	if moveSound:
		tweenPlatform.tween_callback(audioPlayer.play)
	tweenPlatform.tween_property(animBody, "position", offset, duration / 2)
	if moveSound:
		tweenPlatform.tween_callback(audioPlayer.stop)
	tweenPlatform.tween_property(animBody, "position", offset, pauseTime)
	if moveSound:
		tweenPlatform.tween_callback(audioPlayer.play)
	tweenPlatform.tween_property(animBody, "position", Vector2.ZERO, duration / 2)
	if moveSound:
		tweenPlatform.tween_callback(audioPlayer.stop)
	tweenPlatform.tween_property(animBody, "position", Vector2.ZERO, pauseTime)
