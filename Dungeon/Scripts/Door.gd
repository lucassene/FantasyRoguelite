extends Spatial

onready var joint = $Joint
onready var door = $Door

export(Material) var door_material
export(Material) var hover_material

signal on_door_clicked(joint)

func _ready():
	door.material_override = door_material

func get_joint_transform():
	return joint.global_transform

func _on_Area_mouse_entered():
	door.material_override = hover_material

func _on_Area_mouse_exited():
	door.material_override = door_material

func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event.is_action_pressed("left_click"):
		emit_signal("on_door_clicked",joint)
		queue_free()
