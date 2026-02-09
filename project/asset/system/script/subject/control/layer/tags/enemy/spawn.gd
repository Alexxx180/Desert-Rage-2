extends Node

const SOURCE = 4

var places: Array[Vector2i]
var lay: Node

func set_spawn(_lay: Node) -> void:
	lay = _lay
	places = lay.tags.layer.get_used_cells_by_id(SOURCE)

func from_pool(no: Dictionary, pool: Node, type: String) -> CharacterBody2D:
	return pool.get(type)[randi_range(0, no[type].size() - 1)].instantiate()

func decide(map: int, type: Array[PackedScene]) -> Array[int]:
	var monsters: Array[int] = []
	for i in range(0, type.size()):
		if Works.is_bit(map, i): monsters.append(i)
	return monsters

func select(pool: Node) -> Dictionary:
	return {
		"foe": decide(lay.tags.layer.monsters, pool.foe),
		"boss": decide(lay.tags.layer.bosses, pool.boss)
	}

func initiate(enemy: CharacterBody2D, i: int, tag: Vector2i) -> void:
	lay.execute.layer.add_child(enemy)
	teleport(enemy, i, lay.execute.get_pos(tag))

func teleport(enemy: CharacterBody2D, spawn: int, tag: Vector2) -> void:
	enemy.spawn_pos = spawn
	enemy.teleport(tag)

func dead(enemy: CharacterBody2D) -> void:
	var i: int = (enemy.spawn_pos + 1) % places.size()
	teleport(enemy, i, lay.execute.get_pos(places[i]))
