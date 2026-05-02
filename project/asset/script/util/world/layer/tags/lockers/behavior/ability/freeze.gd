extends Node

signal fire_drain(map_coords: Vector2i)

var root: LevelRoot
var act: TilesTape = TilesTape.new(2, 1).add("ICE").add("PUDDLE")

func evaporation() -> void:
	root.execute.erase().add_chip(Defaults.pre.fire.instantiate())
	fire_drain.emit(root.execute.tcoords)

func break_ice(damage: int) -> void:
	if root.execute.extract(Tile.BREAK) <= damage: evaporation()

func activate(pos: Vector2, damage: int) -> void:
	match root.execute.from_pos(pos).tatlas:
		act.OFF.ICE, act.ON.ICE: break_ice(damage)
		act.OFF.PUDDLE, act.ON.PUDDLE: evaporation() 
