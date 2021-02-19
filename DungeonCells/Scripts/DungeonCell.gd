extends Spatial

onready var door_container = $DoorContainer

export(DungeonCellsDb.type) var cell_type

signal on_door_clicked

func get_joint_position():
	randomize()
	var random = randi() % door_container.get_child_count()
	var joint_transform = door_container.get_child(random).get_joint_tranform()
	return joint_transform

func get_cell_type():
	return cell_type

func _on_SmallDoor_on_door_clicked(joint):
	var blocked_sides = joint.check_blocked()
	emit_signal("on_door_clicked",joint.global_transform,cell_type,blocked_sides)
