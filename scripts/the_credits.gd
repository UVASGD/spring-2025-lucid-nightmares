extends Node2D

const konami = ["Up", "Up", "Down", "Down", "Left", "Right", "Left", "Right", "B", "A"]
var konamiProgress = 0
var playground = load("uid://bxsl34nbkakxj")
var main_menu = load("uid://c0tvrj084xnrs")
@onready var credits = $MarginContainer
@onready var quitLabel = $QuitLabel

@export var scrollTime = 35

var returnButtonShown: bool = false
var title: PackedScene = load("uid://c0tvrj084xnrs")

@onready var end_y = -credits.size.y - 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer2/FadeRect.visible = true
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/FadeRect, "modulate:a", 0.0, 3.0)
	
	var start_y = 400
	credits.position.y = start_y

	var tween2 = create_tween()
	tween2.tween_property(credits, "position:y", end_y, scrollTime).set_trans(Tween.TRANS_LINEAR)

var escPresses: int = 0

func _process(_delta):
	if !returnButtonShown and credits.position.y == end_y:
		$ReturnButton.show()
		returnButtonShown = true
	if Input.is_action_just_pressed("Quit"):
		escPresses += 1
		if escPresses >= 2:
			var tween = create_tween()
			tween.tween_property($CanvasLayer2/FadeRect, "modulate:a", 1.0, 0.5)
			await get_tree().create_timer(0.5).timeout
			GameContainer.get_game_container(get_tree()).loadScene(title)
		else:
			quitLabel.text = "Press Esc again to quit to title screen"
			get_tree().create_timer(3).timeout.connect(resetQuit)
		

func resetQuit():
	escPresses -= 1
	quitLabel.text = ""

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var action_name = event.as_text_key_label()
		if action_name == konami[konamiProgress]:
			konamiProgress += 1
			if konamiProgress == konami.size():
				PlayerGlobalVars.respawnPoint = Vector2.ZERO
				PlayerGlobalVars.firstLoad = true
				GameContainer.get_game_container(get_tree()).loadScene(playground)
				konamiProgress = 0
		else:
			# If input doesn't match, but was the start of the sequence, reset to 1, otherwise 0
			if action_name == konami[0]:
				konamiProgress = 1
			else:
				konamiProgress = 0


func _on_texture_button_button_down() -> void:
	GameContainer.get_game_container(get_tree()).loadScene(main_menu)
