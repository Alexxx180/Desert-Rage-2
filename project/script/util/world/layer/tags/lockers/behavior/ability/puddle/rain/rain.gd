extends Node

var conductor: FlowConductor

func diffusion(map_coords: Vector2i) -> void:
	var tile: Dictionary = { "charge": false }
	conductor.around(map_coords, tile, conductor.diffuse_puddle)
	if tile.charge: conductor.puddle_flow(map_coords)

func watering(_direction: Vector2i) -> void:
	conductor.rain_particle(PreloadBus.rain.instantiate())
	diffusion(conductor.root.execute.tcoords)

func activate(pos: Vector2, direction: Vector2i) -> void:
	if conductor.root.execute.from_pos(pos).tatlas == Def.VECTI:
		watering(direction)
	else:
		print("CAN'T APPLY WATERING")
