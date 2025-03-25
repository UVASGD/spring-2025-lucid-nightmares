extends Node2D


##########################################################################
#                                                                        #
#                                                                        #
#                         DEPRECATED: DO NOT USE                         #
#                                                                        #
#                                                                        #
##########################################################################

# Cut from game

## serves as the base multimeshinst, is copied
## necessary for supporting points higher than single multimeshinst instance count
@export var multimeshTemplate: PackedScene
## serves as an empty object to append multimesh instances to
@onready var multimeshCollection: Node2D
## defines the amount of multimeshes a single multimeshinst can create
var INSTANCE_COUNT: int = 8192

## instantiates (copy cstr) and appends a multimesh to the collection 
func newMultimesh() -> MultiMeshInstance2D:
	var multimeshInst: MultiMeshInstance2D = multimeshTemplate.instantiate() as MultiMeshInstance2D
	multimeshInst.multimesh = multimeshInst.multimesh.duplicate() as MultiMesh
	
	multimeshInst.multimesh.instance_count = INSTANCE_COUNT
	multimeshInst.multimesh.visible_instance_count = 0

	multimeshCollection.add_child(multimeshInst)
	multimeshInst.set_as_top_level(true)
	multimeshInst.global_transform = Transform2D.IDENTITY
	
	return multimeshInst

func clearMultimeshes():
	for multimesh: Node2D in multimeshCollection.get_children():
		multimesh.queue_free()

func setPointAtIndex(index: int, transform: Transform2D, color: Color):
	## as the container holds multimeshes, and only makes a new one when previous
	## multimesh is full of instances, this converts a multimesh agnostic index
	## into the id of the multimesh it represents 
	var multimeshID: int = index / INSTANCE_COUNT
	var childCount: int = multimeshCollection.get_child_count()
	if multimeshID >= childCount:
		newMultimesh();
	var multimeshInst = (multimeshCollection.get_child(multimeshID) as MultiMeshInstance2D).multimesh
	
	var pointID: int = index % INSTANCE_COUNT
	multimeshInst.visible_instance_count = max(multimeshInst.visible_instance_count, pointID + 1)
	multimeshInst.set_instance_transform_2d(pointID, transform)
	multimeshInst.set_instance_color(pointID, color)
	
func echolocate(start: Vector2, end: Vector2):
	pass
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
