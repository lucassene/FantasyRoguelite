extends KinematicBody

onready var state_machine: StateMachine = $StateMachine
onready var controller: ActorController = $PlayerController
onready var direction_controller = $DirectionController
onready var pivot: Spatial = $Pivot

var angles = {
	0: 180,
	90: -90,
	-90: 90,
	180: 0
}
var dungeon_map
var current_cell
var last_rotation = 0
var facing = angles[DungeonCellsDb.direction.NORTH]

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		print(current_cell.name + " rotation: " + str(current_cell.rotation_degrees.y))

func _ready():
	state_machine.initialize("Idle",controller)
	controller.initialize(state_machine)

func _physics_process(delta):
	state_machine.update(delta)

func initialize(map):
	dungeon_map = map
	current_cell = dungeon_map.get_current_cell()
	show_direction_buttons()

func add_path(value):
	state_machine.set_moving_state(value)

func move(direction):
	move_and_slide(direction,Vector3.UP)

func show_direction_buttons():
	direction_controller.set_activated(current_cell.get_exits())

func hide_direction_buttons():
	direction_controller.hide_buttons()

func _on_new_cell(cell,direction):
	current_cell = cell
	if direction == current_cell.BACK:
		direction_controller.rotation_degrees.y = current_cell.rotation_degrees.y
	else:
		pivot.rotation_degrees.y = current_cell.rotation_degrees.y
		direction_controller.rotation_degrees.y = current_cell.rotation_degrees.y

func _on_DirectionController_direction_pressed(direction):
	pivot.rotation_degrees.y = angles[int(round(current_cell.rotation_degrees.y))]
	dungeon_map.access_direction(direction)
