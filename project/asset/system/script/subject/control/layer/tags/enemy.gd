extends Node

const SOURCE: int = 4

var places: Array[Vector2i]

func setup(tags: TileMapLayer, execute: TileMapLayer) -> void:
	places = tags.get_used_cells_by_id(SOURCE)
	var i: int = 0
	while i < places.size() - 1:
		var tag: Vector2i = places[i]
		var tile: Dictionary = Tile.from_coords(tags, tag)
		var enemy: CharacterBody2D
		match tile.atlas:
			Vector2i(1, 0): enemy = foe[tags.boss].instantiate()
			_: enemy = foe[tags.foe.pick_random()].instantiate()
		execute.add_child(enemy)
		enemy.teleport(Tile.get_pos(execute, tag))
		enemy.transport_index = i
		enemy.view.animation.dead.transport.connect(func(): transport_foe(execute, enemy))
		i += 1
		

func transport_foe(execute: TileMapLayer, enemy: CharacterBody2D) -> void:
	enemy.transport_index = (enemy.transport_index + 1) % places.size()
	enemy.teleport(Tile.get_pos(execute, places[enemy.transport_index]))

var foe: Dictionary = {
	"eye-seeker": preload("res://asset/system/scene/subject/actor/enemy/asset/eye-seeker/eye-seeker.tscn")
}
