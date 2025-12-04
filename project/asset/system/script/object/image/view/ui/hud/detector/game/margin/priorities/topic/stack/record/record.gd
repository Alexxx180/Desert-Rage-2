extends VBoxContainer

@onready var description: VBoxContainer = $description
@onready var passive: HBoxContainer = description.get_node("passive/add/ray")
@onready var addon: Dictionary = {
	"pursuit": [passive.get_node("power"), passive.get_node("influence")], 
	"self_control": [passive.get_node("influence"), passive.get_node("reaction")],
	"tenacity": [passive.get_node("vitality"), passive.get_node("reaction")]
}
@onready var priorities: Array[Button] = []
@onready var ranking: HBoxContainer = $ranking

var selected: Array

func _show(nodes: Array) -> void: for h in nodes: h.show()
func _hide(nodes: Array) -> void: for h in nodes: h.hide()

func connect_methods(hint: Array, priority: Button, method: String) -> void:
	for i in [["_entered", selected, hint], ["_exited", hint, selected]]:
		priority.get(method + i[0]).connect(func(): _hide(i[1]); _show(i[2]))

func connect_description(priority: Button) -> void:
	var hint: Array = addon[priority.name]
	for method in ["focus", "mouse"]: connect_methods(hint, priority, method)

func _ready() -> void:
	for caption in ["pursuit", "self_control", "tenacity"]:
		var priority: Button = get_node(caption)
		addon[caption].append(description.get_node(NodePath(caption)))
		# description[priority.name] = passive.get_node(NodePath(caption))
		priorities.append(priority)
		connect_description(priority)
	selected = addon["pursuit"]

func connect_priority_select(summary: Dictionary) -> void:
	for button in priorities:
		button.connect_selection(self, summary)

func set_priorities(level: Node, _stats: Dictionary) -> void:
	for i in range(0, len(priorities)):
		priorities[i].set_priority(i, level.summary)
	_show(selected)

func update_exp(xp: Vector2i, _base_xp: int) -> void:
	for priority in priorities:
		priority.update_exp(xp.x, xp.y)
