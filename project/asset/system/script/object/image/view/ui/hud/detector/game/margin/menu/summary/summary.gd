extends PanelContainer

@onready var stack: VBoxContainer = $scroll/margin/stack/priority
@onready var desc: VBoxContainer = $scroll/margin/stack/priority/description
@onready var passive: HBoxContainer = desc.get_node("passive/add/ray")
@onready var priorities: Array[Button] = []

var selected: Array
@onready var description: Dictionary = {
	"pursuit": [
		passive.get_node("power"),
		passive.get_node("influence")
	], 
	"self_control": [
		passive.get_node("influence"),
		passive.get_node("reaction")
	],
	"tenacity": [
		passive.get_node("vitality"),
		passive.get_node("reaction")
	]
}

func _show(nodes: Array) -> void: for h in nodes: h.show()
func _hide(nodes: Array) -> void: for h in nodes: h.hide()

func connect_methods(hint: Array, entered, exited) -> void:
	entered.connect(func(): _hide(selected); _show(hint))
	exited.connect(func(): _hide(hint); _show(selected))

func connect_description(priority: Button) -> void:
	var hint: Array = description[priority.name]
	connect_methods(hint, priority.focus_entered, priority.focus_exited)
	connect_methods(hint, priority.mouse_entered, priority.mouse_exited)

func _ready() -> void:
	for caption in ["pursuit", "self_control", "tenacity"]:
		var priority: Button = stack.get_node(caption)
		description[caption].append(desc.get_node(NodePath(caption)))
		# description[priority.name] = passive.get_node(NodePath(caption))
		priorities.append(priority)
		connect_description(priority)
	selected = description["pursuit"]

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
