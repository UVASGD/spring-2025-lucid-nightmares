extends StaticBody2D

var smallCloud = load("res://assets/cloud32x16.png")
var bigCloud = load("res://assets/cloud64x16.png")

@onready var collisionPolygon = $CollisionPolygon2D
@onready var sprite = $Sprite2D

var smallShape = [Vector2(-14, 5.5), Vector2(14, 5.5), Vector2(14, -5.5), Vector2(-14, -5.5)]
var bigShape = [Vector2(-23, 8), Vector2(-30, 5), Vector2(-30, 2), Vector2(-19, -5), Vector2(18, -5), Vector2(30, 0), 
Vector2(30, 5), Vector2(23, 8)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	smallShape = PackedVector2Array(smallShape)
	bigShape = PackedVector2Array(bigShape)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func changeToBig():
	collisionPolygon.polygon = bigShape
	sprite.texture = bigCloud

func changeToSmall():
	collisionPolygon.polygon = smallShape
	sprite.texture = smallCloud
