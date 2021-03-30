extends Spatial

onready var joint = $Joint
onready var door = $DoorPivot/Door
onready var waypoint_container = $WaypointContainer
onready var entrance_waypoint = $WaypointContainer/WP_ENTRANCE
onready var exit_waypoint = $WaypointContainer/WP_EXIT
onready var anim_player = $AnimationPlayer

export(DungeonCellsDb.direction) var direction = DungeonCellsDb.direction.NORTH

var accessed = false

signal on_create_cell(joint,waypoints)
signal on_move_player(waypoints)

func get_joint():
	return joint

func activate():
	anim_player.play("open")
	accessed = true

func was_accessed():
	return accessed

func get_exit_waypoint():
	return exit_waypoint.global_transform

func get_entrance_waypoint():
	return entrance_waypoint.global_transform
