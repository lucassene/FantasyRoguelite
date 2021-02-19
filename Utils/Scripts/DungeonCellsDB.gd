extends Node

# Entrances
var ENTRANCE_01 = {path = "res://DungeonCells/Scenes/Entrances/DungeonEntrance_01.tscn",exits = []}

# Corridors
var CORRIDOR_01 = {path = "res://DungeonCells/Scenes/Corridors/DungeonCorridor_01.tscn",exits = [direction.NORTH]}
var CORRIDOR_02 = {path = "res://DungeonCells/Scenes/Corridors/DungeonCorridor_02.tscn",exits = [direction.EAST]}
var CORRIDOR_03 = {path = "res://DungeonCells/Scenes/Corridors/DungeonCorridor_03.tscn",exits = [direction.WEST]}

# Regulars
var REGULAR_01 = {path = "res://DungeonCells/Scenes/Regular/DungeonCell_01.tscn",exits = [direction.WEST,direction.EAST]}
var REGULAR_02 = {path = "res://DungeonCells/Scenes/Regular/DungeonCell_02.tscn",exits = [direction.WEST]}
var REGULAR_03 = {path = "res://DungeonCells/Scenes/Regular/DungeonCell_03.tscn",exits = [direction.EAST]}

# End
var END_01 = {path = "res://DungeonCells/Scenes/End/DungeonEnd_01.tscn"}

enum type {ENTRANCE,CORRIDOR,REGULAR,EXIT}
enum direction {NORTH,WEST,EAST}

var entrance_list = [ENTRANCE_01]
var corridor_list = [CORRIDOR_01,CORRIDOR_02,CORRIDOR_03]
var regular_list = [REGULAR_01,REGULAR_02,REGULAR_03]
var end_list = [END_01]
var exit_list = []

func get_entrance():
	return get_random_scene(entrance_list)

func get_corridor(blocked_sides):
	return get_random_scene(corridor_list,blocked_sides)

func get_regular(blocked_sides):
	return get_random_scene(regular_list,blocked_sides)

func get_end():
	randomize()
	var random = randi() % end_list.size()
	return end_list[random].path

func get_random_scene(list,blocked_sides = []):
	randomize()
	var scene = null
	if blocked_sides.size() == 0:
		var random = randi() % list.size()
		scene = list[random]
	else:
		var countdown = 10
		while countdown > 0:
			countdown -= 1
			var random = randi() % list.size()
			scene = list[random]
			for exit in scene.exits:
				if exit in blocked_sides:
					scene = null
			if scene: break
		if not scene:
			return get_end()
	return scene.path
