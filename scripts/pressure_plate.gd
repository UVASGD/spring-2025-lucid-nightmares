extends Node2D

var pressed = false
var collisions = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
