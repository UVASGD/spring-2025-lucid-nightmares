extends Node2D

var pressed = false
var collisions = 0
@onready var audioPlayer = $AudioStreamPlayer2D
@onready var interactController: InteractController = $InteractController
var stepSound: AudioStream = preload("uid://bm6fup62n4q8v")
@export var interact_targets: Array[Node2D] = []
## If enabled, this pressure plate will record how many objects are standing on it
## and will send signals every time a new object enters/leaves, even if an existing object was already there
@export var weighted = false

func _ready():
	collisions=0
	if stepSound:
		audioPlayer.stream = stepSound

func _on_body_entered(_body: Node2D) -> void:
	collisions=collisions+1
	if weighted or collisions == 1:
		interactController.interact_all_targets(interact_targets, 1)
	if not audioPlayer.playing and pressed == false:
		audioPlayer.play()
	$Area2D/ColorRect.scale=Vector2(1,.5)
	if(collisions>0):
		pressed=true



func _on_body_exited(_body):
	collisions=collisions-1
	if weighted or collisions == 0:
		interactController.interact_all_targets(interact_targets, 0)
	if(collisions==0):
		pressed=false
		audioPlayer.stop()
		$Area2D/ColorRect.scale=Vector2(1,1)
