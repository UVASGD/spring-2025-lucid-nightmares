extends Node2D


@export var poster_order: Array[int] = [0, 1, 2]
@onready var controls: Array[Control] = [$Left, $Middle, $Right]
@onready var posters: Array[TextureRect] = [$LibraryPoster, $CloudsPoster, $StrangerPoster]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(poster_order.size()):
		var control: Control = controls[i]
		var poster: TextureRect = posters[poster_order[i]].duplicate()
		control.add_child(poster)
		poster.position = Vector2(0, 0)
		poster.visible = true
		control.clip_contents = true
	pass # Replace with function body.
