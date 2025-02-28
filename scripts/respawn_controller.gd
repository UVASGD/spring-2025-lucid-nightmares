extends Node2D
class_name RespawnController

var respawnPoint: Vector2 = Vector2.ZERO
signal respawn_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	if parent is Node2D:
		respawnPoint = parent.global_position

func respawn():
	var parent = get_parent()
	respawn_signal.emit()
	if parent is Node2D and parent is not RigidBody2D:
		parent.global_position = respawnPoint
	if parent is CharacterBody2D:
		parent.velocity = Vector2.ZERO
		if parent is Player:
			get_tree().reload_current_scene()
			parent.global_position = respawnPoint
		
static func getRespawnController(parent: Node2D) -> RespawnController:
	var controller = null
	for node in parent.get_children():
		if node is RespawnController:
			controller = node
			break
	return controller
