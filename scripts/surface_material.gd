extends Node2D
class_name SurfaceMaterial
enum Surfaces {CARPET, WOOD}

@export var surface: Surfaces = Surfaces.CARPET

static func getSurfaceMaterial(body) -> SurfaceMaterial:
	var controller = null
	for node in parent.get_children():
		if node is RespawnController:
			controller = node
			break
	return controller
