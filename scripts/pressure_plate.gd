extends Node2D

var pressed = false
var collisions = 0

func _ready():
	collisions=0



func _process(delta):
	print(collisions)


func _on_body_entered(body: Node2D) -> void:
	collisions=collisions+1
	if(collisions>0):
		pressed=true
		$Area2D/ColorRect.scale=Vector2(1,.5)


func _on_body_exited(body):
	collisions=collisions-1
	if(collisions==0):
		pressed=false
		$Area2D/ColorRect.scale=Vector2(1,1)
