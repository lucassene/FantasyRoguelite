extends State

export var SPEED = 15

var path = []
var current_path_node = 0

func add_path(value):
	path += value

func enter(_delta = 0.0):
	print("Moving")
	actor.hide_direction_buttons()
	current_path_node = 0

func update(_delta):
	if current_path_node < path.size():
		var direction = (path[current_path_node].origin - actor.global_transform.origin)
		if direction.length() < 1:
			current_path_node += 1
		else:
			actor.move(direction.normalized() * SPEED)
	else:
		path = []
		actor.show_direction_buttons()
		state_machine.set_state("Idle")
