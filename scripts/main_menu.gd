extends CanvasLayer

var firstLevel = preload("uid://bvv0kvxphwhqp")
var credits = preload("uid://chn82e6ce6ssa") # credit scene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	PlayerGlobalVars.interactLectern = false
	PlayerGlobalVars.respawnPoint = Vector2.ZERO
	PlayerGlobalVars.firstLoad = true
	get_tree().change_scene_to_packed(firstLevel)


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_packed(credits)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
