extends StaticBody2D

var smallCloud = load("uid://brro7nlmfxvl8") #cloud 32x16
var bigCloud = load("uid://bm2hplhrx6t73") #cloud 64x16
var big: bool = false

@onready var collisionPolygon = $CollisionPolygon2D
@onready var sprite = $Sprite2D
@onready var growArea = $GrowArea

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
	big = true
	collisionPolygon.polygon = bigShape
	sprite.texture = bigCloud
	await get_tree().process_frame
	collisionPolygon.one_way_collision = true
	collisionPolygon.one_way_collision_margin = 3

func changeToSmall():
	big = false
	collisionPolygon.polygon = smallShape
	sprite.texture = smallCloud
	await get_tree().process_frame
	collisionPolygon.one_way_collision = true
	collisionPolygon.one_way_collision_margin = 1

func _on_grow_area_body_entered(body: Node2D) -> void:
	if big: return
	if body is TelekineticCloud:
		growArea.monitoring = false
		changeToBig()
		body.queue_free()
