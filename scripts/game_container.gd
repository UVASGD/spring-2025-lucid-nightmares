extends Node2D
class_name GameContainer

var main_menu = load("uid://c0tvrj084xnrs")
var current_scene: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadScene(main_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func loadScene(scene: PackedScene):
	unloadScene()
	current_scene = scene
	var inst = scene.instantiate()
	add_child(inst)
	
func reloadScene():
	unloadScene()
	var inst = current_scene.instantiate()
	add_child(inst)
			
func unloadScene():
	if not current_scene: return
	for child in get_children():
		if child.scene_file_path == current_scene.resource_path:
			child.queue_free()
			return
	
static func get_game_container(sceneTree: SceneTree) -> GameContainer:
	for child in sceneTree.root.get_children():
		if child is GameContainer: return child
	return null
