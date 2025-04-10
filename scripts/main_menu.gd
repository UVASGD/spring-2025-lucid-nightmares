extends CanvasLayer

var firstLevel = preload("res://scenes/levels/level1-1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	PlayerGlobalVars.respawnPoint = Vector2.ZERO
	PlayerGlobalVars.firstLoad = true
	get_tree().change_scene_to_packed(firstLevel)


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
