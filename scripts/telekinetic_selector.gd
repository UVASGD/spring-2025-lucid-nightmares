extends Area2D
class_name TelekineticSelector

@onready var area: Area2D = $TelekineticArea
@onready var controlLabel: Label = $"../TelekineticControlLabel"

# Handles selecting telekinetic objects that are in the camera view.
# To be recognized, a body that comes into frame 
# must have a TelekineticController object as a direct child.

var queue: Array = []
var selected_node: TelekineticController = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Tab"):
		cycleQueue(true)
	elif Input.is_action_just_pressed("Q"):
		cycleQueue(false)
		

func _on_telekinetic_area_body_entered(body: Node2D) -> void:
	var teleNode = getTelekineticNodeFromBody(body)
	# add all objects, even if disabled
	if teleNode != null:
		insertNewNode(teleNode)
		# automatically select this object if it's the only one in the queue
		if queue.size() == 1 and teleNode.is_enabled:
			selectNewNode(teleNode)

func _on_telekinetic_area_body_exited(body: Node2D) -> void:
	# should instead store mappings of bodies to telekinetic nodes - later though
	var teleNode = getTelekineticNodeFromBody(body)
	if teleNode != null:
		teleNode.set_selected(false)
		removeNode(teleNode)
		
func cycleQueue(backwards: bool):
	var enabledQueue: Array = queue.filter(func(node): return node.is_enabled)
	if enabledQueue.size() == 0: return
	
	enabledQueue.sort_custom(sortByXGlobalPosition)
	
	# find the currently selected node and select the node that's next in line
	var index = enabledQueue.find(selected_node)
	if index != -1:
		selected_node.set_selected(false)
		if backwards: index -= 1
		else: index += 1
	else:
		if backwards: index = enabledQueue.size() - 1
		else: index = 0
	
	if index == enabledQueue.size(): index = 0
	if index == -1: index = enabledQueue.size() - 1
	
	selectNewNode(enabledQueue[index])
	
func deselectSelectedNode():
	selected_node.set_selected(false)
	selected_node = null
	controlLabel.text = "Tab/Q: Select objects"
	
func selectNewNode(node: TelekineticController):
	selected_node = node
	selected_node.set_selected(true)
	controlLabel.text = selected_node.parseControlMap()

func insertNewNode(node: TelekineticController):
	# insert into the correct sorted location
	var body = node.get_parent()
	for i in range(queue.size()):
		if queue[i].get_parent().position.x > body.position.x:
			queue.insert(i, node)
			return
	queue.append(node)

func removeNode(node: TelekineticController):
	var index = queue.find(node)
	if index != -1: queue.remove_at(index)
	if node == selected_node: deselectSelectedNode()
	
func sortByXGlobalPosition(node1: TelekineticController, node2: TelekineticController):
	var body1 = node1.get_parent()
	var body2 = node2.get_parent()
	if body1.global_position.x < body2.global_position.x:
		return true
	return false
	
static func getTelekineticNodeFromBody(body: Node2D) -> TelekineticController:
	var teleNode = null
	for node in body.get_children():
		if node is TelekineticController:
			teleNode = node
			break 
	return teleNode
