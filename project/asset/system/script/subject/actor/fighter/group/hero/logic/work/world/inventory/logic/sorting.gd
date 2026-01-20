extends Node

enum Sort { ASC = 0, DESC = 1, RANDOM = 2 }
enum { NA = 0, SIZE = 2, MAX = 25 }

var _jars: Dictionary = { "a": [6, 8, 10], "h": [1, 2, 6, 7, 9, 11, 12] }
var effect: Node
var items: Node

func fillable(cell: Variant, key: String) -> bool:
	return cell.drag.ui.get_slot(cell.slot).id in _jars[key]

func _logic(item: Dictionary, s: Dictionary) -> int:
	return item.item.logic.get(s.key)

func get_item(i: int) -> Dictionary:
	return effect.logic.item(items.storage[i].id)

func more(a: int, b: int) -> bool: return a >= b
func desc_sort(cond: bool) -> int: return Sort.DESC if cond else Sort.RANDOM

func determine_sort(p: int, n: int, s: Dictionary) -> void:
	match s.sort:
		Sort.ASC: if not p <= n: s.sort = desc_sort(s.size == SIZE and more(p, n))
		Sort.DESC: if not more(p, n): s.sort = Sort.RANDOM

func _no_use(l: IUse, s: Dictionary, i: int) -> bool:
	return l.get(s.key) == NA or items.storage[i].x <= NA

func add_usable(s: Dictionary, i: int) -> void:
	var it: Dictionary = get_item(i)
	if it.logic is not IUse or _no_use(it.logic, s, i): return
	
	s.result.append({ "slot": i, "item": it })
	s.size += 1
	
	if s.size >= SIZE:
		determine_sort(_logic(s.result[i - 1], s), it.logic.get(s.key), s)

func use_as_slot(slot: int) -> int:
	return use_item({ "slot": slot, "item": get_item(slot) })
	
func use_item(i: Dictionary) -> int:
	return uses_left(effect.use_item(i.slot), i.item.item.name)

func _usage(s: Dictionary, p: Node, condition: Callable) -> int:
	var previous: Dictionary = s.result.front()
	for item in s.result:
		if condition.call(p.points + _logic(item, s), p.maximum):
			return use_item(previous)
		previous = item
	return use_item(previous)

func _sort_usage(s: Dictionary, p: Node) -> int:
	print("Sort is defined as: ", s.sort)
	match s.sort: # Only after sort found
		Sort.ASC: return _usage(s, p, more)
		Sort.DESC: return _usage(s, p, func(a, b): return a < b)
	return use_item(s.result.pick_random())

func uses_left(size: int, kind: String = "") -> int:
	match size:
		-1: effect.status.log.add_any("Рей: Воу-воу, полегче с этим.")
		0: effect.status.log.add_any(kind + " - расходников не осталось!")
		_: effect.status.log.add_any(kind + " - расходников осталось: " + str(size))
	return size

func _usables_search(key: String, p: Node) -> int:
	if p.points == p.maximum: return uses_left(-1)
	
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
