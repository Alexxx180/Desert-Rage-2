extends VBoxContainer

@onready var stats: Array[Label] = [$power, $influence, $vitality, $reaction]
@onready var addon: Array[Array] = [[0, 1], [1, 3], [2, 3]]

func toggle(no: int, method: String) -> void:
	for i in addon[no]: stats[i].get(method).call()

"""
func _toggle_call(i: Array[int]) -> Callable:
	return func(): for j in [[i[0], "hide"], [i[1], "show"]]: _toggle(j[0], j[1])

func _order(next: int) -> Array: return [["nter", [select, next]], ["xit", [next, select]]]

func connect_priority(priority: Button) -> void:
	for method in ["focus", "mouse"]:
		for i in _order(priority.no):
			priority.get("%s_e%s" % [method, i[0]]).connect(_toggle_call(i[1]))
"""
