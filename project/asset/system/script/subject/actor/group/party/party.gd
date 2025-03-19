extends RefCounted

class_name HeroParty

const COUNT: int = 2

var heroes: Array[CharacterBody2D]
var leader: CharacterBody2D: get = get_leader
var follower: CharacterBody2D: get = get_follower
var main: int = -1
var next: int = 0

func get_next() -> int:
	return (main + 1) % COUNT

func set_next() -> void:
	main = get_next()
	next = get_next()

func set_heroes() -> void:
	set_hero(main, false)
	set_hero(next, true)

func show_heroes() -> void:
	show_hero(main, false)
	show_hero(next, true)

func switch_hero(show: bool, process: bool) -> void:
	show_hero(next, show)
	set_hero(next, process)

func regroup_hero(in_group: bool) -> void:
	switch_hero(in_group, in_group)

func get_leader() -> CharacterBody2D: return heroes[main]
func get_follower() -> CharacterBody2D: return heroes[next]

func set_hero(hero: int, visible: bool) -> void:
	Processors.turn(heroes[hero].logic.processors, visible)

func show_hero(hero: int, visible: bool) -> void:
	heroes[hero].visible = visible

func forget_velocity() -> void:
	leader.forget_velocity()

func sync_pos() -> void:
	follower.position = leader.position

func locate(position: Vector2) -> void:
	for hero in heroes: hero.position = position

func get_feet(hero: CharacterBody2D) -> int:
	return hero.logic.processors.input.platforming.jump.feet.floors.F

func same_ground() -> bool:
	return get_feet(leader) == get_feet(follower)
