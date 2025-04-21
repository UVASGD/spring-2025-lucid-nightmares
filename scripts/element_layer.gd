extends TileMapLayer
class_name ElementalLayer

enum RealityMode {NORMAL, HOT, COLD}

var activateVector: Vector2i = Vector2i.ZERO
var deactivateVector: Vector2i = Vector2i.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deactivateAll()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate(reality: RealityMode):
	for coords in get_used_cells():
		var cellData: Vector2i = get_cell_atlas_coords(coords)
		if reality == RealityMode.HOT:
			if cellData.x == 1: set_cell(coords, 0, Vector2i(0, 0))
			elif cellData.x == 2: set_cell(coords, 0, Vector2i(3, 0))
		elif reality == RealityMode.COLD:
			if cellData.x == 3: set_cell(coords, 0, Vector2i(2, 0))
			elif cellData.x == 0: set_cell(coords, 0, Vector2i(1, 0))

func deactivateAll():
	for coords in get_used_cells():
		var cellData: Vector2i = get_cell_atlas_coords(coords)
		if cellData.x == 2: set_cell(coords, 0, Vector2i(3, 0))
		if cellData.x == 0: set_cell(coords, 0, Vector2i(1, 0))
		
func on_reality_change(reality: int):
	if reality == RealityMode.NORMAL:
		deactivateAll()
	else:
		activate(reality)
