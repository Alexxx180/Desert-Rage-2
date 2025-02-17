extends Node

const SOURCE: int = 2

@onready var link = $link
@onready var button = $button
@onready var trigger = $trigger
@onready var freeze = $freeze

var locks: Dictionary = { "trigger": {}, "machine": {}, "connector": {} }

func switch_cell(lock: Dictionary) -> void:
	lock.atlas.x += 1 if lock.atlas.x % 2 == 0 else -1
	Tile.paint(link.execute, lock)

func activate(map_coords: Vector2i) -> void:
	var activator: Dictionary = locks.trigger[map_coords]
	switch_cell(activator)
	for lock in locks.connector[activator.connector]:
		switch_cell(locks.machine[lock])

func setup(execute: TileMapLayer) -> void:
	link.active_trigger = (func(c): return locks["trigger"].has(c))
	button.tiles = self
	trigger.tiles = self
	freeze.execute = execute
	
	var used_cells: Array[Vector2i]
	var tags: TileMapLayer = self.get_parent()
	link.execute = execute
	for x in range(5):
		for y in range(5):
			var atlas_cell: Vector2i = Vector2i(x, y)
			used_cells = Tile.used_cells(tags, atlas_cell, SOURCE)
			link.connect_tiles(locks, atlas_cell, used_cells)
