extends Node2D
class_name SurfaceMaterial
enum Surfaces {CARPET, WOOD, CLOUD}

@export var surface: Surfaces = Surfaces.CARPET

static func getSurfaceMaterialNode(parent) -> SurfaceMaterial:
	var controller = null
	for node in parent.get_children():
		if node is SurfaceMaterial:
			controller = node
			break
	return controller
