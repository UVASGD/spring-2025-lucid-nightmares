extends Node2D

@onready var IceMasked: TextureRect = $Ice40Masked
@onready var IceTile: TextureRect = $Lava16
@onready var LavaMasked: TextureRect = $Lava40Masked
@onready var LavaTile: TextureRect = $Ice16
@onready var windowTexture: CompressedTexture2D = load("uid://cqyoqi5udgc31")

var verticalOffset: int = 0
var realityMode: RealityMode = RealityMode.NORMAL

var level: Level
var window: StaticBody2D
var container = ParallaxLayer
var camera: Camera2D

enum RealityMode {NORMAL, HOT, COLD}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(RealityMode.NORMAL)
	
	if windowTexture:
		verticalOffset = windowTexture.get_height()/2 
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if window and level:
		set_state(level.reality)
	#if level and window:
		#var xMult = 1 #0.97 if realityMode == RealityMode.NORMAL else 0.9
		#var offset = (camera.global_position - window.global_position) * Vector2(xMult, 1.0)
		#set_global_position(window.global_position + offset - Vector2(0, verticalOffset + 6))
	#
		#timer += 1
	#if timer % ANIM_CYCLE == 0 || timer % ANIM_CYCLE == ANIM_CYCLE / 4:
		#ice16.set_position(ice16.position + Vector2(0, 1))
	#elif timer % ANIM_CYCLE == ANIM_CYCLE / 2 || timer % ANIM_CYCLE == 3 * ANIM_CYCLE / 4:
		#ice16.set_position(ice16.position - Vector2(0, 1))
	
	pass
	
func set_anchors(window_in, level_in, container_in):
	window = window_in
	level = level_in
	if level:
		camera = level.camera
	if container_in and camera:
		container = container_in
		container.set_motion_offset(get_viewport_rect().size/2 - Vector2(0, 33)) #-window.global_position) # - LavaMasked.get_rect().size/2)
		
			
func set_state(reality):
	match reality:
		RealityMode.NORMAL:
			IceMasked.hide()
			LavaMasked.hide()
			IceTile.show()
			LavaTile.show()
		RealityMode.COLD:
			IceMasked.show()
			LavaMasked.hide()
			IceTile.hide()
			LavaTile.hide()
		RealityMode.HOT:
			IceMasked.hide()
			LavaMasked.show()
			IceTile.hide()
			LavaTile.hide()
	realityMode = reality
