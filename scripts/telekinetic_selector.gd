extends Camera2D

@onready var area: Area2D = $TelekineticArea

# Queue of 2D bodies
var queue: Array = []
var selected_body: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Tab"):
		cycleQueue(true)
	elif Input.is_action_just_pressed("Q"):
		cycleQueue(false)
		

func _on_telekinetic_area_body_entered(body: Node2D) -> void:
	var parent = body.get_parent()
	# add all objects, even if disabled
	if parent is TelekineticObject:
		queue.append(body)
		if queue.size() == 1 and parent.is_enabled:
			parent.set_selected(true)
			selected_body = body

func _on_telekinetic_area_body_exited(body: Node2D) -> void:
	var parent = body.get_parent()
	if parent is TelekineticObject:
		parent.set_selected(false)
		removeBody(body)
		
func cycleQueue(backwards: bool):
	var enabledQueue: Array = queue.filter(func(body): return body.get_parent().is_enabled)
	if enabledQueue.size() == 0: return
	
	enabledQueue.sort_custom(sortByXGlobalPosition)
	
	var index = enabledQueue.find(selected_body)
	if index != -1:
		selected_body.get_parent().set_selected(false)
		if backwards: index -= 1
		else: index += 1
	else:
		if backwards: index = enabledQueue.size() - 1
		else: index = 0
	
	if index == enabledQueue.size(): index = 0
	if index == -1: index = enabledQueue.size() - 1
	
	selected_body = enabledQueue[index]
	selected_body.get_parent().set_selected(true)
	
func insertNewBody(body: Node2D):
	# insert into the correct sorted location
	for i in range(queue.size()):
		if queue[i].position.x > body.position.x:
			queue.insert(i, body)
			return
	queue.append(body)

func removeBody(body: Node2D):
	var index = queue.find(body)
	if index != -1: queue.remove_at(index)
	
func sortByXGlobalPosition(body1: Node2D, body2: Node2D):
	if body1.global_position.x < body2.global_position.x:
		return true
	return false 
	
