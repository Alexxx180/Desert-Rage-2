extends Node

const SOURCE: int = 2

@onready var link: Node = $link
@onready var button: Node = $button
@onready var trigger: Node = $trigger
@onready var ability: Node = $ability

var locks: Dictionary = { "trigger": {}, "machine": {}, "connector": {} }

func switch_cell(lock: Dictionary) -> void:
	lock.atlas.x += 1 if lock.atlas.x % 2 == 0 else -1
	Tile.paint(link.execute, lock)

func activate(map_coords: Vector2i) -> void:
	var activator: Dictionary = locks.trigger[map_coords]
	switch_cell(activator)
	for lock in locks.connector[activator.connector]:
		switch_cell(locks.machine[lock])

func setup(tags: TileMapLayer, execute: TileMapLayer) -> void:
	link.setup(execute, func(c): return locks.trigger.has(c))
	button.tiles = self
	trigger.tiles = self
	ability.execute = TileDecorator.new(execute)
	
	var used_cells: Array[Vector2i]
	for x in range(5):
		for y in range(5):
			var atlas_cell: Vector2i = Vector2i(x, y)
			used_cells = Tile.used_cells(tags, atlas_cell, SOURCE)
			link.connect_tiles(locks, atlas_cell, used_cells)

	ability.puddle.spark.chains.charge.activate.connect(trigger.map_activate)
