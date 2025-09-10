extends Node

const SOURCE: int = 4

@onready var hud_reseter: Timer = $hud

var places: Array[Vector2i]
var hud: EnemyHUD = EnemyHUD.new()

func setup(tags: TileMapLayer, execute: TileMapLayer, casual_mode: bool) -> void:
	hud.set_timer(self)
	if casual_mode: return
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
		enemy.spawn_transport_index = i
		enemy.view.animation.dead.transport.connect(func(): transport_foe(execute, enemy))
		hud.setup(enemy)
		i += 1

func transport_foe(execute: TileMapLayer, enemy: CharacterBody2D) -> void:
	enemy.spawn_transport_index = (enemy.spawn_transport_index + 1) % places.size()
	enemy.teleport(Tile.get_pos(execute, places[enemy.spawn_transport_index]))

var foe: Dictionary = {
	"eye-seeker": preload("res://asset/system/scene/subject/actor/fighter/enemy/asset/eye-seeker/eye-seeker.tscn")
}
