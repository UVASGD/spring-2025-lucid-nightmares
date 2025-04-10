# from: https://gist.github.com/jotson/f31e4ac21217f8943870a18776e2b7d0

extends PinJoint2D

var rotation_fix = 0	

func _ready():
	if node_a and node_b:
		var a: PhysicsBody2D = get_node(node_a)
		var b: PhysicsBody2D = get_node(node_b)
		node_a = ''
		node_b = ''
		connect_bodies(a, b)

# Connect both bodies to the joint, save the relative rotation, and
# connect signals to disconnect the joint if either body is deleted
func connect_bodies(body1 : PhysicsBody2D, body2 : PhysicsBody2D):
	node_a = body1.get_path()
	node_b = body2.get_path()
	
	# This rotation fix is used in physics_process to keep the
	# rotation of the parent fixed relative to another body as it rotates
	var angle_to_body = (global_position - body2.global_position).angle()
	rotation_fix = get_parent().global_rotation - angle_to_body

	# The game will crash if connected nodes are removed from the scene
	body1.connect("tree_exiting", Callable(self, "disconnect_joint"))
	body2.connect("tree_exiting", Callable(self, "disconnect_joint"))




func _physics_process(_delta):
	# All of the standard physics joints allow free rotation around the joint
	# connection. Godot 3.2 doesn't have the concept of a "fixed joint"
	# but there is a proposal.
	#
	# This fixes the rotation of the parent object relative to the rotation
	# of the connected object. This makes the pinjoint work like the two objects
	# are welded together -- a Fixed Joint.
	if node_b:
		var object : PhysicsBody2D = get_node(node_b)
		if object:
			var angle_to_body = (global_position - object.global_position).angle()
			get_parent().set_deferred("rotation", angle_to_body + rotation_fix)
		else:
			node_b = ''
	

func disconnect_joint():
	node_a = ''
	node_b = ''
	
