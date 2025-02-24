extends StaticBody2D

@onready var interactController: InteractController = $InteractController
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
## Determines how many objects (i.e. pressure plates) need to be interacted with at the same time to open this
@export var signals_to_open = 1
var signals = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interact(who: Node2D, message: int) -> void:
	if message == 1:
		signals += 1
	elif message == 0:
		signals -= 1
	
	if signals >= signals_to_open:
		sprite.self_modulate.a = 0.2
		collisionShape.set_deferred("disabled", true)
	else:
		sprite.self_modulate.a = 1
		collisionShape.set_deferred("disabled", false)
