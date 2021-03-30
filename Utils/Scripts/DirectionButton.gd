extends Spatial

signal pressed

func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event.is_action_pressed("left_click"):
		emit_signal("pressed")
