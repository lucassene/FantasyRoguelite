extends Spatial

signal direction_pressed(direction)

func set_activated(exits):
	hide_buttons()
	for exit in exits:
		get_child(exit).visible = true

func hide_buttons():
	for button in get_children():
		button.visible = false

func _on_N_pressed():
	hide_buttons()
	emit_signal("direction_pressed",DungeonCellsDb.direction.NORTH)

func _on_S_pressed():
	hide_buttons()
	emit_signal("direction_pressed",DungeonCellsDb.direction.SOUTH)

func _on_E_pressed():
	hide_buttons()
	emit_signal("direction_pressed",DungeonCellsDb.direction.EAST)

func _on_W_pressed():
	hide_buttons()
	emit_signal("direction_pressed",DungeonCellsDb.direction.WEST)
