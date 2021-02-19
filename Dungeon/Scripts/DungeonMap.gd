extends Spatial

onready var cells_container = $CellsContainer
onready var tween: Tween = $Tween

export(int) var MAX_CELLS = 5

var cell_count = 0

func _ready():
	new_entrance_cell()

func instance_scene(scene,joint_transform = null):
	var new_scene = load(scene).instance()
	new_scene.name = str(cell_count)
	cells_container.add_child(new_scene)
	if joint_transform:
		new_scene.global_transform = joint_transform
		new_scene.global_transform.origin.y = -20
		tween_scene(new_scene)
	if new_scene.get_cell_type() != DungeonCellsDb.type.EXIT:
		new_scene.connect("on_door_clicked",self,"_on_door_clicked")

func new_entrance_cell():
	var cell = DungeonCellsDb.get_entrance()
	instance_scene(cell)

func new_corridor_cell(joint_transform,blocked_sides):
	var cell = DungeonCellsDb.get_corridor(blocked_sides)
	instance_scene(cell,joint_transform)

func new_regular_cell(joint_transform,blocked_sides):
	cell_count += 1
	var cell = DungeonCellsDb.get_regular(blocked_sides)
	instance_scene(cell,joint_transform)

func new_end_cell(joint_transform):
	var cell = DungeonCellsDb.get_end()
	instance_scene(cell,joint_transform)

func tween_scene(scene):
	tween.interpolate_property(scene,"global_transform:origin:y",-20.0,0.0,0.25,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()

func _on_door_clicked(joint_transform,cell_type,blocked_sides):
	match cell_type:
		DungeonCellsDb.type.ENTRANCE,DungeonCellsDb.type.REGULAR:
			new_corridor_cell(joint_transform,blocked_sides)
		DungeonCellsDb.type.CORRIDOR:
			if cell_count >= MAX_CELLS:
				new_end_cell(joint_transform)
			else:
				new_regular_cell(joint_transform,blocked_sides)
