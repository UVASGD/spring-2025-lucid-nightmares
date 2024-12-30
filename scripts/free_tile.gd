extends TelekineticObject

@onready var charBody: CharacterBody2D = $CharacterBody2D
@onready var marker = $CharacterBody2D/Marker

var maxSpeed = 300
var friction = 50

var framesStoodOn = 0
var playerStandingOn = false
var burnedOut = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_selected:
		incrementBurnout()
		# calculate direction to go
		var x = Input.get_axis("TelekineticLeft", "TelekineticRight")
		var y = Input.get_axis("TelekineticUp", "TelekineticDown")
		var dir: Vector2 = Vector2(x, y)
		charBody.velocity = dir * maxSpeed
	else:
		if not charBody.is_on_floor():
			charBody.velocity += charBody.get_gravity() * delta
		elif charBody.is_on_floor() or charBody.velocity.is_zero_approx():
			if burnedOut:
				set_enabled(true)
				burnedOut = false
				charBody.velocity = Vector2.ZERO
	charBody.move_and_slide()

func set_selected(boo: bool):
	is_selected = boo
	if boo:
		marker.visible = true
	else:
		marker.visible = false
		charBody.velocity = Vector2.ZERO

func incrementBurnout():
	if burnedOut: return
	if playerStandingOn and not charBody.is_on_floor():
		framesStoodOn += 1
		if framesStoodOn >= 120:
			triggerBurnout()
	elif charBody.is_on_floor():
		framesStoodOn = 0
			
func triggerBurnout():
	framesStoodOn = 0
	burnedOut = true
	set_selected(false)
	set_enabled(false)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == Player.floor_area_name:
		playerStandingOn = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == Player.floor_area_name:
		playerStandingOn = false
