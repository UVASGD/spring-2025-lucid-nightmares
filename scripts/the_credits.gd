extends Node2D

const konami = ["Up", "Up", "Down", "Down", "Left", "Right", "Left", "Right", "B", "A"]
var konamiProgress = 0
var playground = load("uid://bxsl34nbkakxj")
var main_menu = load("uid://c0tvrj084xnrs")
@onready var credits = $MarginContainer
@export var scrollTime = 35


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_y = 400
	var end_y = -credits.size.y - 200
	credits.position.y = start_y

	var tween = create_tween()
	tween.tween_property(credits, "position:y", end_y, scrollTime).set_trans(Tween.TRANS_LINEAR)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var action_name = event.as_text_key_label()
		if action_name == konami[konamiProgress]:
			konamiProgress += 1
			if konamiProgress == konami.size():
				PlayerGlobalVars.respawnPoint = Vector2.ZERO
				PlayerGlobalVars.firstLoad = true
				PlayerGlobalVars.musicProgress = 0
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
