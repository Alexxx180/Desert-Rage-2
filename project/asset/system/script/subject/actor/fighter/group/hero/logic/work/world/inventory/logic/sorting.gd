extends Node

var effect: Node
var items: Node

enum Sort { ASC = 0, DESC = 1, RANDOM = 2 }
const MAX: int = 25

func get_item(i: int) -> Dictionary:
	return effect.items.get_item(items.storage[i].id)

func more(a, b): a >= b

func determine_sort(r: UseItem, l: UseItem, s: Dictionary, i: int) -> void:
	if s.sort == Sort.RANDOM: return
	
	if s.sort == Sort.ASC and r.get(s.key) <= l.get(s.key): return
	
	if (s.sort == Sort.DESC or s.size == 2) and more(r.get(s.key), l.get(s.key)):
		s.sort = Sort.DESC
	else: s.sort = Sort.RANDOM

func add_usable(s: Dictionary, i: int) -> void:
	var item: Dictionary = get_item(i)
	var l = item.logic
	if l is not UseItem or l.get(s.key) == 0 or items.storage[i].x <= 0: return
	
	if s.size >= 2: determine_sort(s.result[i - 1].logic, l, s, i)
	s.result.append({ "slot": i, "item": item })
	s.size += 1

func use_item(i: Dictionary) -> int:
	return uses_left(effect.use_item(i.slot), i.item.item.name)

func _usage(s: Dictionary, p: Node, condition: Callable) -> int:
	var previous: Dictionary = s.result.front()
	for i in s.result:
		if condition.call(p.points + i.item.logic.get(s.key), p.maximum):
			return use_item(previous)
		previous = i
	return use_item(previous)

func _sort_usage(s: Dictionary, p: Node) -> int:
	match s.sort:
		Sort.ASC: return _usage(s, p, more)
		Sort.DESC: return _usage(s, p, func(a, b): a < b)
	return use_item(s.result.pick_random())

func uses_left(size: int, kind: String = "") -> int:
	if size == 0:
		effect.status.log.add_any(kind + " - расходников не осталось!")
	else:
		effect.status.log.add_any(kind + " - расходников осталось: " + str(size))
	return size

func _usables_search(key: String, p: Node) -> int:
	if p.points == p.maximum:
		effect.status.log.add_any("Рей: Воу-воу, полегче с этим.")
		return 0
	
	var s: Dictionary = { "result": [], "size": 0, "sort": Sort.ASC, "key": key }
	for i in range(0, MAX): add_usable(s, i)
	match s.size:
		0: return uses_left(0)
		1: return use_item(s.result.front())
		_: return _sort_usage(s, p)

func quick_heal() -> void:
	_usables_search("power", effect.status.hero.to.stats.health.points)

func reload_resource() -> void:
	_usables_search("supply", effect.status.hero.to.stats.aura)
