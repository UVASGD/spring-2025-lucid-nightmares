extends CanvasLayer

var firstLevel = preload("uid://bvv0kvxphwhqp")
var credits = preload("uid://chn82e6ce6ssa") # credit scene
@onready var audioPlayer = $AudioStreamPlayer
@onready var fadeRect = $FadeRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeRect.visible = true
	var tween = create_tween()
	tween.tween_property(fadeRect, "modulate", Color(1, 1, 1, 0), 1.0)


func _on_play_button_pressed() -> void:
	PlayerGlobalVars.interactLectern = false
	PlayerGlobalVars.respawnPoint = Vector2.ZERO
	PlayerGlobalVars.firstLoad = true
	PlayerGlobalVars.musicProgress = 0
	
	var tween = create_tween()
	tween.tween_property(audioPlayer, "volume_db", -80, 1.0)
	var tween2 = create_tween()
	tween2.tween_property(fadeRect, "modulate", Color(1, 1, 1, 0.75), 1.0)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(firstLevel)


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_packed(credits)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
