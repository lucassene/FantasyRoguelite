extends Spatial

onready var cells_container = $CellsContainer
onready var player_container = $PlayerContainer
onready var tween: Tween = $Tween

export(int) var MAX_CELLS = 10

const CELL_TRANSITION = 0.40

var cell_count = 0
var current_cell setget set_current_cell,get_current_cell
var player

signal on_new_cell(cell,direction)

func get_current_cell():
	return cells_container.get_child(current_cell)

func get_previous_cell():
	return cells_container.get_child(current_cell - 1)

func set_current_cell(value):
	current_cell = value

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		return
		print(get_current_cell().name + " rotation: " + str(get_current_cell().rotation_degrees.y))

func _ready():
	new_entrance_cell()
	spawn_player()

func spawn_player():
	player = PlayerDeck.player_scene.instance()
	player_container.add_child(player)
	player.global_transform = cells_container.get_child(0).get_waypoints()[0]
	player.initialize(self)
	connect("on_new_cell",player,"_on_new_cell")

func move_player_to(waypoints):
	var path = []
	for waypoint in waypoints:
		path.append(waypoint)
	player.add_path(path)

func instance_scene(scene,joint_transform = null):
	var new_scene = load(scene.path).instance()
	new_scene.name = str(cell_count)
	cells_container.add_child(new_scene)
	new_scene.initialize(self,cell_count,scene.exits)
	current_cell = cell_count
	cell_count += 1
	if joint_transform:
		new_scene.global_transform = joint_transform
		new_scene.global_transform.origin.y = -20
		tween_scene(new_scene)
	if new_scene.get_cell_type() != DungeonCellsDb.type.EXIT:
		new_scene.connect("exit_requested",self,"_on_generate_cell")
		new_scene.connect("move_player",self,"_on_move_to_cell")
	emit_signal("on_new_cell",new_scene,new_scene.FORWARD)

func new_entrance_cell():
	var cell = DungeonCellsDb.get_entrance()
	instance_scene(cell)

func new_corridor_cell(joint_transform,blocked_sides):
	var cell = DungeonCellsDb.get_corridor(blocked_sides)
	instance_scene(cell,joint_transform)

func new_regular_cell(joint_transform,blocked_sides):
	var cell = DungeonCellsDb.get_regular(blocked_sides)
	instance_scene(cell,joint_transform)

func new_end_cell(joint_transform):
	var cell = DungeonCellsDb.get_end()
	instance_scene(cell,joint_transform)

func tween_scene(scene):
	tween.interpolate_property(scene,"global_transform:origin:y",-20.0,0.0,CELL_TRANSITION,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()

func access_direction(direction):
	var cell
	if direction != DungeonCellsDb.direction.SOUTH:
		cell = get_current_cell()
		cell.get_exit_info(direction)
	else:
		cell = get_previous_cell()
		current_cell = int(cell.name)
		cell.get_exited_info()

func _on_generate_cell(joint_transform,waypoints,blocked_sides,cell_type):
	match cell_type:
		DungeonCellsDb.type.ENTRANCE,DungeonCellsDb.type.REGULAR:
			new_corridor_cell(joint_transform,blocked_sides)
		DungeonCellsDb.type.CORRIDOR:
			if cell_count >= MAX_CELLS:
				new_end_cell(joint_transform)
			else:
				new_regular_cell(joint_transform,blocked_sides)

func _on_move_to_cell(waypoints,direction):
	if direction == get_current_cell().FORWARD:
		current_cell += 1
	emit_signal("on_new_cell",get_current_cell(),direction)
	move_player_to(waypoints)

func _on_Tween_tween_completed(_object, _key):
	move_player_to(get_current_cell().get_waypoints())
 
