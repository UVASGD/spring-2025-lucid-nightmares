extends Node2D

var pressed = false
var collisions = 0
@onready var interactController: InteractController = $InteractController
@export var interact_targets: Array[Node2D] = []
## If enabled, this pressure plate will record how many objects are standing on it
## and will send signals every time a new object enters/leaves, even if an existing object was already there
@export var weighted = false

func _ready():
	collisions=0


func _on_body_entered(body: Node2D) -> void:
	collisions=collisions+1
	if weighted or collisions == 1:
		interactController.interact_all_targets(interact_targets, 1)
	if(collisions>0):
		pressed=true
		$Area2D/ColorRect.scale=Vector2(1,.5)


func _on_body_exited(body):
	collisions=collisions-1
	if weighted or collisions == 0:
		interactController.interact_all_targets(interact_targets, 0)
	if(collisions==0):
		pressed=false
		$Area2D/ColorRect.scale=Vector2(1,1)
