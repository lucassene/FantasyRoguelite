extends Spatial
class_name DungeonCell

onready var door_container = $DoorContainer
onready var waypoint_container = $WaypointContainer

export(DungeonCellsDb.type) var cell_type
export(Array,DungeonCellsDb.direction) var exits

enum {FORWARD,BACK}

signal exit_requested(joint,waypoints,blocked,type)
signal move_player(waypoints,way)

var id setget ,get_id
var dungeon_map
var exited_door

func initialize(_dungeon_map,_id,_exits):
	id = _id
	dungeon_map = _dungeon_map
	exits = _exits

func get_id():
	return id

func get_exits():
	return exits

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		return
		print("rotation: " + str(rotation_degrees.y))

func get_waypoints():
	var path = []
	for waypoint in waypoint_container.get_children():
		path.append(waypoint.global_transform)
	return path

func get_joint_position():
	randomize()
	var random = randi() % door_container.get_child_count()
	var joint_transform = door_container.get_child(random).get_joint_transform()
	return joint_transform

func get_cell_type():
	return cell_type

func get_exit_info(direction):
	var exit
	for door in door_container.get_children():
		if door.direction == direction:
			exited_door = door
			exit = door
			break
	if not exit.was_accessed():
		exit.activate()
		var joint = exit.get_joint()
		var blocked_sides = joint.check_blocked()
		emit_signal("exit_requested",joint.global_transform,[exit.get_exit_waypoint()],blocked_sides,cell_type)
	else:
		emit_signal("move_player",[exit.get_exit_waypoint()],FORWARD)

func get_exited_info():
	emit_signal("move_player",[exited_door.get_entrance_waypoint()],BACK)
