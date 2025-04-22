extends Area2D
@onready var FakeFloor: TileMapLayer = $"FakeFloor"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	if body is Player:
		FakeFloor.modulate.a = 100
		
