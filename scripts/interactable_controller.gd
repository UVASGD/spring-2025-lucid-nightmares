extends Node2D
class_name InteractController

signal on_interact(who: Node2D, message: int)

# 0 - my object was uninteracted with
# 1 - my object was interacted with
	
func emit_interact(who: Node2D, message: int):
	on_interact.emit(who, message)
	
func interact_all_targets(interact_targets: Array[Node2D], message: int):
	for target in interact_targets:
		if target is InteractController:
			target.emit_interact(get_parent(), message)
		else:
			var interactNode = getInteractControllerFromParent(target)
			if interactNode: interactNode.emit_interact(get_parent(), message)

static func getInteractControllerFromParent(parent: Node2D) -> InteractController:
	var interactNode = null
	for node in parent.get_children():
		if node is InteractController:
			interactNode = node
			break 
	return interactNode
