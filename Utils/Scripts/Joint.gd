extends Spatial

onready var north_ray: RayCast = $NorthRay
onready var west_ray: RayCast = $WestRay
onready var east_ray: RayCast = $EastRay

func check_blocked():
	var blocked_sides = []
	if north_ray.is_colliding(): 
		blocked_sides.append(DungeonCellsDb.direction.NORTH)
	if west_ray.is_colliding(): 
		blocked_sides.append(DungeonCellsDb.direction.WEST)
	if east_ray.is_colliding(): 
		blocked_sides.append(DungeonCellsDb.direction.EAST)
	north_ray.enabled = false
	west_ray.enabled = false
	east_ray.enabled = false
	return blocked_sides


